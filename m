Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab0BDVjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:39:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:57709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab0BDVjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:39:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FVGtdMCC09WhynwupE6BVJ6Oh/ulUbtnM3Lzrj3uoy+tTHJIswPD2GfK6pdi8sm2O
	xKYiWlfKUUERjlGNSv1Ww==
Date: Thu, 4 Feb 2010 13:39:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jiri Kosina <jkosina@suse.cz>
cc: Lubos Lunak <l.lunak@suse.cz>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: Improving OOM killer
In-Reply-To: <alpine.LNX.2.00.1002041044080.15395@pobox.suse.cz>
Message-ID: <alpine.DEB.2.00.1002041335140.6071@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com> <201002032355.01260.l.lunak@suse.cz> <alpine.DEB.2.00.1002031600490.27918@chino.kir.corp.google.com>
 <alpine.LNX.2.00.1002041044080.15395@pobox.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Jiri Kosina wrote:

> Why does OOM killer care about forkbombs *at all*?
> 

Because the cumulative effects of a forkbomb are detrimental to the 
system and the badness() heursitic favors large memory consumers very 
heavily.  Thus, the forkbomb is never really a strong candidate for oom 
kill since the parent may consume very little memory itself and meanwhile 
KDE or another large memory consumer will get innocently killed instead as 
a result.

> If we really want kernel to detect forkbombs (*), we'd have to establish 
> completely separate infrastructure for that (with its own knobs for tuning 
> and possibilities of disabling it completely).
> 

That's what we're trying to do, we can look at the shear number of 
children that the parent has forked and check for it to be over a certain 
"forkbombing threshold" (which, yes, can be tuned from userspace), the 
uptime of those children, their resident set size, etc., to attempt to 
find a sane heuristic that penalizes them.

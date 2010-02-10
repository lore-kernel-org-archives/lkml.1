Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0BJDKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:10:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35772 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0BJDKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:10:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=r7PUXzb+NgASvs47DNFAdA3jpjgUaQbKnprftXi6u0T6dlHpHyOM9BKbeCCQpdUMO
	WUUFXo3iEAxCeuoAKxcyQ==
Date: Tue, 9 Feb 2010 19:10:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oliver Neukum <oliver@neukum.org>
cc: Jiri Kosina <jkosina@suse.cz>, Lubos Lunak <l.lunak@suse.cz>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: Improving OOM killer
In-Reply-To: <201002050835.30550.oliver@neukum.org>
Message-ID: <alpine.DEB.2.00.1002091906020.31159@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <alpine.LNX.2.00.1002041044080.15395@pobox.suse.cz> <alpine.DEB.2.00.1002041335140.6071@chino.kir.corp.google.com> <201002050835.30550.oliver@neukum.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Oliver Neukum wrote:

> > That's what we're trying to do, we can look at the shear number of 
> > children that the parent has forked and check for it to be over a certain 
> > "forkbombing threshold" (which, yes, can be tuned from userspace), the 
> > uptime of those children, their resident set size, etc., to attempt to 
> > find a sane heuristic that penalizes them.
> 
> Wouldn't it be saner to have a selection by user, so that users that
> are over the overcommit limit are targeted?
> 

It's rather unnecessary for the forkbomb case because then it would 
unfairly penalize any user that runs lots of tasks.  The forkbomb handling 
code is really to prevent either user error, bugs in the application, or 
maliciousness.  The goal isn't necessarily to kill anything that forks an 
egregious amount of tasks (which is why we always prefer a child with a 
seperate address space than a parent, anyway) but rather to try to make 
sure the system is still usable and recoverable.

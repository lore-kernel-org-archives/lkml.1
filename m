Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbZEMXDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbZEMXDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932072AbZEMXBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:01:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:16097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762747AbZEMXBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:01:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=at/coLcSmV0My+uTRkcjE8b+lfr1LZlaNjRKaFS0IPShZMchKYG6lUMhx+rx4sORi
	U0MYY2hULLn9SvC0mduqA==
Date: Wed, 13 May 2009 16:01:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, nigel@tuxonice.net,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/6] mm, PM/Freezer: Disable OOM killer when tasks are
 frozen
In-Reply-To: <20090513154726.0786a27d.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905131558010.26966@chino.kir.corp.google.com>
References: <200905070040.08561.rjw@sisk.pl> <200905101548.57557.rjw@sisk.pl> <200905131032.53624.rjw@sisk.pl> <200905131037.50011.rjw@sisk.pl> <alpine.DEB.2.00.0905131534530.25680@chino.kir.corp.google.com>
 <20090513154726.0786a27d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, Andrew Morton wrote:

> > This allows __GFP_NOFAIL allocations to fail.
> 
> I think that's OK - oom_killer_disable() and __GFP_NOFAIL are
> fundamentally incompatible, and __GFP_NOFAIL is a crock.
> 

Ok, so we need some documentation of that or some notification that we're 
allowing an allocation to fail that has been specified to "retry 
infinitely [because] the caller cannot handle allocation failures."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763403AbZEGUm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763403AbZEGUm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbZEGUmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:42:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbZEGUmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:42:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=x/mjFzqYHJFNdpNm6SSH3dtkENKJcvafXq/difhvO3LY6byq+beQ+R6SyRJbxUHbR
	ncpGPio3z3pTQ2qv34gmg==
Date: Thu, 7 May 2009 13:42:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
In-Reply-To: <200905072238.14558.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0905071340470.6598@chino.kir.corp.google.com>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com> <200905072238.14558.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Rafael J. Wysocki wrote:

> > Third time I'm going to suggest this, and I'd like a response on why it's 
> > not possible instead of being ignored.
> > 
> > All of your tasks are in D state other than kthreads, right?  That means 
> > they won't be in the oom killer (thus no zones are oom locked), so you can 
> > easily do this
> > 
> > 	struct zone *z;
> > 	for_each_populated_zone(z)
> > 		zone_set_flag(z, ZONE_OOM_LOCKED);
> > 
> > and then
> > 
> > 	for_each_populated_zone(z)
> > 		zone_clear_flag(z, ZONE_OOM_LOCKED);
> > 
> > The serialization is done with trylocks so this will never invoke the oom 
> > killer because all zones in the allocator's zonelist will be oom locked.
> > 
> > Why does this not work for you?
> 
> Well, it might work too, but why are you insisting?  How's it better than
> __GFP_NO_OOM_KILL, actually?
> 

Because I agree with Christoph's concerns about needlessly adding 
additional gfp flags; he was responding to the proposed addition of 
__GFP_PANIC which could be handled in other much simpler ways just like 
this flag can as I've shown.

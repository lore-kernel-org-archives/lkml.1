Return-Path: <linux-kernel-owner+w=401wt.eu-S1030994AbXDPV5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030994AbXDPV5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030996AbXDPV5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:57:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40325 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030989AbXDPV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:57:29 -0400
Date: Mon, 16 Apr 2007 23:00:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [AppArmor 39/41] AppArmor: Profile loading and manipulation,
 pathname matching
Message-ID: <20070416230001.3143ada1@the-village.bc.nu>
In-Reply-To: <200704151621.52906.agruen@suse.de>
References: <20070412090809.917795000@suse.de>
	<20070412090849.465428000@suse.de>
	<p733b35903l.fsf@bingen.suse.de>
	<200704151621.52906.agruen@suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> don't actually have to care --- if loading an invalid profile can bring down 
> the system, then that's no worse than an arbitrary module that crashes the 
> machine. Not sure if there will ever be user loadable profiles; at least at 
> that point we had to care.

CAP_SYS_RAWIO is needed to do arbitary patching/loading in the capability
model so if you are using lesser capabilities it is a (minor) capability
rise but not a big problem, just ugly and wanting a fix

> > > +	/*
> > > +	 * Replacement needs to allocate a new aa_task_context for each
> > > +	 * task confined by old_profile.  To do this the profile locks
> > > +	 * are only held when the actual switch is done per task.  While
> > > +	 * looping to allocate a new aa_task_context the old_task list
> > > +	 * may get shorter if tasks exit/change their profile but will
> > > +	 * not get longer as new task will not use old_profile detecting
> > > +	 * that is stale.
> > > +	 */
> > > +	do {
> > > +		new_cxt = aa_alloc_task_context(GFP_KERNEL | __GFP_NOFAIL);
> > 
> > NOFAIL is usually a bad sign. It should be only used if there is no
> > alternative.
> 
> At this point there is no secure alternative to allocating a task context --- 
> except killing the task, maybe.

Can you count the number needed, preallocate them and then when you know
for sure either succeed or fail the operation as a whole ?

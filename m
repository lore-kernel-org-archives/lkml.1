Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbZL3W2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbZL3W2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZL3W2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:28:43 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42284 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZL3W2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:28:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H2MwuSkQoBy5edIIoINW7MkNy2XiY4TB6TMr905gRhIwKKH8Y/LX9u7qG+wzNkF5yi
         nxHDHIAwBV7i1e08ywR9Z2cr9IaqfuB3Dz+4rYIxujPKInSY9oq2Mt8cXynKKmtQVFKD
         ghbhqxmymPxiJ1X/LMxPdgwx8DSbjo9WU1l0k=
Date: Wed, 30 Dec 2009 23:28:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch 1/1] Introduce register_user_hbp_by_pid() and
	unregister_user_hbp_by_pid()
Message-ID: <20091230222837.GI6322@nowhere>
References: <20091217172010.GB5457@in.ibm.com> <20091217172253.GC5457@in.ibm.com> <20091218204744.GC5004@nowhere> <20091221184631.GB24535@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221184631.GB24535@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 12:16:31AM +0530, K.Prasad wrote:
> On Fri, Dec 18, 2009 at 09:47:48PM +0100, Frederic Weisbecker wrote:
> > > +
> > > +	do {
> > > +		mutex_lock(&start->perf_event_mutex);
> > > +		list_for_each_entry_safe(bp, temp_bp, &start->perf_event_list,
> > > +					 owner_entry) {
> > > +			if (bp->attr.type != PERF_TYPE_BREAKPOINT)
> > > +				continue;
> > > +			unregister_hw_breakpoint(bp);
> > > +			break;
> > 
> > Do you really want to unregister all of them? What about those
> > that may have been registered using perf syscall?
> > 
> 
> Seems that I got influenced heavily by the PPC64 design (was coding
> simultaneously for it :-)...will accept a "struct perf_event_attr *" and
> use that to identify appropriate breakpoint.


:)

 
> > And this function needs rcu too.
> > 
> > I don't see any in-kernel user for this new feature.
> > That would be required to integrate it.
> >
> 
> The proposed interfaces, as obvious, are mere wrappers over existing
> (un)register_user_* interfaces, and don't do anything vastly different
> in order to demonstrate them separately.
> 
> I can get a sample kernel module ready - that consumes pid and user-space
> address to track write accesses, if you prefer it.


Ok. The code looks good and useful.

But the usual philosophy in the kernel is to not add code
that is left unused upstream. And samples don't substitute a user.
I'm not sure this is a good idea to merge this.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYJ3VJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYJ3VJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYJ3VJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:09:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbYJ3VJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:09:25 -0400
Date: Thu, 30 Oct 2008 17:09:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH][RFC] x86: add non x86 build configuration
In-Reply-To: <20081030205712.GC24626@elte.hu>
Message-ID: <alpine.DEB.1.10.0810301703110.21031@gandalf.stny.rr.com>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0810292139170.6145@gandalf.stny.rr.com> <20081030195107.GK27407@elte.hu> <alpine.DEB.1.10.0810301602380.19996@gandalf.stny.rr.com>
 <20081030205712.GC24626@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Ingo Molnar wrote:
> > 
> > Hmm, I made it a choice, with the "Normal Config" as default, so 
> > that allyesconfig will not set it. Does it get set for you when you 
> > do an allyesconfig?  I had to do the following:
> 
> hm, indeed.
> 
> Still ... the Kconfig glue looks a bit weird - it's almost never a 
> good idea to put 'NOT' (or any other logic operator) into a config 
> name. Why not make this CONFIG_STANDARD_X86_FEATURES and allow it to 

OK

> be disabled when CONFIG_EMBEDDED is enabled? This way it's not just a 
> debug thing but also a kernel sizing feature.

But this affects other things than simply bloat features, like:

        select HAVE_AOUT if X86_32
        select HAVE_UNSTABLE_SCHED_CLOCK
        select HAVE_IDE
        select HAVE_GENERIC_DMA_COHERENT if X86_32
        select HAVE_EFFICIENT_UNALIGNED_ACCESS

Having an option that lets EMBEDDED turn off some of the above might be 
confusing.

-- Steve


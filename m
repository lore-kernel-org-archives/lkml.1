Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbXGIPb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbXGIPb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbXGIPbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:31:52 -0400
Received: from [212.12.190.92] ([212.12.190.92]:34229 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753740AbXGIPbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:31:51 -0400
From: Al Boldi <a1426z@gawab.com>
To: Pavel Machek <pavel@ucw.cz>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Hibernation Redesign
Date: Mon, 9 Jul 2007 18:30:48 +0300
User-Agent: KMail/1.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200707081737.21932.a1426z@gawab.com> <4691BC0F.8050909@yahoo.com.au> <20070709135205.GB3216@elf.ucw.cz>
In-Reply-To: <20070709135205.GB3216@elf.ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091830.48074.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> > >>from a *new* kernel space/user space that is created by loading a new
> > >>kernel in a manner similar to what is done for kexec crashdumps. 
> > >> Unlike kexec crashdumps, however, it would not require reserving any
> > >> memory at boot, because the necessary memory (maybe 16MB or 64MB) can
> > >> be freed just before hibernating, and device drivers can be properly
> > >> stopped so that DMAs don't stomp over certain memory.

Interesting proposition, which may actually work.  Thanks!

> > >This is the Morton method, isn't it? :) I remember it sounding like a
> > >very good idea when he brought it up, but I can't remember the details
> > >of why it was rejected or what the problems were.
> >
> > Hmm, and it seems like I won't get to know without reliving what
> > looks like an epic flamewar starting.... here:
> >
> >   http://thread.gmane.org/gmane.linux.kernel/374889
> >
> > However from a quick look it seems like the only reason is the RAM
> > overhead of a reserve area. It seems unfortunate that it was
> > dismissed so quickly because of that problem (which could be
> > improved).
>
> Well, the kexec thingy should be able to hibernate a machine, but it
> will not be "software-suspend" any more, and it may be quite a lot of
> work to get it going.
>
> In the end, you'll get rid of freezer problems, but will have two
> kernels to care about, and certainly more conventional design. I do
> not think I have time to try that (and don't think freezer problems
> are _that_ bad in the first place), but some interested soul could
> certainly try it.

Who said we need two kernels?  You could inline it like Xen, which would give 
you one kernel with two modes:  normal and hibernate.


Thanks!

--
Al
  

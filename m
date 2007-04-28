Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbXD1Mmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbXD1Mmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 08:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXD1Mmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 08:42:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37210 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754124AbXD1Mmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 08:42:45 -0400
Date: Sat, 28 Apr 2007 14:42:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ananth@in.ibm.com, prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] include/linux/kprobes.h: always offer
	show_registers() prototype
Message-ID: <20070428124255.GH3468@stusta.de>
References: <20070426234749.GJ3468@stusta.de> <20070427051056.GB9787@in.ibm.com> <20070427163251.209fa828.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070427163251.209fa828.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 04:32:51PM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 10:40:57 +0530
> Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > On Fri, Apr 27, 2007 at 01:47:49AM +0200, Adrian Bunk wrote:
> > > Allow gcc to perform show_registers() type checking also with 
> > > CONFIG_KPROBES=n.
> > 
> > Is kprobes.h the correct place to allow for this change? Perhaps, with
> > Christoph's patch http://marc.info/?l=linux-kernel&m=117432009501114&w=2
> > consolidating the die_notifier code, this could be moved to
> > include/linux/kdebug.h instead?
> > 
> 
> Yes, I think something is definitely wrong here.  If the code is presently
> calling show_registers() with no prototype in scope, it should be emitting
> warnings?

No, it's not a caller but the function itself that is present wiith 
CONFIG_KPROBES=n, giving me warnings with -Wmissing-prototypes.

> Also, yes, kprobes.h is an inappropriate place for this declaration.  It
> should be in include/asm-foo/, I guess.

Currently, we have partially both...

And include/linux/ sounds like a better place it the prototype should be 
the same on all architectures.

> But if we do that, there's an excellent chance of a compile explosion,
> because we also have implementations of show_registers() in
> drivers/net/wireless/ipw2100.c, drivers/usb/gadget/net2280.c,
> drivers/usb/host/ehci-dbg.c, drivers/usb/host/ohci-dbg.c and who knows
> where else.
> 
> So what I'd suggest is that we rename show_registers() to something saner,
> then put the declaration into some arch header file then include that
> header in kprobes.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


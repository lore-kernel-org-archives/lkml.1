Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433Ab0AKDtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab0AKDtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 22:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968Ab0AKDs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 22:48:58 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:59329 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751737Ab0AKDs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 22:48:57 -0500
Message-ID: <4B4A9FAB.5020109@snapgear.com>
Date: Mon, 11 Jan 2010 13:48:59 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven King <sfking@fdwdc.com>
CC: uClinux development list <uclinux-dev@uclinux.org>,
       linux-m68k <linux-m68k@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68knommu: get rid of __do_IRQ and add support for using
 gpio irqs.
References: <200912161915.39692.sfking@fdwdc.com>
In-Reply-To: <200912161915.39692.sfking@fdwdc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Steven,

Steven King wrote:
> Since we now have generic irq support for m68knommu and as __do_IRQ is
> supposed to go away real soon now, I added config GENERIC_HARDIRQS_NO__DO_IRQ
> to m68knommu/Kconfig.  Unfortunately, that produced an unbootable kernel --
> looking at the code for generic_handle_irq in linux/irq.h, the NO__DO_IRQ
> version unconditionally calls desc->handle_irq, which suggests that an irq's
> handle_irq isnt getting initialized in the early boot and indeed, adding an
> initialization of handle_irq in init_IRQ produced a working system.
> 
> I'm not entirely satisfied with that solution as it ignores why we are getting
> an irq when no handler has been setup for it, but in any case, using
> set_irq_chip_and_handler in init_IRQ to initialize all the handlers is the
> right thing to do (or atleast, its what all the other arches do) (and I didnt
> feel like digging out the BDM pod to figure out where the mystery irq is
> coming from).
> 
> Then the real reason I was digging into the irq code is to add support for
> using gpio irqs on the gpios of the parts that support that.  The following
> patch is against 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next
> 
> only the intc-2 gpio irqs have been tested on real hardware.
> 
> ------------------------------
> 
> Get rid of __do_IRQ; use set_irq_chip_and_handler to initialize irqs.  Add
> support for using gpio irqs and setting the edge on external irqs generally.
> 
> Signed-off-by: Steven King <sfking@fdwdc.com>

Applied to the for-linus and for-next branches of the m68knommu git
tree.

Thanks
Greg



> --
> 
>  arch/m68k/include/asm/m520xsim.h             |    3 +
>  arch/m68k/include/asm/m523xsim.h             |    3 +
>  arch/m68k/include/asm/m5249sim.h             |    4 +-
>  arch/m68k/include/asm/m527xsim.h             |    3 +
>  arch/m68knommu/Kconfig                       |    4 ++
>  arch/m68knommu/platform/5272/intc.c          |   39 +++++++++++---
>  arch/m68knommu/platform/68328/ints.c         |    8 +--
>  arch/m68knommu/platform/68360/ints.c         |    8 +--
>  arch/m68knommu/platform/coldfire/intc-2.c    |   76 ++++++++++++++++++++++++--
>  arch/m68knommu/platform/coldfire/intc-simr.c |   68 ++++++++++++++++++++++--
>  arch/m68knommu/platform/coldfire/intc.c      |   59 +++++++++++++++++++--
>  11 files changed, 239 insertions(+), 36 deletions(-)
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

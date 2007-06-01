Return-Path: <linux-kernel-owner+w=401wt.eu-S1763755AbXFAUKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763755AbXFAUKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762577AbXFAUKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:10:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51721 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762271AbXFAUKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:10:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH/WIP] Remove 'irq' argument from all IRQ handlers
References: <464E9739.40909@garzik.org>
Date: Fri, 01 Jun 2007 14:08:55 -0600
In-Reply-To: <464E9739.40909@garzik.org> (Jeff Garzik's message of "Sat, 19
	May 2007 02:20:41 -0400")
Message-ID: <m18xb3zbc8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Attached is the patch and description that represents a current
> work-in-progress, removal of the 'irq' argument passed to all driver IRQ
> handlers.
>
> As this patch demonstrates, the 'irq' argument is useless and practically
> unused.  The vast majority of drivers have this information elsewhere (struct
> pci_dev or private struct).  The cases where it is actually used are as follows:
>
> * a couple Mac drivers have multiple IRQs, and use the irq argument for
> disambiguation purposes.  This can easily be remedied by moving that information
> into the info passed in the normal void* pointer.
>
> * Several ancient ISA drivers, which mainly use it for printk-in-irq-handler
> purposes.  A couple use the irq argument as an index into a structure, which is
> a buggy approach.  I fixed up these.
>
> This can be found in the 'hacking-irq-remove' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
>
>
> Before I will even consider submitting this upstream, this patchset needs
>
> * non-x86[-64] build fixes, and testing
> * update the Mac drivers
> * one more review pass, to make sure everything is kosher
>
> so IOW, not anytime soon :)
>
> Jeff Garzik (12):
>       [irq-remove] Update core irq handling code to omit 'irq' parameter
>       [irq-remove] update sound drivers for new irq handler function sig
>       [irq-remove] update SCSI, ATA, IDE drivers for new irq handler function
> sig
>       [irq-remove] update net drivers for new irq handler function sig
>       driver irq handler arg removal: acorn, atm, block, bluetooth, cdrom
>       driver irq handler arg removal: arch-specific code
>       driver irq handler arg removal: acpi, char, dma, fc4
>       driver irq handler arg removal: i2c, ieee1394, infiniband, input, isdn
>       driver irq handler arg removal: macintosh, media, message, mfd, misc, mmc
>       driver irq handler arg removal: serial, video
>       driver irq handler arg removal: the rest
>       irq-remove: build and warning fixes for 2.6.21

Looks reasonable to me.  In my nefarious plans to make everything use
a struct irq pointer this would certainly help.

The get_irqfunc_irq() function to get the irq for the functions that
still need it looks like a very useful migration path.

Eric

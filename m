Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbXCOLl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbXCOLl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 07:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933483AbXCOLl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 07:41:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54187 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933471AbXCOLl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 07:41:58 -0400
Date: Thu, 15 Mar 2007 17:11:41 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <htejun@gmail.com>, gregkh@suse.de,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, michal.k.k.piotrowski@gmail.com,
       linux-ide@vger.kernel.org, tglx@linutronix.de,
       shemminger@linux-foundation.org, mlord@pobox.com,
       linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ storm and rogue DMA access
Message-ID: <20070315114141.GA10753@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070314152302.GB15600@htj.dyndns.org> <p73fy878pmg.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73fy878pmg.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 10:46:47PM +0100, Andi Kleen wrote:
> Tejun Heo <htejun@gmail.com> writes:
> > 
> > Let's assume there's a device which shares its INTX IRQ line with
> > another device and the other one is already initialized.  During boot,
> > due to BIOS's fault, bad hardware design or sheer bad luck, the device
> > has got a pending IRQ.
> 
> This seems to be also common after kexec during kexec crashdumps
> where the device just continues doing what it did before the crash.
> 

That's true. It happens very frequently in kdump case where underlying device
can very well have pending interrupts while second kernel is booting.
Currently we allow the kernel to disable that irq line and we boot the kernel
with "irqpoll" so that device still operates in polling mode.

But getting this fixed will help. If device interrupts are enabled only after
driver has had a chance to reset the device, things will be better, at least
from kdump perspective.

Thanks
Vivek

Return-Path: <linux-kernel-owner+w=401wt.eu-S1422675AbXCNV42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422675AbXCNV42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422678AbXCNV42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:56:28 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2798 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422675AbXCNV41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:56:27 -0400
Date: Wed, 14 Mar 2007 21:56:06 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       michal.k.k.piotrowski@gmail.com, linux-ide@vger.kernel.org,
       tglx@linutronix.de, shemminger@linux-foundation.org, mlord@pobox.com,
       linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ storm and rogue DMA access
Message-ID: <20070314215605.GA7194@flint.arm.linux.org.uk>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>, gregkh@suse.de,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, michal.k.k.piotrowski@gmail.com,
	linux-ide@vger.kernel.org, tglx@linutronix.de,
	shemminger@linux-foundation.org, mlord@pobox.com,
	linux-pm@lists.osdl.org
References: <20070314152302.GB15600@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314152302.GB15600@htj.dyndns.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:23:02AM +0900, Tejun Heo wrote:
> The problem is that a PCI device can be in any arbitrary when it gets
> enabled and the device has to be enabled for its driver to
> initialize/reset it.  The most common case this causes headache is as
> follows.
> 
> Let's assume there's a device which shares its INTX IRQ line with
> another device and the other one is already initialized.

pci_enable_device() doesn't deal with this; in most PCI setups I've
seen, there is no control at PCI level over whether a device generates
an interrupt on the bus.  Certainly the memory and io command enables
have no effect on the ability of the device to cause an interrupt.

In most cases, only the driver of the device knows how to disable
interrupts on any particular device.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

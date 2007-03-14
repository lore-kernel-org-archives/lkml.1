Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbXCNREY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbXCNREY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXCNREY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:04:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41584 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751910AbXCNREX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:04:23 -0400
Date: Wed, 14 Mar 2007 13:04:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: gregkh@suse.de, Jeff Garzik <jeff@garzik.org>,
       <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <michal.k.k.piotrowski@gmail.com>, <linux-ide@vger.kernel.org>,
       <tglx@linutronix.de>, <shemminger@linux-foundation.org>,
       <mlord@pobox.com>, <linux-pm@lists.osdl.org>
Subject: Re: [linux-pm] [PATCH/RFC] PCI prepare/activate instead of enable
 to avoid IRQ storm and rogue DMA access
In-Reply-To: <20070314152302.GB15600@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.0703141302480.7723-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Tejun Heo wrote:

> Hello, all.
> 
> This patch started off from the following thread.
> 
>   http://thread.gmane.org/gmane.linux.ide/16899
> 
> The problem is that a PCI device can be in any arbitrary when it gets
> enabled and the device has to be enabled for its driver to
> initialize/reset it.  The most common case this causes headache is as
> follows.
> 
> Let's assume there's a device which shares its INTX IRQ line with
> another device and the other one is already initialized.  During boot,
> due to BIOS's fault, bad hardware design or sheer bad luck, the device
> has got a pending IRQ.  When its driver enables the device, the
> pending IRQ hits INTX.  The IRQ line has been enabled by the other
> driver sharing the IRQ but IRQ handler for this device hasn't been
> registered yet.  So, screaming interrupts.  IRQ subsystem shuts up the
> IRQ line in an attempt to save the machine from complete lockup and
> both devices end up dead.

In several cases this problem has indeed come up and been fixed by adding
a PCI quirk routine to turn off the device's pending IRQ.

Alan Stern


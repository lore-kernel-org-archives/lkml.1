Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbXKWVyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbXKWVyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 16:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbXKWVyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 16:54:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:58442 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbXKWVyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 16:54:06 -0500
Subject: Re: Where is the interrupt going?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Al Niessner <Al.Niessner@jpl.nasa.gov>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
Content-Type: text/plain
Date: Sat, 24 Nov 2007 08:53:53 +1100
Message-Id: <1195854833.7195.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-21 at 17:08 -0800, Al Niessner wrote:
> 
> p8620 = pci_get_device (APC8620_VENDOR_ID, APC8620_DEVICE_ID, p8620);
> <... fail if p8620 is 0 ...>
> apcsi[i].ret_val = register_chrdev (MAJOR_NUM,
> 
> DEVICE_NAME,
> 
> &apc8620_ops);
> <... fail if ret_val < 0 ...>
> apcsi[i].board_irq = p8620->irq;
> status = request_irq (apcsi[i].board_irq,
>                                       apc8620_handler,
>                                       IRQF_DISABLED,
>                                       DEVICE_NAME,
>                                       (void*)&apcsi[i]);

First, that's obviously not the proper way to do a PCI driver but I
suppose you know that :-)

Then, make sure you call pci_enable_device() at one point, don't some
platforms perform the actual IRQ routing that late ? (And don't sample
pdev->irq before the pci_enable_device(), sample it afterward).

Cheers,
Ben.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXKZWuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXKZWuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXKZWuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:50:04 -0500
Received: from nmta.jpl.nasa.gov ([137.78.160.108]:34583 "EHLO
	nmta3.jpl.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbXKZWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:50:03 -0500
Subject: Re: Where is the interrupt going?
From: Al Niessner <Al.Niessner@jpl.nasa.gov>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1195854833.7195.24.camel@pasglop>
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
	 <1195854833.7195.24.camel@pasglop>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 14:49:57 -0800
Message-Id: <1196117397.23293.3.camel@morte.jpl.nasa.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: morte.jpl.nasa.gov [137.78.15.44]
X-Source-Sender: Al.Niessner@jpl.nasa.gov
X-AUTH: Authorized
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Yes, as also pointed out by Arjan Van de Ven, I was missing the
pci_enable_device() call. This seems related to the deprecation of
pci_find_device (or something like that) in favor of pci_get_device.
Well, by adding the pci_enable_device it all works well.

On Sat, 2007-11-24 at 08:53 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2007-11-21 at 17:08 -0800, Al Niessner wrote:
> > 
> > p8620 = pci_get_device (APC8620_VENDOR_ID, APC8620_DEVICE_ID, p8620);
> > <... fail if p8620 is 0 ...>
> > apcsi[i].ret_val = register_chrdev (MAJOR_NUM,
> > 
> > DEVICE_NAME,
> > 
> > &apc8620_ops);
> > <... fail if ret_val < 0 ...>
> > apcsi[i].board_irq = p8620->irq;
> > status = request_irq (apcsi[i].board_irq,
> >                                       apc8620_handler,
> >                                       IRQF_DISABLED,
> >                                       DEVICE_NAME,
> >                                       (void*)&apcsi[i]);
> 
> First, that's obviously not the proper way to do a PCI driver but I
> suppose you know that :-)
> 
> Then, make sure you call pci_enable_device() at one point, don't some
> platforms perform the actual IRQ routing that late ? (And don't sample
> pdev->irq before the pci_enable_device(), sample it afterward).
> 
> Cheers,
> Ben.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Al Niessner
818.354.0859

All opinions stated above are mine and do not necessarily reflect those
of JPL or NASA.

--------
|  dS  | >= 0
--------



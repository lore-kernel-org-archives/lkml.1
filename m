Return-Path: <linux-kernel-owner+w=401wt.eu-S936514AbXLQXvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936514AbXLQXvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758687AbXLQXvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:51:12 -0500
Received: from saeurebad.de ([85.214.36.134]:59336 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbXLQXvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:51:12 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, <jgarzik@pobox.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, <wingel@nano-system.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       <james.smart@emulex.com>, <linux-driver@qlogic.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/4] pci: Add pci_enable_device_{io,mem} intefaces
References: <1197932473.576079.142524077033.qpush@grosgo>
Date: Tue, 18 Dec 2007 00:49:57 +0100
In-Reply-To: <1197932473.576079.142524077033.qpush@grosgo> (Benjamin
	Herrenschmidt's message of "Tue, 18 Dec 2007 10:01:13 +1100")
Message-ID: <x7prx4vq3e.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> --- linux-work.orig/drivers/pci/pci.c	2007-12-18 09:37:56.000000000 +1100
> +++ linux-work/drivers/pci/pci.c	2007-12-18 09:38:25.000000000 +1100
> [...]
> +int pci_enable_device_io(struct pci_dev *dev)
> +{
> +	int err;
> +	int i, bars = 0;
> +
> +	if (atomic_add_return(1, &dev->enable_cnt) > 1)
> +		return 0;		/* already enabled */
> +
> +	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
> +		if (dev->resource[i].flags & IORESOURCE_IO)
> +			bars |= (1 << i);
> +
> +	err = do_pci_enable_device(dev, bars);
> +	if (err < 0)
> +		atomic_dec(&dev->enable_cnt);
> +	return err;
> +}
> [...]
> +int pci_enable_device_mem(struct pci_dev *dev)
> +{
> +	int err;
> +	int i, bars = 0;
> +
> +	if (atomic_add_return(1, &dev->enable_cnt) > 1)
> +		return 0;		/* already enabled */
> +
> +	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++)
> +		if (dev->resource[i].flags & IORESOURCE_MEM)
> +			bars |= (1 << i);
> +
> +	err = do_pci_enable_device(dev, bars);
> +	if (err < 0)
> +		atomic_dec(&dev->enable_cnt);
> +	return err;
> +}

These two functions should be refactored, the only difference is the
flag checking.

	Hannes

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZAaQG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZAaQG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 11:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZAaQGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 11:06:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42710 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484AbZAaQGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 11:06:49 -0500
Date: Sat, 31 Jan 2009 16:06:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Hugh Dickins <hugh@veritas.com>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
Message-ID: <20090131160601.5159579d@lxorguk.ukuu.org.uk>
In-Reply-To: <49846A36.5000708@ru.mvista.com>
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
	<20090126191151.18b094e6@lxorguk.ukuu.org.uk>
	<49846A36.5000708@ru.mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> > +	ata_for_each_dev(adev, &ap->link, ENABLED) {
> > +		if (adev->class == ATA_DEV_ATAPI)
> > +			fifo = 0;
> > +	}
> >   
> 
>    Er, couldn't we do that dynamically, based on which device is 
> executing the command now?

Possibly but PCI command cycles are expensive so you'd want to cache the
state and stuff. Better to get it correct firstly.
 
> > +	if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7411) /* FIFO is broken */
> > +		fifo = 0;
> > +
> > +	/* On the later chips the read prefetch bits become no-op bits */
> > +	pci_read_config_byte(pdev, 0x41, &r);
> > +	r &= ~fifobit[ap->port_no];
> >   
> 
>   Why not:
> 
>        r &= ~fifo;

Because then it wouldn't clear the bits if they were set already and we
wanted them off!

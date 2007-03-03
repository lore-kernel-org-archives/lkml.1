Return-Path: <linux-kernel-owner+w=401wt.eu-S2992770AbXCBXsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992770AbXCBXsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992769AbXCBXsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:48:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37257 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992746AbXCBXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:48:13 -0500
Date: Sat, 3 Mar 2007 00:52:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_cmd640: CMD640 PCI support
Message-ID: <20070303005219.3d870c84@lxorguk.ukuu.org.uk>
In-Reply-To: <45E8B28D.7030500@garzik.org>
References: <20070302150306.368e24b9@lxorguk.ukuu.org.uk>
	<45E8B28D.7030500@garzik.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (ap->port_no != 0 && adev->devno != timing->last) {
> > +		pci_write_config_byte(pdev, DRWTIM23, timing->reg58[adev->devno]);
> > +		timing->last = adev->devno;
> > +	}
> 
> It might be worth looking into whether ->dev_select is a better place 
> for this sort of code

It isn't, for any driver because ->dev_select() is used extremely early
before all the setup of modes is even begun. This is why all the PATA
drivers hook qc_issue_prot instead.

> > +	static struct ata_port_info *port_info[2] = { &info, &info };
> > +
> > +	/* CMD640 detected, commiserations */
> > +	pci_write_config_byte(pdev, 0x5C, 0x00);
> 
> magic number

Indeed. Its undocumented magic.

> > +static int cmd640_reinit_one(struct pci_dev *pdev)
> > +{
> > +	return ata_pci_device_resume(pdev);
> > +}
> 
> appears to be useless wrapper

To remind me to add the resume path, which I've now done. Basically the
FIFO fixes go away on a resume ...

Alan

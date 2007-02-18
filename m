Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbXBRUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbXBRUwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXBRUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:52:32 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:15262 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbXBRUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:52:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=lJPkz1tGCLedY/KM7otPGrniCQwiOnGnzZTXKjREi/wrxDF+cCqX4GJD+NSrXUKE5NKi8WqymSj49e5spCWs6jOmVqWVF8PU4uUzMkrEVYmT18dFoMta9OqLMpz8odFrxLDsu53gxOrKsPFMmj2PfOKlNlJCav9MWlyZ67I0Te0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
Subject: Re: [BUG/WARN] Error initialising drivers in PCI
Date: Sun, 18 Feb 2007 21:58:13 +0100
User-Agent: KMail/1.9.5
Cc: gregkh@suse.de, "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
References: <5640c7e00702181153q44678861q9963e7e2de00be8@mail.gmail.com>
In-Reply-To: <5640c7e00702181153q44678861q9963e7e2de00be8@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702182158.13429.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 18 February 2007 20:53, Ian McDonald wrote:
> I'm getting this in my logs when starting up after going from a
> 2.6.20rc5 kernel (which didn't do this) to Linus' latest tree as of 36
> hours ago:
> 
> Feb 18 14:52:32 localhost kernel: [   16.392136] Uniform
> Multi-Platform E-IDE driver Revision: 7.00alpha2
> Feb 18 14:52:32 localhost kernel: [   16.392210] ide: Assuming 33MHz
> system bus speed for PIO modes; override with idebus=xx
> Feb 18 14:52:32 localhost kernel: [   16.395039] Probing IDE interface ide0...
> Feb 18 14:52:32 localhost kernel: [   16.780057] hda: ST315310A, ATA DISK drive
> Feb 18 14:52:32 localhost kernel: [   17.391365] Probing IDE interface ide1...
> Feb 18 14:52:32 localhost kernel: [   18.184752] hdc: LTN485, ATAPI
> CD/DVD-ROM drive
> Feb 18 14:52:32 localhost kernel: [   18.490570] ide0 at
> 0x1f0-0x1f7,0x3f6 on irq 14
> Feb 18 14:52:32 localhost kernel: [   18.490978] ide1 at
> 0x170-0x177,0x376 on irq 15
> Feb 18 14:52:32 localhost kernel: [   18.493214] hda: max request size: 128KiB
> Feb 18 14:52:32 localhost kernel: [   18.493735] hda: 29336832 sectors
> (15020 MB) w/2048KiB Cache, CHS=29104/16/63
> Feb 18 14:52:32 localhost kernel: [   18.493899] hda: cache flushes
> not supported
> Feb 18 14:52:32 localhost kernel: [   18.494530]  hda: hda1 hda2 < hda5 >
> Feb 18 14:52:32 localhost kernel: [   18.536466] ata_piix
> 0000:00:1f.1: version 2.00ac7
> Feb 18 14:52:32 localhost kernel: [   18.536579] ata: 0x1F0 IDE port busy
> Feb 18 14:52:32 localhost kernel: [   18.536583] ata: conflict with ide0
> Feb 18 14:52:32 localhost kernel: [   18.536719] BUG: at
> drivers/pci/pci.c:840 pcim_pin_device()
> Feb 18 14:52:32 localhost kernel: [   18.536786]  [<c0104e91>]
> show_trace_log_lvl+0x1a/0x2f
> Feb 18 14:52:32 localhost kernel: [   18.536897]  [<c01054d1>]
> show_trace+0x12/0x14
> Feb 18 14:52:32 localhost kernel: [   18.536991]  [<c0105583>]
> dump_stack+0x16/0x18
> Feb 18 14:52:32 localhost kernel: [   18.537085]  [<c01d1c45>]
> pcim_pin_device+0x40/0x4d
> Feb 18 14:52:32 localhost kernel: [   18.537201]  [<c024822f>]
> ata_pci_init_one+0x1ac/0x4bb
> Feb 18 14:52:32 localhost kernel: [   18.537330]  [<c024ce7d>]
> piix_init_one+0x418/0x435
> Feb 18 14:52:32 localhost kernel: [   18.537431]  [<c01d424d>]
> pci_device_probe+0x39/0x5b
> Feb 18 14:52:32 localhost kernel: [   18.537528]  [<c021c82f>]
> really_probe+0xbd/0x145
> Feb 18 14:52:32 localhost kernel: [   18.537638]  [<c021c94c>]
> driver_probe_device+0x95/0xa1
> Feb 18 14:52:32 localhost kernel: [   18.537734]  [<c021ca61>]
> __driver_attach+0x6a/0xa1
> Feb 18 14:52:32 localhost kernel: [   18.537829]  [<c021be19>]
> bus_for_each_dev+0x36/0x5b
> Feb 18 14:52:32 localhost kernel: [   18.537925]  [<c021c6a3>]
> driver_attach+0x19/0x1b
> Feb 18 14:52:32 localhost kernel: [   18.538019]  [<c021c109>]
> bus_add_driver+0x6a/0x170
> Feb 18 14:52:32 localhost kernel: [   18.538114]  [<c021cc6c>]
> driver_register+0x79/0x7e
> Feb 18 14:52:32 localhost kernel: [   18.538209]  [<c01d43ca>]
> __pci_register_driver+0x7b/0xa8
> Feb 18 14:52:32 localhost kernel: [   18.538381]  [<c04280d6>]
> piix_init+0x14/0x27
> Feb 18 14:52:32 localhost kernel: [   18.538496]  [<c040f708>] init+0x95/0x17a
> Feb 18 14:52:32 localhost kernel: [   18.538597]  [<c0104b13>]
> kernel_thread_helper+0x7/0x10
> Feb 18 14:52:32 localhost kernel: [   18.538693]  =======================
> Feb 18 14:52:32 localhost kernel: [   18.538752] ata: 0x170 IDE port busy
> Feb 18 14:52:32 localhost kernel: [   18.538756] ata: conflict with ide1
> Feb 18 14:52:32 localhost kernel: [   18.538905] ata_piix: probe of
> 0000:00:1f.1 failed with error -16

Tejun, it seems that resources hacks and devres changes don't mix well.

> Kernel is standard tree with no modifications.
> 
> Relevant code which triggers this from devices/pci/pci.c is:
> void pcim_pin_device(struct pci_dev *pdev)
> {
> 	struct pci_devres *dr;
> 
> 	dr = find_pci_dr(pdev);
> 	WARN_ON(!dr || !dr->disable);
> 	if (dr)
> 		dr->disable = 0;
> }
> 
> and it is the WARN_ON that is the line.
> 
> .config of kernel is attached.
> output of lspci -vv is attached.

Ian, you have an PATA controller so there is no need to use ata_piix.
Just disabling ata_piix should workaround the issue.

> Can you please cc me on any discussions/requests as not subscribed to lkml.
> 
> NB Machine continues with boot and can run after this. Machine is a
> little unstable though but could also be Broadcom 4306 issues as not
> sure these drivers are yet stable on my machine...
> 
> Ian
> -- 
> Web: http://wand.net.nz/~iam4
> Blog: http://iansblog.jandi.co.nz
> WAND Network Research Group

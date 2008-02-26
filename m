Return-Path: <linux-kernel-owner+w=401wt.eu-S1760508AbYBZCQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508AbYBZCQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbYBZCQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:16:00 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:17254 "EHLO
	outbound10-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757586AbYBZCP7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:15:59 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JWTQ9Q-01-MA5-01
Subject: Re: GAK!!!! Re: PCI: AMD SATA IDE mode quirk
From: Crane Cai <crane.cai@amd.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@osdl.org
In-Reply-To: <47C346E2.10908@garzik.org>
References: <200802220059.m1M0xgjZ022717@hera.kernel.org>
	 <20080222094828.2a0124ca@core>  <47C346E2.10908@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Feb 2008 10:15:26 +0800
Message-Id: <1203992126.1320.1.camel@SHAPC235.amd.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
X-OriginalArrivalTime: 26 Feb 2008 02:15:27.0211 (UTC) FILETIME=[73CABBB0:01C8781D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2008-02-26Tue的 06:53 +0800，Jeff Garzik写道：
> Alan Cox wrote:
> >>     Signed-off-by: Crane Cai <crane.cai@amd.com>
> >>     Acked-by: Jeff Garzik <jeff@garzik.org>
> >>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > Vomitted-upon-by: Alan Cox <alan@redhat.com>
> >
> >> -    if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> >> -            u8 tmp;
> >> +    /* set sb600/sb700/sb800 sata to ahci mode */
> >> +    u8 tmp;
> >> 
> >> +    pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
> >> +    if (tmp == 0x01) {
> >
> > CLASS_DEVICE is cached in pdev->class so why not simply do:
> >
> >       if (pdev->class & (1 << 8))
> 
> I agree.  I [obviously] missed this when I ack'd, mainly ack'ing the
> overall change.
> 
> BIOS certainly may modify that PCI config register, but that's before
> the kernel boots.  So, using pdev->class is fine.
> 
>         Jeff

pdev->class is also quirked when resume. We need to reread PCI
configuation on resume.


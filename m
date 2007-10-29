Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbXJ2IuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbXJ2IuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXJ2It6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:49:58 -0400
Received: from 170.Red-213-96-222.staticIP.rima-tde.net ([213.96.222.170]:49345
	"EHLO smtp.ferdyx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXJ2It5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:49:57 -0400
Date: Mon, 29 Oct 2007 08:49:49 +0000
From: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
Message-ID: <20071029084949.19d20323@snowcone>
In-Reply-To: <20071029083333.18a4dab7@the-village.bc.nu>
References: <20071029061532.5d10dfc6@snowcone>
	<20071029083333.18a4dab7@the-village.bc.nu>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_D37LtBxCfTU.4WzcY5x.xMz
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_D37LtBxCfTU.4WzcY5x.xMz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 29 Oct 2007 08:33:33 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > It is not recognised by 2.6.24-rc1. I'm guessing it's because the
> > vendor ID is 0001 rather than something sensible. I patched the
> > kernel as follows:
> 
> A vendor ID of 1 is very very very broken. Do all boards have this or
> do you have a faulty box (perhaps a misprogrammed EEPROM somewhere)

A Google for 0001:8168 finds other mentions of the same board. Looks
like it's a general problem.

> That will match any device 0x8168 not just a realtek one. I'd use
> 0x0001, 0x8168 for the match.

Ok. I've attached an updated patch.

Thanks,
-- 
Ciaran McCreesh
--MP_D37LtBxCfTU.4WzcY5x.xMz
Content-Type: text/x-patch; name=f-190hd-rlt8139.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=f-190hd-rlt8139.patch

--- drivers/net/r8169.c.orig	2007-10-29 05:37:02.000000000 +0000
+++ drivers/net/r8169.c	2007-10-29 08:46:24.000000000 +0000
@@ -165,6 +165,7 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8136), 0, 0, RTL_CFG_2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8167), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_1 },
+	{ PCI_DEVICE(0x0001,			0x8168), 0, 0, RTL_CFG_2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8169), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4300), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AT,		0xc107), 0, 0, RTL_CFG_0 },

--MP_D37LtBxCfTU.4WzcY5x.xMz--

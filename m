Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYLNWu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYLNWu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 17:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYLNWuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 17:50:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:39080 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750870AbYLNWuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 17:50:12 -0500
X-Authenticated: #527675
X-Provags-ID: V01U2FsdGVkX19OaQQRaUNOsTNtvegFWd51ax3c5QyxI01+9ILTnP
	diXhr4iCb+ZtI5
Message-ID: <49458D9C.5080906@gmx.de>
Date: Sun, 14 Dec 2008 23:50:04 +0100
From: Reinhard Nissl <rnissl@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.8.1.17) Gecko/20080922 SUSE/2.0.0.17-0.1 Thunderbird/2.0.0.17 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: greg@kroah.com
Subject: PATCH: mvsas: increase port type detection delay to suit Seagate's
 15k6 drive ST3450856SS 0003
Content-Type: multipart/mixed;
 boundary="------------060706070003030309080708"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060706070003030309080708
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Greg,

I hope you don't mind following your suggestion:

> Also, please cc: the stable developers if you want them to pay attention
> to messages like this.

-------- Original-Nachricht --------
Betreff: Re: PATCH: mvsas: increase port type detection delay to
suit Seagate's 15k6 drive ST3450856SS 0003
Datum: Fri, 12 Dec 2008 21:23:45 +0100
Von: Reinhard Nissl <rnissl@gmx.de>
An: linux-scsi@vger.kernel.org
CC: Ke Wei <kewei@marvell.com>, Jeff Garzik
<jgarzik@redhat.com>,	James Bottomley
<James.Bottomley@hansenpartnership.com>
Referenzen: <493BC76F.3060105@gmx.de> <49405137.9000902@gmx.de>

Hi,

I wonder why no one has dropped me a line so far. I hope you
don't mind CCing you directly. I found your email addresses on
mailing list entries regarding mvsas. I attach the little patch
again for ease of use.

Reinhard Nissl schrieb:

> I increased the delay step by step until loading of mvsas
> reliably detected the drive 200 times in sequence. A much better
> approach would be to monitor the hardware for some flag which
> indicates that port detection has finished, but I do not have any
> hardware documentation.
> 
> BTW: patch is against
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
> 
> Signed-off-by: Reinhard Nissl <rnissl@gmx.de>

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de

--------------060706070003030309080708
Content-Type: text/x-patch;
 name="mvsas.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mvsas.diff"

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 1dd70d7..23e5a87 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2959,7 +2959,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 
 	/* enable auto port detection */
 	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
-	msleep(100);
+	msleep(1100);
 	/* init and reset phys */
 	for (i = 0; i < mvi->chip->n_phy; i++) {
 		u32 lo = be32_to_cpu(*(u32 *)&mvi->sas_addr[4]);


--------------060706070003030309080708--

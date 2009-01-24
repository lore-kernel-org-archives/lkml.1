Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZAXPq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZAXPq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 10:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZAXPqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 10:46:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:43829 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZAXPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 10:46:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=HVsEgwNRQ34P7KlxyaiRYAnj6lNwGTV1GFGP6rPlQuUfR6zLoj9XkHwLgBE4A/pqxy
         s/rVaOlZlNlOVxHxAP5+vXqi5gdts2ZhvjPT6Nht9SgC6qyNeC1UdyRs0ZFPrCQYvgz5
         GJVgm2/ZOpnPKA1r3mAkslkPiFLcZThuwTBHI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH] icside: use struct ide_port_info also for PCB version 5
Date: Sat, 24 Jan 2009 16:46:35 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
References: <200901241514.23036.bzolnier@gmail.com>
In-Reply-To: <200901241514.23036.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901241646.35558.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] icside: use struct ide_port_info also for PCB version 5
> 
> This fixes hwif->channel and drive->dn assignments.
> 
> Cc: Russell King <rmk@arm.linux.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] icside: use struct ide_port_info also for PCB version 5 (v2)

This fixes hwif->channel and drive->dn assignments.

v2:
Fix v5/v6 mismatch noticed by Russell.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/icside.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -419,6 +419,10 @@ static void icside_setup_ports(hw_regs_t
 	hw->chipset = ide_acorn;
 }
 
+static const struct ide_port_info icside_v5_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int __devinit
 icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 {
@@ -445,7 +449,7 @@ icside_register_v5(struct icside_state *
 
 	icside_setup_ports(&hw, base, &icside_cardinfo_v5, ec);
 
-	host = ide_host_alloc(NULL, hws);
+	host = ide_host_alloc(&icside_v5_port_info, hws);
 	if (host == NULL)
 		return -ENODEV;
 
@@ -453,7 +457,7 @@ icside_register_v5(struct icside_state *
 
 	ecard_set_drvdata(ec, state);
 
-	ret = ide_host_register(host, NULL, hws);
+	ret = ide_host_register(host, &icside_v5_port_info, hws);
 	if (ret)
 		goto err_free;
 

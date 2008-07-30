Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbYG3FFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbYG3FFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 01:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYG3FFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 01:05:04 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:28871 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750860AbYG3FFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 01:05:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=pXhOCoz8/TA8fz+mEDvqnA1KN+UAhwOKc58XAoJV9j96bk+zeb+VunW8wUjJpFzvohmZy62ls6LpXNKckAoNz6B3tIHkBHXHPpoO7ZCiuSGWLs4KtNEWwi28FuiDOKK1PaEmL3PNEF4FEN2HVy8Iwlx7k4phhwOtpD9wDbfjqeE=  ;
X-YMail-OSG: 6DPeSaoVM1mWwO6uZQrPa64rwGsaWiiTvMOSHltVosXKrh_EPG3BYqbLkYavisJMCGD.EVxdvknZ6_dh43hmNdM.3O1D6nyltB6mkDA7Ahfc2B7tBenSYc1mAN0nYG334kg-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 29 Jul 2008 22:07:50 -0700
From: David Brownell <david-b@pacbell.net>
To: akpm@linux-foundation.org
Subject: Re: [RESEND x2 PATCH 2.6.26-git 1/2] MTD DataFlash: bugfix, binary 
 page sizes now handled (v3)
Cc: michael.hennerich@analog.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org, cooloney@kernel.org
References: <200807270325.13790.david-b@pacbell.net>
 <20080729213733.3345546a.akpm@linux-foundation.org>
In-Reply-To: <20080729213733.3345546a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080730050750.A4C013608ED@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/mtd/devices/mtd_dataflash.c: In function 'jedec_probe':
> drivers/mtd/devices/mtd_dataflash.c:611: error: incompatible type for argument 1 of 'dev_name'
> drivers/mtd/devices/mtd_dataflash.c:619: error: incompatible type for argument 1 of 'dev_name'
>

It seems the MTD debug facility doesn't follow the (recent)
rule of making debug code subject to dead code elimination
rather than the more error-prone CPP level elimination.
I sense a patch coming ...

The following tweak resolves the stuff above ... do you want
a new patch?

- Dave


--- g26.orig/drivers/mtd/devices/mtd_dataflash.c	2008-07-29 22:00:32.000000000 -0700
+++ g26/drivers/mtd/devices/mtd_dataflash.c	2008-07-29 22:00:17.000000000 -0700
@@ -609,7 +609,7 @@ static struct flash_info *__devinit jede
 			tmp++, info++) {
 		if (info->jedec_id == jedec) {
 			DEBUG(MTD_DEBUG_LEVEL1, "%s: OTP, sector protect%s\n",
-				dev_name(spi->dev),
+				dev_name(&spi->dev),
 				(info->flags & SUP_POW2PS)
 					? ", binary pagesize" : ""
 				);
@@ -618,7 +618,7 @@ static struct flash_info *__devinit jede
 				if (status < 0) {
 					DEBUG(MTD_DEBUG_LEVEL1,
 						"%s: status error %d\n",
-						dev_name(spi->dev), status);
+						dev_name(&spi->dev), status);
 					return ERR_PTR(status);
 				}
 				if (status & 0x1) {

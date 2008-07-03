Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYGCHA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYGCHA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYGCG5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:27035 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYGCBnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:43:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:mime-version
         :content-type:message-id;
        b=sUKCxadfTdLfUlyuOMHobuLn//hNswCkHI3MSGpYqBD1MEpWPcOITYe4c8CTfVota6
         kIfdZ54mbFqsxWjjv1Vk0JMNoWh97xu7xlU6tabggum/x3hPDvZhn6dRkjr4ScY7msfc
         WkE96tN6kRll+eIxykc7bAqL5/tLgn+10e740=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-kernel@vger.kernel.org
Subject: [PATCH] SD card fix
Date: Thu, 3 Jul 2008 03:44:31 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/7CbIW0XxJqAtzl"
Message-Id: <200807030344.31234.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_/7CbIW0XxJqAtzl
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
while I was tinkering with palmtx and preparing it for mainline, I noticed, 
that certain SD cards doesnt work (both Kingston - made by Toshiba).

I came across this 
http://kerneltrap.org/mailarchive/linux-kernel/2007/9/28/325179
The person there had the same problem.

The attached patch fixed it for me, but this solution isnt definitelly 
correct. Though it should point out what's the actual problem very well.

--Boundary-00=_/7CbIW0XxJqAtzl
Content-Type: text/x-diff;
  charset="us-ascii";
  name="toshicard.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="toshicard.patch"

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 0d508ac..ce7828e 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -85,7 +85,6 @@ struct mmc_card {
 	struct mmc_host		*host;		/* the host this device belongs to */
 	struct device		dev;		/* the device */
 	unsigned int		rca;		/* relative card address of device */
-	unsigned int		type;		/* card type */
 #define MMC_TYPE_MMC		0		/* MMC card */
 #define MMC_TYPE_SD		1		/* SD card */
 #define MMC_TYPE_SDIO		2		/* SDIO card */
@@ -98,6 +97,7 @@ struct mmc_card {
 	u32			raw_cid[4];	/* raw card CID */
 	u32			raw_csd[4];	/* raw card CSD */
 	u32			raw_scr[2];	/* raw card SCR */
+	unsigned int		type;		/* card type */
 	struct mmc_cid		cid;		/* card identification */
 	struct mmc_csd		csd;		/* card specific */
 	struct mmc_ext_csd	ext_csd;	/* mmc v4 extended card specific */

--Boundary-00=_/7CbIW0XxJqAtzl--

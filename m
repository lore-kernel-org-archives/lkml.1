Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbYAKMFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbYAKMFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759582AbYAKMDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:43 -0500
Received: from smtp113.plus.mail.re1.yahoo.com ([69.147.102.76]:39728 "HELO
	smtp113.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758765AbYAKMDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=EG7zdPtTLXPrYwj2sE3YKg5KjTK2cVe3AWbYGnnhBuOpManfNaQUgVUlE7XE6Nr0HceiifAamUp3Jzw2ANUE9HBdlRHw6NhrnDJwUIBHdHxEpMoWFGJGt6kVWDw1GrneW2eeMMBuqiY6U7HZcpwTC0v0UdpkvPfR5K1+C4uvhYM=  ;
X-YMail-OSG: H7dBGbAVM1lZkwktkxHbnDN3Un5jcmAl8QtsbtQL8tq.yKkX4Mku.Cz51GpNuhsy8dtfL9gDYw--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 08/21] ide-floppy: remove struct idefloppy_inquiry_result
Date: Fri, 11 Jan 2008 12:58:06 +0100
Message-Id: <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   41 -----------------------------------------
 1 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 5c85833..d98264e 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -232,47 +232,6 @@ struct idefloppy_id_gcw {
 };
 
 /*
- *	INQUIRY packet command - Data Format
- */
-typedef struct {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	device_type	:5;	/* Peripheral Device Type */
-	unsigned	reserved0_765	:3;	/* Peripheral Qualifier - Reserved */
-	unsigned	reserved1_6t0	:7;	/* Reserved */
-	unsigned	rmb		:1;	/* Removable Medium Bit */
-	unsigned	ansi_version	:3;	/* ANSI Version */
-	unsigned	ecma_version	:3;	/* ECMA Version */
-	unsigned	iso_version	:2;	/* ISO Version */
-	unsigned	response_format :4;	/* Response Data Format */
-	unsigned	reserved3_45	:2;	/* Reserved */
-	unsigned	reserved3_6	:1;	/* TrmIOP - Reserved */
-	unsigned	reserved3_7	:1;	/* AENC - Reserved */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	reserved0_765	:3;	/* Peripheral Qualifier - Reserved */
-	unsigned	device_type	:5;	/* Peripheral Device Type */
-	unsigned	rmb		:1;	/* Removable Medium Bit */
-	unsigned	reserved1_6t0	:7;	/* Reserved */
-	unsigned	iso_version	:2;	/* ISO Version */
-	unsigned	ecma_version	:3;	/* ECMA Version */
-	unsigned	ansi_version	:3;	/* ANSI Version */
-	unsigned	reserved3_7	:1;	/* AENC - Reserved */
-	unsigned	reserved3_6	:1;	/* TrmIOP - Reserved */
-	unsigned	reserved3_45	:2;	/* Reserved */
-	unsigned	response_format :4;	/* Response Data Format */
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		additional_length;	/* Additional Length (total_length-4) */
-	u8		rsv5, rsv6, rsv7;	/* Reserved */
-	u8		vendor_id[8];		/* Vendor Identification */
-	u8		product_id[16];		/* Product Identification */
-	u8		revision_level[4];	/* Revision Level */
-	u8		vendor_specific[20];	/* Vendor Specific - Optional */
-	u8		reserved56t95[40];	/* Reserved - Optional */
-						/* Additional information may be returned */
-} idefloppy_inquiry_result_t;
-
-/*
  *	REQUEST SENSE packet command result - Data Format.
  */
 typedef struct {
-- 
1.5.3.7


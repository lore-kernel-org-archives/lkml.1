Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbZKDRfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbZKDRfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZKDRfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:35:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbZKDRfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=S4baHjDFa+3eV55rNM0nlIQF3J1bnjqSS5V1nH53jSEgPopdN2u4ELh2EPFptjqqF/
         d6r2K254vMsI8XCN7ihadzJODqyeW9GoVEb7s5VtauXyFVVTomqAgT1C/pCfH6G+PuII
         YY8U/vfyaKLTX4TK6UI9FLjUeNA7JOZAHSUr8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:35:18 +0100
Message-Id: <20091104173518.28463.61728.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 27/41] rt2x00: fix rt2x00usb_regbusy_read() arguments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2x00: fix rt2x00usb_regbusy_read() arguments

Add const to 'field' argument of rt2x00usb_regbusy_read()
(all arguments match rt2x00pci_regbusy_read() ones now).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.h |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -44,7 +44,7 @@ struct rt2800_ops {
 
 	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
 			    const unsigned int offset,
-			    struct rt2x00_field32 field, u32 *reg);
+			    const struct rt2x00_field32 field, u32 *reg);
 };
 
 static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
Index: b/drivers/net/wireless/rt2x00/rt2x00usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -156,7 +156,7 @@ EXPORT_SYMBOL_GPL(rt2x00usb_vendor_reque
 
 int rt2x00usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
 			   const unsigned int offset,
-			   struct rt2x00_field32 field,
+			   const struct rt2x00_field32 field,
 			   u32 *reg)
 {
 	unsigned int i;
Index: b/drivers/net/wireless/rt2x00/rt2x00usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -365,7 +365,7 @@ static inline void rt2x00usb_register_mu
  */
 int rt2x00usb_regbusy_read(struct rt2x00_dev *rt2x00dev,
 			   const unsigned int offset,
-			   struct rt2x00_field32 field,
+			   const struct rt2x00_field32 field,
 			   u32 *reg);
 
 /*

Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbZKDRff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbZKDRff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162AbZKDRfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:35:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbZKDRfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qFIBxP9Fqr/VyoPbDr6JxYyatQXDQoinZ2iLOJOd3jzWCSV6qItGTn/q2CT01He5JE
         j25+x/d1FPKQHQEMb2A/s8HGfXyM8XtekahM5gp9B6Le9sGMDDR41eq4KnICIJEpad0L
         xWwbot8+vWEd74V5EFSRZ6eep+ekkqwa3zv88=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:35:10 +0100
Message-Id: <20091104173510.28463.24779.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 26/41] rt2x00: fix rt2x00usb_register_multiwrite() arguments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2x00: fix rt2x00usb_register_multiwrite() arguments

Add const to 'value' argument of rt2x00usb_register_multiwrite()
(all arguments match rt2x00pci_register_multiwrite() ones now).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.h |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -40,7 +40,7 @@ struct rt2800_ops {
 				   void *value, const u32 length);
 	void (*register_multiwrite)(struct rt2x00_dev *rt2x00dev,
 				    const unsigned int offset,
-				    void *value, const u32 length);
+				    const void *value, const u32 length);
 
 	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
 			    const unsigned int offset,
Index: b/drivers/net/wireless/rt2x00/rt2x00usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -340,12 +340,13 @@ static inline void rt2x00usb_register_wr
  * through rt2x00usb_vendor_request_buff().
  */
 static inline void rt2x00usb_register_multiwrite(struct rt2x00_dev *rt2x00dev,
-					       const unsigned int offset,
-					       void *value, const u32 length)
+						 const unsigned int offset,
+						 const void *value,
+						 const u32 length)
 {
 	rt2x00usb_vendor_request_buff(rt2x00dev, USB_MULTI_WRITE,
 				      USB_VENDOR_REQUEST_OUT, offset,
-				      value, length,
+				      (void *)value, length,
 				      REGISTER_TIMEOUT32(length));
 }
 

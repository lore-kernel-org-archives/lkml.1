Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbZKDRnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbZKDRnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbZKDRdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:33:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbZKDRdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:33:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=S+YWCp75ujnrLC8YZKn7iR0rKI1JdyXjfKRWEC/XVzUEjCmwNa7K84ueVdH43n86ie
         lYDVutI8frQdlK4tDFmhaLfnmSe4erObyjISJGLI8BPL5VPIQDv8BLoSA163dsm/QwW2
         QsHpG5bxaXN85lFc9YrFLyyH16kphkk0d8Crk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:33:20 +0100
Message-Id: <20091104173320.28463.59233.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/41] rt2800usb: add rt2800_register_multi[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: add rt2800_register_multi[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   16 ++++++++--------
 drivers/net/wireless/rt2x00/rt2800usb.h |   14 ++++++++++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -374,7 +374,7 @@ static void rt2800usb_config_wcid_attr(s
 	    (crypto->cipher == CIPHER_AES))
 		iveiv_entry.iv[3] |= 0x20;
 	iveiv_entry.iv[3] |= key->keyidx << 6;
-	rt2x00usb_register_multiwrite(rt2x00dev, offset,
+	rt2800_register_multiwrite(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
 
 	offset = MAC_WCID_ENTRY(key->hw_key_idx);
@@ -382,7 +382,7 @@ static void rt2800usb_config_wcid_attr(s
 	memset(&wcid_entry, 0, sizeof(wcid_entry));
 	if (crypto->cmd == SET_KEY)
 		memcpy(&wcid_entry, crypto->address, ETH_ALEN);
-	rt2x00usb_register_multiwrite(rt2x00dev, offset,
+	rt2800_register_multiwrite(rt2x00dev, offset,
 				      &wcid_entry, sizeof(wcid_entry));
 }
 
@@ -406,7 +406,7 @@ static int rt2800usb_config_shared_key(s
 		       sizeof(key_entry.rx_mic));
 
 		offset = SHARED_KEY_ENTRY(key->hw_key_idx);
-		rt2x00usb_register_multiwrite(rt2x00dev, offset,
+		rt2800_register_multiwrite(rt2x00dev, offset,
 					      &key_entry, sizeof(key_entry));
 	}
 
@@ -461,7 +461,7 @@ static int rt2800usb_config_pairwise_key
 		       sizeof(key_entry.rx_mic));
 
 		offset = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
-		rt2x00usb_register_multiwrite(rt2x00dev, offset,
+		rt2800_register_multiwrite(rt2x00dev, offset,
 					      &key_entry, sizeof(key_entry));
 	}
 
@@ -549,7 +549,7 @@ static void rt2800usb_config_intf(struct
 		rt2x00_set_field32(&reg, MAC_ADDR_DW1_UNICAST_TO_ME_MASK, 0xff);
 		conf->mac[1] = cpu_to_le32(reg);
 
-		rt2x00usb_register_multiwrite(rt2x00dev, MAC_ADDR_DW0,
+		rt2800_register_multiwrite(rt2x00dev, MAC_ADDR_DW0,
 					      conf->mac, sizeof(conf->mac));
 	}
 
@@ -559,7 +559,7 @@ static void rt2800usb_config_intf(struct
 		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_BCN_NUM, 0);
 		conf->bssid[1] = cpu_to_le32(reg);
 
-		rt2x00usb_register_multiwrite(rt2x00dev, MAC_BSSID_DW0,
+		rt2800_register_multiwrite(rt2x00dev, MAC_BSSID_DW0,
 					      conf->bssid, sizeof(conf->bssid));
 	}
 }
@@ -1458,7 +1458,7 @@ static int rt2800usb_init_registers(stru
 
 	for (i = 0; i < 256; i++) {
 		u32 wcid[2] = { 0xffffffff, 0x00ffffff };
-		rt2x00usb_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
+		rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
 					      wcid, sizeof(wcid));
 
 		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
@@ -2646,7 +2646,7 @@ static void rt2800usb_get_tkip_seq(struc
 	u32 offset;
 
 	offset = MAC_IVEIV_ENTRY(hw_key_idx);
-	rt2x00usb_register_multiread(rt2x00dev, offset,
+	rt2800_register_multiread(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
 
 	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -48,6 +48,20 @@ static inline void rt2800_register_write
 	rt2x00usb_register_write_lock(rt2x00dev, offset, value);
 }
 
+static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
+					     const unsigned int offset,
+					     void *value, const u32 length)
+{
+	rt2x00usb_register_multiread(rt2x00dev, offset, value, length);
+}
+
+static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
+					      const unsigned int offset,
+					      void *value, const u32 length)
+{
+	rt2x00usb_register_multiwrite(rt2x00dev, offset, value, length);
+}
+
 /*
  * RF chip defines.
  *

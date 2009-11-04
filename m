Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZKDRdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZKDRdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162AbZKDRds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:33:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbZKDRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:33:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bTVHwVYC7f4Zk1SkW45o0Ag/ikAy5sZnBt7WxSX7n0HN1yRwF+n9t6cUQn+1IfH5IJ
         /BU+WOpu0WSLAOKUNYAV6ARWUUWkcCzRPJltpyTfTo2VRTFAR/8ORw0eqcpjWd7CAvqh
         q8hsElu5iDkhnl9ZvMFiH4mdN4kVKbVE0Q3X8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:33:27 +0100
Message-Id: <20091104173327.28463.25410.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/41] rt2800pci: add rt2800_register_multi[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: add rt2800_register_multi[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   22 +++++++++++-----------
 drivers/net/wireless/rt2x00/rt2800pci.h |   15 +++++++++++++++
 2 files changed, 26 insertions(+), 11 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -525,7 +525,7 @@ static void rt2800pci_config_wcid_attr(s
 	    (crypto->cipher == CIPHER_AES))
 		iveiv_entry.iv[3] |= 0x20;
 	iveiv_entry.iv[3] |= key->keyidx << 6;
-	rt2x00pci_register_multiwrite(rt2x00dev, offset,
+	rt2800_register_multiwrite(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
 
 	offset = MAC_WCID_ENTRY(key->hw_key_idx);
@@ -533,7 +533,7 @@ static void rt2800pci_config_wcid_attr(s
 	memset(&wcid_entry, 0, sizeof(wcid_entry));
 	if (crypto->cmd == SET_KEY)
 		memcpy(&wcid_entry, crypto->address, ETH_ALEN);
-	rt2x00pci_register_multiwrite(rt2x00dev, offset,
+	rt2800_register_multiwrite(rt2x00dev, offset,
 				      &wcid_entry, sizeof(wcid_entry));
 }
 
@@ -557,7 +557,7 @@ static int rt2800pci_config_shared_key(s
 		       sizeof(key_entry.rx_mic));
 
 		offset = SHARED_KEY_ENTRY(key->hw_key_idx);
-		rt2x00pci_register_multiwrite(rt2x00dev, offset,
+		rt2800_register_multiwrite(rt2x00dev, offset,
 					      &key_entry, sizeof(key_entry));
 	}
 
@@ -613,7 +613,7 @@ static int rt2800pci_config_pairwise_key
 		       sizeof(key_entry.rx_mic));
 
 		offset = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
-		rt2x00pci_register_multiwrite(rt2x00dev, offset,
+		rt2800_register_multiwrite(rt2x00dev, offset,
 					      &key_entry, sizeof(key_entry));
 	}
 
@@ -701,7 +701,7 @@ static void rt2800pci_config_intf(struct
 		rt2x00_set_field32(&reg, MAC_ADDR_DW1_UNICAST_TO_ME_MASK, 0xff);
 		conf->mac[1] = cpu_to_le32(reg);
 
-		rt2x00pci_register_multiwrite(rt2x00dev, MAC_ADDR_DW0,
+		rt2800_register_multiwrite(rt2x00dev, MAC_ADDR_DW0,
 					      conf->mac, sizeof(conf->mac));
 	}
 
@@ -711,7 +711,7 @@ static void rt2800pci_config_intf(struct
 		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_BCN_NUM, 0);
 		conf->bssid[1] = cpu_to_le32(reg);
 
-		rt2x00pci_register_multiwrite(rt2x00dev, MAC_BSSID_DW0,
+		rt2800_register_multiwrite(rt2x00dev, MAC_BSSID_DW0,
 					      conf->bssid, sizeof(conf->bssid));
 	}
 }
@@ -1296,7 +1296,7 @@ static int rt2800pci_load_firmware(struc
 	/*
 	 * Write firmware to device.
 	 */
-	rt2x00pci_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
+	rt2800_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
 				      data, len);
 
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000);
@@ -1612,7 +1612,7 @@ static int rt2800pci_init_registers(stru
 
 	for (i = 0; i < 256; i++) {
 		u32 wcid[2] = { 0xffffffff, 0x00ffffff };
-		rt2x00pci_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
+		rt2800_register_multiwrite(rt2x00dev, MAC_WCID_ENTRY(i),
 					      wcid, sizeof(wcid));
 
 		rt2800_register_write(rt2x00dev, MAC_WCID_ATTR_ENTRY(i), 1);
@@ -2276,10 +2276,10 @@ static void rt2800pci_write_beacon(struc
 	 * Write entire beacon with descriptor to register.
 	 */
 	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2x00pci_register_multiwrite(rt2x00dev,
+	rt2800_register_multiwrite(rt2x00dev,
 				      beacon_base,
 				      skbdesc->desc, skbdesc->desc_len);
-	rt2x00pci_register_multiwrite(rt2x00dev,
+	rt2800_register_multiwrite(rt2x00dev,
 				      beacon_base + skbdesc->desc_len,
 				      entry->skb->data, entry->skb->len);
 
@@ -3010,7 +3010,7 @@ static void rt2800pci_get_tkip_seq(struc
 	u32 offset;
 
 	offset = MAC_IVEIV_ENTRY(hw_key_idx);
-	rt2x00pci_register_multiread(rt2x00dev, offset,
+	rt2800_register_multiread(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
 
 	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -48,6 +48,21 @@ static inline void rt2800_register_write
 	rt2x00pci_register_write(rt2x00dev, offset, value);
 }
 
+static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
+					     const unsigned int offset,
+					     void *value, const u16 length)
+{
+	rt2x00pci_register_multiread(rt2x00dev, offset, value, length);
+}
+
+static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
+					      const unsigned int offset,
+					      const void *value,
+					      const u16 length)
+{
+	rt2x00pci_register_multiwrite(rt2x00dev, offset, value, length);
+}
+
 /*
  * RF chip defines.
  *

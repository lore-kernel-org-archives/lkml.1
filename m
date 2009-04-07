Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZDGVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZDGVeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbZDGVeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:34:00 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:48701 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbZDGVd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:33:59 -0400
Date: Tue, 7 Apr 2009 23:33:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: agnx - make input parameters const
Message-ID: <Pine.LNX.4.64.0904072333380.23311@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| drivers/staging/agnx/pci.c:317: warning: passing argument 2 of 'agnx_set_bssid' discards qualifiers from pointer target
| drivers/staging/agnx/pci.c:319: warning: passing argument 2 of 'hash_write' discards qualifiers from pointer target type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/agnx/phy.c |    4 ++--
 drivers/staging/agnx/phy.h |    2 +-
 drivers/staging/agnx/sta.c |    2 +-
 drivers/staging/agnx/sta.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/agnx/phy.c b/drivers/staging/agnx/phy.c
index 2be6331..ec1ca86 100644
--- a/drivers/staging/agnx/phy.c
+++ b/drivers/staging/agnx/phy.c
@@ -118,7 +118,7 @@ static void mac_address_set(struct agnx_priv *priv)
 	iowrite32(reg, ctl + AGNX_RXM_MACLO);
 }
 
-static void receiver_bssid_set(struct agnx_priv *priv, u8 *bssid)
+static void receiver_bssid_set(struct agnx_priv *priv, const u8 *bssid)
 {
 	void __iomem *ctl = priv->ctl;
 	u32 reg;
@@ -954,7 +954,7 @@ int agnx_set_ssid(struct agnx_priv *priv, u8 *ssid, size_t ssid_len)
 	return 0;
 }
 
-void agnx_set_bssid(struct agnx_priv *priv, u8 *bssid)
+void agnx_set_bssid(struct agnx_priv *priv, const u8 *bssid)
 {
 	receiver_bssid_set(priv, bssid);
 }
diff --git a/drivers/staging/agnx/phy.h b/drivers/staging/agnx/phy.h
index 55e1e22..a955f05 100644
--- a/drivers/staging/agnx/phy.h
+++ b/drivers/staging/agnx/phy.h
@@ -401,7 +401,7 @@ u8 read_from_eeprom(struct agnx_priv *priv, u16 address);
 void agnx_hw_init(struct agnx_priv *priv);
 int agnx_hw_reset(struct agnx_priv *priv);
 int agnx_set_ssid(struct agnx_priv *priv, u8 *ssid, size_t ssid_len);
-void agnx_set_bssid(struct agnx_priv *priv, u8 *bssid);
+void agnx_set_bssid(struct agnx_priv *priv, const u8 *bssid);
 void enable_power_saving(struct agnx_priv *priv);
 void disable_power_saving(struct agnx_priv *priv);
 void calibrate_antenna_period(unsigned long data);
diff --git a/drivers/staging/agnx/sta.c b/drivers/staging/agnx/sta.c
index 5b2d54a..3e7db5e 100644
--- a/drivers/staging/agnx/sta.c
+++ b/drivers/staging/agnx/sta.c
@@ -22,7 +22,7 @@ void hash_read(struct agnx_priv *priv, u32 reghi, u32 reglo, u8 sta_id)
 	printk(PFX "RX hash cmd are : %.8x%.8x\n", reghi, reglo);
 }
 
-void hash_write(struct agnx_priv *priv, u8 *mac_addr, u8 sta_id)
+void hash_write(struct agnx_priv *priv, const u8 *mac_addr, u8 sta_id)
 {
 	void __iomem *ctl = priv->ctl;
 	u32 reghi, reglo;
diff --git a/drivers/staging/agnx/sta.h b/drivers/staging/agnx/sta.h
index 94e2cf1..fd504e3 100644
--- a/drivers/staging/agnx/sta.h
+++ b/drivers/staging/agnx/sta.h
@@ -201,7 +201,7 @@ struct agnx_beacon_hdr {
 	/* 802.11(abg) beacon */
 } __attribute__((__packed__));
 
-void hash_write(struct agnx_priv *priv, u8 *mac_addr, u8 sta_id);
+void hash_write(struct agnx_priv *priv, const u8 *mac_addr, u8 sta_id);
 void hash_dump(struct agnx_priv *priv, u8 sta_id);
 void hash_read(struct agnx_priv *priv, u32 reghi, u32 reglo, u8 sta_id);
 void hash_delete(struct agnx_priv *priv, u32 reghi, u32 reglo, u8 sta_id);
-- 
1.6.2.1


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

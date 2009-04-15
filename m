Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZDOG3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZDOG3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZDOG2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:28:53 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49590 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZDOG2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:28:52 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH resend 5/8] staging: agnx, fix bssid compiler warnings
Date: Wed, 15 Apr 2009 08:28:44 +0200
Message-Id: <1239776927-16168-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
References: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

conf->bssid is const. Propagate const to not get compiler warnings:
agnx/pci.c: In function ‘agnx_config_interface’:
agnx/pci.c:319: warning: passing argument 2 of ‘agnx_set_bssid’ discards qualifiers from pointer target type
agnx/pci.c:321: warning: passing argument 2 of ‘hash_write’ discards qualifiers from pointer target type

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
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
1.6.2


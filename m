Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbZLFAgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbZLFAgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 19:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933612AbZLFAgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 19:36:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56157 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933610AbZLFAf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 19:35:59 -0500
Message-ID: <4B1AFCE2.7060201@gmail.com>
Date: Sun, 06 Dec 2009 01:37:54 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/31] Constify struct e1000_mac_operations for net-next-2.6
 v1
References: <4B198670.2000406@gmail.com> <4B198A33.7080705@gmail.com>
In-Reply-To: <4B198A33.7080705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct e1000_mac_operations with some exceptions.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/net/e1000e/82571.c    |    3 ++-
 drivers/net/e1000e/e1000.h    |    2 +-
 drivers/net/e1000e/es2lan.c   |    3 ++-
 drivers/net/e1000e/hw.h       |    1 +
 drivers/net/e1000e/ich8lan.c  |    2 +-
 drivers/net/igb/e1000_82575.c |    2 +-
 drivers/net/igb/e1000_hw.h    |    3 ++-
 drivers/net/igbvf/vf.h        |    1 +
 8 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index c1a42cf..f388cba 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -207,6 +207,7 @@ static s32 e1000_init_mac_params_82571(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	struct e1000_mac_info *mac = &hw->mac;
+	/* cannot be const, see this function */
 	struct e1000_mac_operations *func = &mac->ops;
 	u32 swsm = 0;
 	u32 swsm2 = 0;
@@ -1692,7 +1693,7 @@ static void e1000_clear_hw_cntrs_82571(struct e1000_hw *hw)
 	er32(ICRXDMTC);
 }
 
-static struct e1000_mac_operations e82571_mac_ops = {
+static const struct e1000_mac_operations e82571_mac_ops = {
 	/* .check_mng_mode: mac type dependent */
 	/* .check_for_link: media type dependent */
 	.id_led_init		= e1000e_id_led_init,
diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index cebbd90..68e66b2 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -379,7 +379,7 @@ struct e1000_info {
 	u32			pba;
 	u32			max_hw_frame_size;
 	s32			(*get_variants)(struct e1000_adapter *);
-	struct e1000_mac_operations *mac_ops;
+	const struct e1000_mac_operations *mac_ops;
 	struct e1000_phy_operations *phy_ops;
 	struct e1000_nvm_operations *nvm_ops;
 };
diff --git a/drivers/net/e1000e/es2lan.c b/drivers/net/e1000e/es2lan.c
index d2a1047..c44d30a 100644
--- a/drivers/net/e1000e/es2lan.c
+++ b/drivers/net/e1000e/es2lan.c
@@ -202,6 +202,7 @@ static s32 e1000_init_mac_params_80003es2lan(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	struct e1000_mac_info *mac = &hw->mac;
+	/* cannot be const, see this function */
 	struct e1000_mac_operations *func = &mac->ops;
 
 	/* Set media type */
@@ -1369,7 +1370,7 @@ static void e1000_clear_hw_cntrs_80003es2lan(struct e1000_hw *hw)
 	er32(ICRXDMTC);
 }
 
-static struct e1000_mac_operations es2_mac_ops = {
+static const struct e1000_mac_operations es2_mac_ops = {
 	.id_led_init		= e1000e_id_led_init,
 	.check_mng_mode		= e1000e_check_mng_mode_generic,
 	/* check_for_link dependent on media type */
diff --git a/drivers/net/e1000e/hw.h b/drivers/net/e1000e/hw.h
index a7d08da..2238d4d 100644
--- a/drivers/net/e1000e/hw.h
+++ b/drivers/net/e1000e/hw.h
@@ -791,6 +791,7 @@ struct e1000_nvm_operations {
 };
 
 struct e1000_mac_info {
+	/* cannot be const, see drivers/net/e1000e/ich8lan.c:e1000_init_mac_params_ich8lan */
 	struct e1000_mac_operations ops;
 
 	u8 addr[6];
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 7b33be9..614a0d4 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -3291,7 +3291,7 @@ static void e1000_clear_hw_cntrs_ich8lan(struct e1000_hw *hw)
 	}
 }
 
-static struct e1000_mac_operations ich8_mac_ops = {
+static const struct e1000_mac_operations ich8_mac_ops = {
 	.id_led_init		= e1000e_id_led_init,
 	.check_mng_mode		= e1000_check_mng_mode_ich8lan,
 	.check_for_link		= e1000_check_for_copper_link_ich8lan,
diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index e8e9e91..34b847a 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -1585,7 +1585,7 @@ u16 igb_rxpbs_adjust_82580(u32 data)
 	return ret_val;
 }
 
-static struct e1000_mac_operations e1000_mac_ops_82575 = {
+static const struct e1000_mac_operations e1000_mac_ops_82575 = {
 	.init_hw              = igb_init_hw_82575,
 	.check_for_link       = igb_check_for_link_82575,
 	.rar_set              = igb_rar_set,
diff --git a/drivers/net/igb/e1000_hw.h b/drivers/net/igb/e1000_hw.h
index dbaeb5f..854b252 100644
--- a/drivers/net/igb/e1000_hw.h
+++ b/drivers/net/igb/e1000_hw.h
@@ -324,7 +324,7 @@ struct e1000_nvm_operations {
 
 struct e1000_info {
 	s32 (*get_invariants)(struct e1000_hw *);
-	struct e1000_mac_operations *mac_ops;
+	const struct e1000_mac_operations *mac_ops;
 	struct e1000_phy_operations *phy_ops;
 	struct e1000_nvm_operations *nvm_ops;
 };
@@ -332,6 +332,7 @@ struct e1000_info {
 extern const struct e1000_info e1000_82575_info;
 
 struct e1000_mac_info {
+	/* cannot be const, see drivers/net/igb/e1000_82575.c:igb_get_invariants_82575 */
 	struct e1000_mac_operations ops;
 
 	u8 addr[6];
diff --git a/drivers/net/igbvf/vf.h b/drivers/net/igbvf/vf.h
index 1e8ce37..4f12659 100644
--- a/drivers/net/igbvf/vf.h
+++ b/drivers/net/igbvf/vf.h
@@ -189,6 +189,7 @@ struct e1000_mac_operations {
 };
 
 struct e1000_mac_info {
+	/* cannot be const, see drivers/net/igbvf/vf.c:e1000_init_mac_params_vf */
 	struct e1000_mac_operations ops;
 	u8 addr[6];
 	u8 perm_addr[6];


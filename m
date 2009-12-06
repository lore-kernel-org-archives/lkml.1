Return-Path: <linux-kernel-owner+w=401wt.eu-S933642AbZLFAgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642AbZLFAgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 19:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbZLFAgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 19:36:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933634AbZLFAgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 19:36:06 -0500
Message-ID: <4B1AFCEB.5050103@gmail.com>
Date: Sun, 06 Dec 2009 01:38:03 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/31] Constify struct e1000_phy_operations for net-next-2.6
 v1
References: <4B198670.2000406@gmail.com> <4B198AE3.2040003@gmail.com>
In-Reply-To: <4B198AE3.2040003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct e1000_phy_operations with some exceptions.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/net/e1000e/82571.c    |    6 +++---
 drivers/net/e1000e/e1000.h    |    2 +-
 drivers/net/e1000e/es2lan.c   |    2 +-
 drivers/net/e1000e/hw.h       |    1 +
 drivers/net/e1000e/ich8lan.c  |    2 +-
 drivers/net/igb/e1000_82575.c |    2 +-
 drivers/net/igb/e1000_hw.h    |    3 ++-
 7 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index c1a42cf..d51b8ca 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1712,7 +1712,7 @@ static struct e1000_mac_operations e82571_mac_ops = {
 	.setup_led		= e1000e_setup_led_generic,
 };
 
-static struct e1000_phy_operations e82_phy_ops_igp = {
+static const struct e1000_phy_operations e82_phy_ops_igp = {
 	.acquire		= e1000_get_hw_semaphore_82571,
 	.check_polarity		= e1000_check_polarity_igp,
 	.check_reset_block	= e1000e_check_reset_block_generic,
@@ -1730,7 +1730,7 @@ static struct e1000_phy_operations e82_phy_ops_igp = {
 	.cfg_on_link_up      	= NULL,
 };
 
-static struct e1000_phy_operations e82_phy_ops_m88 = {
+static const struct e1000_phy_operations e82_phy_ops_m88 = {
 	.acquire		= e1000_get_hw_semaphore_82571,
 	.check_polarity		= e1000_check_polarity_m88,
 	.check_reset_block	= e1000e_check_reset_block_generic,
@@ -1748,7 +1748,7 @@ static struct e1000_phy_operations e82_phy_ops_m88 = {
 	.cfg_on_link_up      	= NULL,
 };
 
-static struct e1000_phy_operations e82_phy_ops_bm = {
+static const struct e1000_phy_operations e82_phy_ops_bm = {
 	.acquire		= e1000_get_hw_semaphore_82571,
 	.check_polarity		= e1000_check_polarity_m88,
 	.check_reset_block	= e1000e_check_reset_block_generic,
diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index cebbd90..e6dada1 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -380,7 +380,7 @@ struct e1000_info {
 	u32			max_hw_frame_size;
 	s32			(*get_variants)(struct e1000_adapter *);
 	struct e1000_mac_operations *mac_ops;
-	struct e1000_phy_operations *phy_ops;
+	const struct e1000_phy_operations *phy_ops;
 	struct e1000_nvm_operations *nvm_ops;
 };
 
diff --git a/drivers/net/e1000e/es2lan.c b/drivers/net/e1000e/es2lan.c
index d2a1047..ce3049d 100644
--- a/drivers/net/e1000e/es2lan.c
+++ b/drivers/net/e1000e/es2lan.c
@@ -1389,7 +1389,7 @@ static struct e1000_mac_operations es2_mac_ops = {
 	.setup_led		= e1000e_setup_led_generic,
 };
 
-static struct e1000_phy_operations es2_phy_ops = {
+static const struct e1000_phy_operations es2_phy_ops = {
 	.acquire		= e1000_acquire_phy_80003es2lan,
 	.check_polarity		= e1000_check_polarity_m88,
 	.check_reset_block	= e1000e_check_reset_block_generic,
diff --git a/drivers/net/e1000e/hw.h b/drivers/net/e1000e/hw.h
index a7d08da..8256b2f 100644
--- a/drivers/net/e1000e/hw.h
+++ b/drivers/net/e1000e/hw.h
@@ -827,6 +827,7 @@ struct e1000_mac_info {
 };
 
 struct e1000_phy_info {
+	/* cannot be const, see drivers/net/e1000e/82571.c:e1000_init_phy_params_82571 */
 	struct e1000_phy_operations ops;
 
 	enum e1000_phy_type type;
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 7b33be9..01d56dc 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -3309,7 +3309,7 @@ static struct e1000_mac_operations ich8_mac_ops = {
 	/* id_led_init dependent on mac type */
 };
 
-static struct e1000_phy_operations ich8_phy_ops = {
+static const struct e1000_phy_operations ich8_phy_ops = {
 	.acquire		= e1000_acquire_swflag_ich8lan,
 	.check_reset_block	= e1000_check_reset_block_ich8lan,
 	.commit			= NULL,
diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index e8e9e91..0561e55 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -1593,7 +1593,7 @@ static struct e1000_mac_operations e1000_mac_ops_82575 = {
 	.get_speed_and_duplex = igb_get_speed_and_duplex_copper,
 };
 
-static struct e1000_phy_operations e1000_phy_ops_82575 = {
+static const struct e1000_phy_operations e1000_phy_ops_82575 = {
 	.acquire              = igb_acquire_phy_82575,
 	.get_cfg_done         = igb_get_cfg_done_82575,
 	.release              = igb_release_phy_82575,
diff --git a/drivers/net/igb/e1000_hw.h b/drivers/net/igb/e1000_hw.h
index dbaeb5f..3ae2bd5 100644
--- a/drivers/net/igb/e1000_hw.h
+++ b/drivers/net/igb/e1000_hw.h
@@ -325,7 +325,7 @@ struct e1000_nvm_operations {
 struct e1000_info {
 	s32 (*get_invariants)(struct e1000_hw *);
 	struct e1000_mac_operations *mac_ops;
-	struct e1000_phy_operations *phy_ops;
+	const struct e1000_phy_operations *phy_ops;
 	struct e1000_nvm_operations *nvm_ops;
 };
 
@@ -377,6 +377,7 @@ struct e1000_mac_info {
 };
 
 struct e1000_phy_info {
+	/* cannot be const, see drivers/net/igb/e1000_82575.c:igb_get_invariants_82575 */
 	struct e1000_phy_operations ops;
 
 	enum e1000_phy_type type;


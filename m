Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbZLFAhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbZLFAhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 19:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbZLFAhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 19:37:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56363 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933615AbZLFAhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 19:37:13 -0500
Message-ID: <4B1AFCE8.3090208@gmail.com>
Date: Sun, 06 Dec 2009 01:38:00 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/31] Constify struct e1000_nvm_operations for net-next-2.6
 v1
References: <4B198670.2000406@gmail.com> <4B198A7E.4080407@gmail.com>
In-Reply-To: <4B198A7E.4080407@gmail.com>
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

Constify struct e1000_nvm_operations with some exceptions.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/net/e1000e/82571.c    |    2 +-
 drivers/net/e1000e/e1000.h    |    2 +-
 drivers/net/e1000e/es2lan.c   |    2 +-
 drivers/net/e1000e/hw.h       |   16 ++++++++--------
 drivers/net/e1000e/ich8lan.c  |    2 +-
 drivers/net/igb/e1000_82575.c |    2 +-
 drivers/net/igb/e1000_hw.h    |    3 ++-
 7 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index c1a42cf..efc2983 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1766,7 +1766,7 @@ static struct e1000_phy_operations e82_phy_ops_bm = {
 	.cfg_on_link_up      	= NULL,
 };
 
-static struct e1000_nvm_operations e82571_nvm_ops = {
+static const struct e1000_nvm_operations e82571_nvm_ops = {
 	.acquire		= e1000_acquire_nvm_82571,
 	.read			= e1000e_read_nvm_eerd,
 	.release		= e1000_release_nvm_82571,
diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index cebbd90..668112d 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -381,7 +381,7 @@ struct e1000_info {
 	s32			(*get_variants)(struct e1000_adapter *);
 	struct e1000_mac_operations *mac_ops;
 	struct e1000_phy_operations *phy_ops;
-	struct e1000_nvm_operations *nvm_ops;
+	const struct e1000_nvm_operations *nvm_ops;
 };
 
 /* hardware capability, feature, and workaround flags */
diff --git a/drivers/net/e1000e/es2lan.c b/drivers/net/e1000e/es2lan.c
index d2a1047..b46291d 100644
--- a/drivers/net/e1000e/es2lan.c
+++ b/drivers/net/e1000e/es2lan.c
@@ -1407,7 +1407,7 @@ static struct e1000_phy_operations es2_phy_ops = {
 	.cfg_on_link_up      	= e1000_cfg_on_link_up_80003es2lan,
 };
 
-static struct e1000_nvm_operations es2_nvm_ops = {
+static const struct e1000_nvm_operations es2_nvm_ops = {
 	.acquire		= e1000_acquire_nvm_80003es2lan,
 	.read			= e1000e_read_nvm_eerd,
 	.release		= e1000_release_nvm_80003es2lan,
diff --git a/drivers/net/e1000e/hw.h b/drivers/net/e1000e/hw.h
index a7d08da..0a75a9e 100644
--- a/drivers/net/e1000e/hw.h
+++ b/drivers/net/e1000e/hw.h
@@ -781,13 +781,13 @@ struct e1000_phy_operations {
 
 /* Function pointers for the NVM. */
 struct e1000_nvm_operations {
-	s32  (*acquire)(struct e1000_hw *);
-	s32  (*read)(struct e1000_hw *, u16, u16, u16 *);
-	void (*release)(struct e1000_hw *);
-	s32  (*update)(struct e1000_hw *);
-	s32  (*valid_led_default)(struct e1000_hw *, u16 *);
-	s32  (*validate)(struct e1000_hw *);
-	s32  (*write)(struct e1000_hw *, u16, u16, u16 *);
+	s32  (* const acquire)(struct e1000_hw *);
+	s32  (* const read)(struct e1000_hw *, u16, u16, u16 *);
+	void (* const release)(struct e1000_hw *);
+	s32  (* const update)(struct e1000_hw *);
+	s32  (* const valid_led_default)(struct e1000_hw *, u16 *);
+	s32  (* const validate)(struct e1000_hw *);
+	s32  (* const write)(struct e1000_hw *, u16, u16, u16 *);
 };
 
 struct e1000_mac_info {
@@ -861,7 +861,7 @@ struct e1000_phy_info {
 };
 
 struct e1000_nvm_info {
-	struct e1000_nvm_operations ops;
+	const struct e1000_nvm_operations ops;
 
 	enum e1000_nvm_type type;
 	enum e1000_nvm_override override;
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 7b33be9..e642cd4 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -3323,7 +3323,7 @@ static struct e1000_phy_operations ich8_phy_ops = {
 	.write_reg		= e1000e_write_phy_reg_igp,
 };
 
-static struct e1000_nvm_operations ich8_nvm_ops = {
+static const struct e1000_nvm_operations ich8_nvm_ops = {
 	.acquire		= e1000_acquire_nvm_ich8lan,
 	.read		 	= e1000_read_nvm_ich8lan,
 	.release		= e1000_release_nvm_ich8lan,
diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index e8e9e91..b13503e 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -1599,7 +1599,7 @@ static struct e1000_phy_operations e1000_phy_ops_82575 = {
 	.release              = igb_release_phy_82575,
 };
 
-static struct e1000_nvm_operations e1000_nvm_ops_82575 = {
+static const struct e1000_nvm_operations e1000_nvm_ops_82575 = {
 	.acquire              = igb_acquire_nvm_82575,
 	.read                 = igb_read_nvm_eerd,
 	.release              = igb_release_nvm_82575,
diff --git a/drivers/net/igb/e1000_hw.h b/drivers/net/igb/e1000_hw.h
index dbaeb5f..662e1be 100644
--- a/drivers/net/igb/e1000_hw.h
+++ b/drivers/net/igb/e1000_hw.h
@@ -326,7 +326,7 @@ struct e1000_info {
 	s32 (*get_invariants)(struct e1000_hw *);
 	struct e1000_mac_operations *mac_ops;
 	struct e1000_phy_operations *phy_ops;
-	struct e1000_nvm_operations *nvm_ops;
+	const struct e1000_nvm_operations *nvm_ops;
 };
 
 extern const struct e1000_info e1000_82575_info;
@@ -412,6 +412,7 @@ struct e1000_phy_info {
 };
 
 struct e1000_nvm_info {
+	/* cannot be const, see drivers/net/igb/igb_main.c:igb_probe */
 	struct e1000_nvm_operations ops;
 
 	enum e1000_nvm_type type;


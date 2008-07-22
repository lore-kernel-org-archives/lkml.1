Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbYGVRVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbYGVRVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYGVRUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:20:36 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34757 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbYGVRUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:20:35 -0400
Date: Tue, 22 Jul 2008 20:20:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>,
       Auke Kok <auke-jan.h.kok@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] drivers/net/igb/: #if 0 unused functions
Message-ID: <20080722172023.GO14846@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 2d064c06fecadadcb81a452acd373af00dfb1fec
(igb: add 82576 MAC support) the following functions
became added unused resp. lost all of their users:
- e1000_82575.c: igb_translate_register_82576()
- e1000_mac.c: igb_init_rx_addrs()
- e1000_mac.c: igb_mta_set()
- e1000_mac.c: igb_update_mc_addr_list()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/igb/e1000_82575.c |    2 ++
 drivers/net/igb/e1000_82575.h |    1 -
 drivers/net/igb/e1000_mac.c   |    6 ++++++
 drivers/net/igb/e1000_mac.h   |    4 ----
 4 files changed, 8 insertions(+), 5 deletions(-)

00659c33ed602bd9efd271b74c691dc88260e6e9 Revert "Revert """
diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index e098f23..a4028a9 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -1231,6 +1231,7 @@ out:
 	return ret_val;
 }
 
+#if 0
 /**
  *  igb_translate_register_82576 - Translate the proper register offset
  *  @reg: e1000 register to be read
@@ -1294,6 +1295,7 @@ u32 igb_translate_register_82576(u32 reg)
 
 	return reg;
 }
+#endif  /*  0  */
 
 /**
  *  igb_reset_init_script_82575 - Inits HW defaults after reset
diff --git a/drivers/net/igb/e1000_82575.h b/drivers/net/igb/e1000_82575.h
index 2f848e5..c1928b5 100644
--- a/drivers/net/igb/e1000_82575.h
+++ b/drivers/net/igb/e1000_82575.h
@@ -28,7 +28,6 @@
 #ifndef _E1000_82575_H_
 #define _E1000_82575_H_
 
-u32 igb_translate_register_82576(u32 reg);
 void igb_update_mc_addr_list_82575(struct e1000_hw*, u8*, u32, u32, u32);
 extern void igb_shutdown_fiber_serdes_link_82575(struct e1000_hw *hw);
 extern void igb_rx_fifo_flush_82575(struct e1000_hw *hw);
diff --git a/drivers/net/igb/e1000_mac.c b/drivers/net/igb/e1000_mac.c
index 20408aa..a35c0d2 100644
--- a/drivers/net/igb/e1000_mac.c
+++ b/drivers/net/igb/e1000_mac.c
@@ -143,6 +143,7 @@ void igb_write_vfta(struct e1000_hw *hw, u32 offset, u32 value)
 	wrfl();
 }
 
+#if 0
 /**
  *  igb_init_rx_addrs - Initialize receive address's
  *  @hw: pointer to the HW structure
@@ -170,6 +171,7 @@ void igb_init_rx_addrs(struct e1000_hw *hw, u16 rar_count)
 		wrfl();
 	}
 }
+#endif  /*  0  */
 
 /**
  *  igb_check_alt_mac_addr - Check for alternate MAC addr
@@ -261,6 +263,8 @@ void igb_rar_set(struct e1000_hw *hw, u8 *addr, u32 index)
 	array_wr32(E1000_RA, ((index << 1) + 1), rar_high);
 }
 
+#if 0
+
 /**
  *  igb_mta_set - Set multicast filter table address
  *  @hw: pointer to the HW structure
@@ -350,6 +354,8 @@ void igb_update_mc_addr_list(struct e1000_hw *hw,
 	}
 }
 
+#endif  /*  0  */
+
 /**
  *  igb_hash_mc_addr - Generate a multicast hash value
  *  @hw: pointer to the HW structure
diff --git a/drivers/net/igb/e1000_mac.h b/drivers/net/igb/e1000_mac.h
index dc2f8cc..5143fed 100644
--- a/drivers/net/igb/e1000_mac.h
+++ b/drivers/net/igb/e1000_mac.h
@@ -51,9 +51,6 @@ s32  igb_get_speed_and_duplex_copper(struct e1000_hw *hw, u16 *speed,
 				       u16 *duplex);
 s32  igb_id_led_init(struct e1000_hw *hw);
 s32  igb_led_off(struct e1000_hw *hw);
-void igb_update_mc_addr_list(struct e1000_hw *hw,
-			       u8 *mc_addr_list, u32 mc_addr_count,
-			       u32 rar_used_count, u32 rar_count);
 s32  igb_setup_link(struct e1000_hw *hw);
 s32  igb_validate_mdi_setting(struct e1000_hw *hw);
 s32  igb_write_8bit_ctrl_reg(struct e1000_hw *hw, u32 reg,
@@ -62,7 +59,6 @@ s32  igb_write_8bit_ctrl_reg(struct e1000_hw *hw, u32 reg,
 void igb_clear_hw_cntrs_base(struct e1000_hw *hw);
 void igb_clear_vfta(struct e1000_hw *hw);
 void igb_config_collision_dist(struct e1000_hw *hw);
-void igb_init_rx_addrs(struct e1000_hw *hw, u16 rar_count);
 void igb_put_hw_semaphore(struct e1000_hw *hw);
 void igb_rar_set(struct e1000_hw *hw, u8 *addr, u32 index);
 s32  igb_check_alt_mac_addr(struct e1000_hw *hw);


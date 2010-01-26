Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097Ab0AZXox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0AZXox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062Ab0AZXoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:44 -0500
Received: from kroah.org ([198.145.64.141]:35572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0AZXob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:31 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:33 2010
Message-Id: <20100126233933.855054380@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:35:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [98/98] iwlwifi: Fix throughput stall issue in HT mode for 5000
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 1152dcc28c66a74b5b3f1a3ede0aa6729bfd48e4 upstream

Similar to 6000 and 1000 series, RTS/CTS is the recommended protection
mechanism for 5000 series in HT mode based on the HW design.

Using RTS/CTS will better protect the inner exchange from interference,
especially in highly-congested environment, it also prevent uCode encounter
TX FIFO underrun and other HT mode related performance issues.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1666,6 +1666,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl5100_bg_cfg = {
@@ -1717,6 +1718,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1734,6 +1736,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.valid_rx_ant = ANT_ABC,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1751,6 +1754,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.valid_rx_ant = ANT_AB,
 	.need_pll_cfg = true,
 	.ht_greenfield_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));



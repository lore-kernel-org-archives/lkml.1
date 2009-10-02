Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbZJBBeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbZJBBeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbZJBBed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:33 -0400
Received: from kroah.org ([198.145.64.141]:33636 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbZJBBea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:28 2009
Message-Id: <20091002012428.133423503@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:18:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [134/136] iwlagn: modify digital SVR for 1000
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=iwlagn-modify-digital-svr-for-1000.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 02c06e4abc0680afd31bf481a803541556757fb6 upstream.

On 1000, there are two Switching Voltage Regulators (SVR). The first one
apply digital voltage level (1.32V) for PCIe block and core. We need to
use this regulator to solve a stability issue related to noisy DC2DC
line in the silicon.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-prph.h |    5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -239,6 +239,13 @@ static void iwl5000_nic_config(struct iw
 				APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS,
 				~APMG_PS_CTRL_EARLY_PWR_OFF_RESET_DIS);
 
+	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_1000) {
+		/* Setting digital SVR for 1000 card to 1.32V */
+		iwl_set_bits_mask_prph(priv, APMG_DIGITAL_SVR_REG,
+					APMG_SVR_DIGITAL_VOLTAGE_1_32,
+					~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
+	}
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -80,6 +80,8 @@
 #define APMG_RFKILL_REG			(APMG_BASE + 0x0014)
 #define APMG_RTC_INT_STT_REG		(APMG_BASE + 0x001c)
 #define APMG_RTC_INT_MSK_REG		(APMG_BASE + 0x0020)
+#define APMG_DIGITAL_SVR_REG		(APMG_BASE + 0x0058)
+#define APMG_ANALOG_SVR_REG		(APMG_BASE + 0x006C)
 
 #define APMG_CLK_VAL_DMA_CLK_RQT	(0x00000200)
 #define APMG_CLK_VAL_BSM_CLK_RQT	(0x00000800)
@@ -91,7 +93,8 @@
 #define APMG_PS_CTRL_VAL_PWR_SRC_VMAIN		(0x00000000)
 #define APMG_PS_CTRL_VAL_PWR_SRC_MAX		(0x01000000) /* 3945 only */
 #define APMG_PS_CTRL_VAL_PWR_SRC_VAUX		(0x02000000)
-
+#define APMG_SVR_VOLTAGE_CONFIG_BIT_MSK	(0x000001E0) /* bit 8:5 */
+#define APMG_SVR_DIGITAL_VOLTAGE_1_32		(0x00000060)
 
 #define APMG_PCIDEV_STT_VAL_L1_ACT_DIS		(0x00000800)
 



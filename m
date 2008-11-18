Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYKRIYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYKRIYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYKRIWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:22:24 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:55515 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYKRIWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:22:16 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691806"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/6] usb: musb: use static inline functions to replace the macros in Blackfin version
Date: Tue, 18 Nov 2008 16:23:38 +0800
Message-Id: <1226996620-11388-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
References: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Mike pointed out, "these should be static inline's so that side
effects in function usage dont get messed up.  for example, if someone
used a ++ or -- or = operator in the argument list."

So I fixed all musb stubs here, but remain clk_xxx stubs because it needs to
define struck clk. IMO, we might add clk support in the future.

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/musb_regs.h |   76 +++++++++++++++++++++++++++++++++---------
 1 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index 3e50aef..37f90f0 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -447,22 +447,66 @@ static inline void  musb_write_txhubport(void __iomem *mbase, u8 epnum,
 #define clk_enable(clock)	do {} while (0)
 #define clk_disable(clock)	do {} while (0)
 
-#define musb_write_txfifosz(mbase, c_size)	do {} while (0)
-#define musb_write_txfifoadd(mbase, c_off)	do {} while (0)
-#define musb_write_rxfifosz(mbase, c_size)	do {} while (0)
-#define musb_write_rxfifoadd(mbase, c_off)	do {} while (0)
-
-#define musb_read_configdata(mbase)	0
-#define musb_read_hwvers(mbase)		0
-#define musb_read_target_reg_base(i, mbase)	0
-
-#define musb_write_rxfunaddr(ep_target_regs, qh_addr_reg)	do {} while (0)
-#define musb_write_rxhubaddr(ep_target_regs, qh_h_addr_reg)	do {} while (0)
-#define musb_write_rxhubport(ep_target_regs, qh_h_port_reg)	do {} while (0)
-
-#define musb_write_txfunaddr(mbase, epnum, qh_addr_reg)		do {} while (0)
-#define musb_write_txhubaddr(mbase, epnum, qh_h_addr_reg)	do {} while (0)
-#define musb_write_txhubport(mbase, epnum, qh_h_port_reg)	do {} while (0)
+static inline void musb_write_txfifosz(void __iomem *mbase, u8 c_size)
+{
+}
+
+static inline void musb_write_txfifoadd(void __iomem *mbase, u16 c_off)
+{
+}
+
+static inline void musb_write_rxfifosz(void __iomem *mbase, u8 c_size)
+{
+}
+
+static inline void  musb_write_rxfifoadd(void __iomem *mbase, u16 c_off)
+{
+}
+
+static inline u8 musb_read_configdata(void __iomem *mbase)
+{
+	return 0;
+}
+
+static inline u16 musb_read_hwvers(void __iomem *mbase)
+{
+	return 0;
+}
+
+static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase)
+{
+	return 0;
+}
+
+static inline void musb_write_rxfunaddr(void __iomem *ep_target_regs,
+		u8 qh_addr_req)
+{
+}
+
+static inline void musb_write_rxhubaddr(void __iomem *ep_target_regs,
+		u8 qh_h_addr_reg)
+{
+}
+
+static inline void musb_write_rxhubport(void __iomem *ep_target_regs,
+		u8 qh_h_port_reg)
+{
+}
+
+static inline void  musb_write_txfunaddr(void __iomem *mbase, u8 epnum,
+		u8 qh_addr_reg)
+{
+}
+
+static inline void  musb_write_txhubaddr(void __iomem *mbase, u8 epnum,
+		u8 qh_addr_reg)
+{
+}
+
+static inline void  musb_write_txhubport(void __iomem *mbase, u8 epnum,
+		u8 qh_h_port_reg)
+{
+}
 
 #endif /* CONFIG_BLACKFIN */
 
-- 
1.5.6.3

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764399AbYEYKbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764399AbYEYKbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762649AbYEYKYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43345 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762591AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 18/28] cxgb3: treat firmware data as const
Message-Id: <E1K0DOF-0007Dw-V4@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:47 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/cxgb3/common.h |    5 +++--
 drivers/net/cxgb3/t3_hw.c  |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/cxgb3/common.h b/drivers/net/cxgb3/common.h
index 579bee4..8e8ebd7 100644
--- a/drivers/net/cxgb3/common.h
+++ b/drivers/net/cxgb3/common.h
@@ -686,8 +686,9 @@ int t3_seeprom_write(struct adapter *adapter, u32 addr, __le32 data);
 int t3_seeprom_wp(struct adapter *adapter, int enable);
 int t3_get_tp_version(struct adapter *adapter, u32 *vers);
 int t3_check_tpsram_version(struct adapter *adapter, int *must_load);
-int t3_check_tpsram(struct adapter *adapter, u8 *tp_ram, unsigned int size);
-int t3_set_proto_sram(struct adapter *adap, u8 *data);
+int t3_check_tpsram(struct adapter *adapter, const u8 *tp_ram,
+		    unsigned int size);
+int t3_set_proto_sram(struct adapter *adap, const u8 *data);
 int t3_read_flash(struct adapter *adapter, unsigned int addr,
 		  unsigned int nwords, u32 *data, int byte_oriented);
 int t3_load_fw(struct adapter *adapter, const u8 * fw_data, unsigned int size);
diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index d405a93..47d5178 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -923,7 +923,8 @@ int t3_check_tpsram_version(struct adapter *adapter, int *must_load)
  *	Checks if an adapter's tp sram is compatible with the driver.
  *	Returns 0 if the versions are compatible, a negative error otherwise.
  */
-int t3_check_tpsram(struct adapter *adapter, u8 *tp_sram, unsigned int size)
+int t3_check_tpsram(struct adapter *adapter, const u8 *tp_sram,
+		    unsigned int size)
 {
 	u32 csum;
 	unsigned int i;
@@ -2875,10 +2876,10 @@ static void ulp_config(struct adapter *adap, const struct tp_params *p)
  *
  *	Write the contents of the protocol SRAM.
  */
-int t3_set_proto_sram(struct adapter *adap, u8 *data)
+int t3_set_proto_sram(struct adapter *adap, const u8 *data)
 {
 	int i;
-	__be32 *buf = (__be32 *)data;
+	const __be32 *buf = (const __be32 *)data;
 
 	for (i = 0; i < PROTO_SRAM_LINES; i++) {
 		t3_write_reg(adap, A_TP_EMBED_OP_FIELD5, be32_to_cpu(*buf++));
-- 
1.5.4.5


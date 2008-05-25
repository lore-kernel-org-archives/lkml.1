Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbYEYK3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbYEYK3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762598AbYEYKYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43329 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 03/28] cyclades: treat firmware data as const
Message-Id: <E1K0DO0-0007Cy-26@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:32 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/char/cyclades.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index ef73e72..6bff9d8 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4668,7 +4668,7 @@ static inline int __devinit cyc_isfwstr(const char *str, unsigned int size)
 	return 0;
 }
 
-static inline void __devinit cyz_fpga_copy(void __iomem *fpga, u8 *data,
+static inline void __devinit cyz_fpga_copy(void __iomem *fpga, const u8 *data,
 		unsigned int size)
 {
 	for (; size > 0; size--) {
@@ -4701,10 +4701,10 @@ static int __devinit __cyz_load_fw(const struct firmware *fw,
 		const char *name, const u32 mailbox, void __iomem *base,
 		void __iomem *fpga)
 {
-	void *ptr = fw->data;
-	struct zfile_header *h = ptr;
-	struct zfile_config *c, *cs;
-	struct zfile_block *b, *bs;
+	const void *ptr = fw->data;
+	const struct zfile_header *h = ptr;
+	const struct zfile_config *c, *cs;
+	const struct zfile_block *b, *bs;
 	unsigned int a, tmp, len = fw->size;
 #define BAD_FW KERN_ERR "Bad firmware: "
 	if (len < sizeof(*h)) {
-- 
1.5.4.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbYEYKYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbYEYKYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbYEYKXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYEYKXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:40 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 07/28] riptide: treat firmware data as const
Message-Id: <E1K0DO4-0007DE-8r@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:36 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 sound/pci/riptide/riptide.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 979f7da..6a35962 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -682,7 +682,7 @@ static union firmware_version firmware_versions[] = {
 	},
 };
 
-static u32 atoh(unsigned char *in, unsigned int len)
+static u32 atoh(const unsigned char *in, unsigned int len)
 {
 	u32 sum = 0;
 	unsigned int mult = 1;
@@ -702,12 +702,12 @@ static u32 atoh(unsigned char *in, unsigned int len)
 	return sum;
 }
 
-static int senddata(struct cmdif *cif, unsigned char *in, u32 offset)
+static int senddata(struct cmdif *cif, const unsigned char *in, u32 offset)
 {
 	u32 addr;
 	u32 data;
 	u32 i;
-	unsigned char *p;
+	const unsigned char *p;
 
 	i = atoh(&in[1], 2);
 	addr = offset + atoh(&in[3], 4);
@@ -726,10 +726,10 @@ static int senddata(struct cmdif *cif, unsigned char *in, u32 offset)
 	return 0;
 }
 
-static int loadfirmware(struct cmdif *cif, unsigned char *img,
+static int loadfirmware(struct cmdif *cif, const unsigned char *img,
 			unsigned int size)
 {
-	unsigned char *in;
+	const unsigned char *in;
 	u32 laddr, saddr, t, val;
 	int err = 0;
 
-- 
1.5.4.5


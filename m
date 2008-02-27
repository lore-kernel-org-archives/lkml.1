Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbYB0VZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbYB0VZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbYB0VWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:22:21 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49169 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbYB0VWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:22:20 -0500
Date: Wed, 27 Feb 2008 23:21:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] i2c-amd756.c: fix off-by-one
Message-ID: <20080227212108.GR29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one error spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f9829dd0d7dad9cbc08da3fceb105478e85c4137 foobar
diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
index 573abe4..2fa4318 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -335,7 +335,7 @@ static int __devinit amd756_probe(struct pci_dev *pdev,
 	u8 temp;
 	
 	/* driver_data might come from user-space, so check it */
-	if (id->driver_data > ARRAY_SIZE(chipname))
+	if (id->driver_data >= ARRAY_SIZE(chipname))
 		return -EINVAL;
 
 	if (amd756_ioport) {


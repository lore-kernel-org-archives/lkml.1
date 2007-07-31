Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbXGaREK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbXGaREK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXGaRDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:03:54 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4310 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbXGaRDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:03:53 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07] drivers/block/cciss.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:03:51 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       iss_storagedev@hp.com, axboe@kernel.dk
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311903.52301.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/block/cciss.c | 104285 -> 104168 (-117 bytes)
 drivers/block/cciss.o | 277400 -> 277124 (-276 bytes)

 drivers/block/cciss.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/block/cciss.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/block/cciss.c	2007-07-31 12:57:50.000000000 +0200
@@ -1977,12 +1977,13 @@ cciss_read_capacity(int ctlr, int logvol
 {
 	ReadCapdata_struct *buf;
 	int return_code;
-	buf = kmalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
-	if (buf == NULL) {
+
+	buf = kzalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
+	if (!buf) {
 		printk(KERN_WARNING "cciss: out of memory\n");
 		return;
 	}
-	memset(buf, 0, sizeof(ReadCapdata_struct));
+
 	if (withirq)
 		return_code = sendcmd_withirq(CCISS_READ_CAPACITY,
 				ctlr, buf, sizeof(ReadCapdata_struct),
@@ -2003,7 +2004,6 @@ cciss_read_capacity(int ctlr, int logvol
 		printk(KERN_INFO "      blocks= %llu block_size= %d\n",
 		(unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
-	return;
 }

 static void
@@ -2011,12 +2011,13 @@ cciss_read_capacity_16(int ctlr, int log
 {
 	ReadCapdata_struct_16 *buf;
 	int return_code;
-	buf = kmalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
-	if (buf == NULL) {
+
+	buf = kzalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
+	if (!buf) {
 		printk(KERN_WARNING "cciss: out of memory\n");
 		return;
 	}
-	memset(buf, 0, sizeof(ReadCapdata_struct_16));
+
 	if (withirq) {
 		return_code = sendcmd_withirq(CCISS_READ_CAPACITY_16,
 			ctlr, buf, sizeof(ReadCapdata_struct_16),
@@ -2038,7 +2039,6 @@ cciss_read_capacity_16(int ctlr, int log
 	printk(KERN_INFO "      blocks= %llu block_size= %d\n",
 	       (unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
-	return;
 }

 static int cciss_revalidate(struct gendisk *disk)

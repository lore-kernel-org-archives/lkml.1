Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbXGaRCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbXGaRCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXGaRCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:02:00 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2285 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbXGaRB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:01:58 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06] drivers/scsi/bvme6000_scsi.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:01:57 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi@vger.kernel.org, Richard Hirst <richard@sleepie.demon.co.uk>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311901.57913.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/bvme6000_scsi.c | 3330 -> 3253 (-77 bytes)

 drivers/scsi/bvme6000_scsi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/bvme6000_scsi.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/bvme6000_scsi.c	2007-07-31 14:04:50.000000000 +0200
@@ -36,19 +36,18 @@ static struct platform_device *bvme6000_
 static __devinit int
 bvme6000_probe(struct device *dev)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;

 	if (!MACH_IS_BVME6000)
 		goto out;

-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (!hostdata) {
 		printk(KERN_ERR "bvme6000-scsi: "
 				"Failed to allocate host data\n");
 		goto out;
 	}
-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));

 	/* Fill in the required pieces of hostdata */
 	hostdata->base = (void __iomem *)BVME_NCR53C710_BASE;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbZDHIbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbZDHIbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZDHIba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:31:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:47968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZDHIb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:31:29 -0400
Subject: Re: Linux 2.6.30-rc1 boot failure on ia64 w/ QLA12160.  Bisected.
From: David Woodhouse <dwmw2@infradead.org>
To: Robin Holt <holt@sgi.com>
Cc: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090408042734.GD10768@sgi.com>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
	 <20090408042734.GD10768@sgi.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 01:31:19 -0700
Message-Id: <1239179479.3411.4.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 23:27 -0500, Robin Holt wrote:
> On and ia64 system with a QLA12160 adapter, my boot fails with:

Thanks for the report. After successful feedback from Jeremy, I've added
the commit below to git://git.infradead.org/~dwmw2/firmware-2.6.git,
which I asked Linus to pull already on Monday...

>From 0ce49d6da993adf8b17b7f3ed9805ade14a6a6f3 Mon Sep 17 00:00:00 2001
From: David Woodhouse <David.Woodhouse@intel.com>
Date: Wed, 8 Apr 2009 01:22:36 -0700
Subject: [PATCH] qla1280: Fix off-by-some error in firmware loading.

We were calculating the wrong address for the start of the data.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Tested-by: Jeremy Higdon <jeremy@sgi.com>
---
 drivers/scsi/qla1280.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 351b56c..d030db9 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1663,7 +1663,7 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 
 	/* Load RISC code. */
 	risc_address = ha->fwstart;
-	fw_data = (const __le16 *)&fw->data[4];
+	fw_data = (const __le16 *)&fw->data[6];
 	risc_code_size = (fw->size - 6) / 2;
 
 	for (i = 0; i < risc_code_size; i++) {
@@ -1722,7 +1722,7 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 
 	/* Load RISC code. */
 	risc_address = ha->fwstart;
-	fw_data = (const __le16 *)&fw->data[4];
+	fw_data = (const __le16 *)&fw->data[6];
 	risc_code_size = (fw->size - 6) / 2;
 
 	dprintk(1, "%s: DMA RISC code (%i) words\n",
-- 
1.6.2.2



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


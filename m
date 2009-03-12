Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZCLGbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZCLGbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 02:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZCLGaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 02:30:52 -0400
Received: from mail.renesas.com ([202.234.163.13]:47884 "EHLO
	mail05.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618AbZCLGav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 02:30:51 -0400
X-AuditID: ac140388-0000000800006b18-d5-49b8ac1318c4
Date: Thu, 12 Mar 2009 15:30:41 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: [PATCH] dmaengine: Add Kconfig of DMA data align for DMA Test driver
To: linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com
Message-id: <49B8AC11.70902@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test drivers of DMA engine usually perform DMA transfer by 1 byte unit.
This can set transfer size of DMA and aligns data for tests.

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/Kconfig   |    8 ++++++++
 drivers/dma/dmatest.c |    7 +++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 48ea59e..7f9e1ec 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -105,4 +105,12 @@ config DMATEST
 	  Simple DMA test client. Say N unless you're debugging a
 	  DMA Device driver.

+config DMATEST_DATA_ALIGN
+	int "DMA Test data align size"
+	depends on DMATEST
+	default "1"
+	help
+	  Test drivers of DMA engine usually perform DMA transfer by 1 byte unit.
+	  This can set transfer size of DMA and aligns data for tests.
+
 endif
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 732fa1e..e7f273c 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -224,8 +224,15 @@ static int dmatest_func(void *data)
 		total_tests++;

 		len = dmatest_random() % test_buf_size + 1;
+#if CONFIG_DMATEST_DATA_ALIGN > 1
+		len -= (len % CONFIG_DMATEST_DATA_ALIGN);
+#endif
 		src_off = dmatest_random() % (test_buf_size - len + 1);
 		dst_off = dmatest_random() % (test_buf_size - len + 1);
+#if CONFIG_DMATEST_DATA_ALIGN > 1
+		src_off -= (src_off % CONFIG_DMATEST_DATA_ALIGN);
+		dst_off -= (dst_off % CONFIG_DMATEST_DATA_ALIGN);
+#endif

 		dmatest_init_srcbuf(thread->srcbuf, src_off, len);
 		dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
-- 
1.6.2


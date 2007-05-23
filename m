Return-Path: <linux-kernel-owner+w=401wt.eu-S935253AbXEWR1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935253AbXEWR1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbXEWR1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:27:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:23236 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931AbXEWR1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tfuVu8ohJ8W1bEYCNZku2U96l63wITcZxPZsE8lEYn2Ycx2NZczsAxca0Cnv8QZa8r1ewfC35CodgTTQ3T1gYaLm+m2bn0sISdhxh6V4Dtj60UEW9cr6gWheaFZRrfIUqUJHDwKq9sWNvbbOwyuexJe401KTG4qrA3Fd9CEZTDg=
Message-ID: <75b57c110705231027l4d0aeca5u778cb907dbd7c814@mail.gmail.com>
Date: Wed, 23 May 2007 13:27:11 -0400
From: "Gerb Stralko" <gerb.stralko@gmail.com>
To: rmk+lkml@arm.linux.org.uk
Subject: [PATCH] ARM/ARM26 Cleanup, using ARRAY_SIZE
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the kernel wide ARRAY_SIZE when determining the array size of a struct.

Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>

---

diff --git a/arch/arm/kernel/dma-isa.c b/arch/arm/kernel/dma-isa.c
index 0a3e9ad..c94ad71 100644
--- a/arch/arm/kernel/dma-isa.c
+++ b/arch/arm/kernel/dma-isa.c
@@ -19,6 +19,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/kernel.h>

 #include <asm/dma.h>
 #include <asm/io.h>
@@ -216,7 +217,7 @@ void __init isa_init_dma(dma_t *dma)

                request_dma(DMA_ISA_CASCADE, "cascade");

-               for (i = 0; i < sizeof(dma_resources) /
sizeof(dma_resources[0]); i++)
+               for (i = 0; i < ARRAY_SIZE(dma_resources); i++)
                        request_resource(&ioport_resource, dma_resources + i);
        }
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbZIOTPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbZIOTPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbZIOTPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:12 -0400
Received: from kroah.org ([198.145.64.141]:33055 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758526AbZIOTPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/20] driver-core: move dma-coherent.c from kernel to driver/base
Date: Tue, 15 Sep 2009 12:12:44 -0700
Message-Id: <1253041976-1111-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Placing dma-coherent.c in driver/base is better than in kernel,
since it contains code to do per-device coherent dma memory
handling.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Makefile                   |    1 +
 {kernel => drivers/base}/dma-coherent.c |    0
 kernel/Makefile                         |    1 -
 3 files changed, 1 insertions(+), 1 deletions(-)
 rename {kernel => drivers/base}/dma-coherent.c (100%)

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index b5b8ba5..1b2640c 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -6,6 +6,7 @@ obj-y			:= core.o sys.o bus.o dd.o \
 			   attribute_container.o transport_class.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
+obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/kernel/dma-coherent.c b/drivers/base/dma-coherent.c
similarity index 100%
rename from kernel/dma-coherent.c
rename to drivers/base/dma-coherent.c
diff --git a/kernel/Makefile b/kernel/Makefile
index 961379c..3d9c7e2 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -90,7 +90,6 @@ obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
-obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
-- 
1.6.4.2


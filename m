Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZG2MGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZG2MGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZG2MGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:06:46 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58872 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754411AbZG2MGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:06:44 -0400
Date: Wed, 29 Jul 2009 14:06:42 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Arnd Bergmann <arnd@arndb.de>, Geoff Levand <geoffrey.levand@am.sony.com>,
       Jens Axboe <axboe@kernel.dk>,
       Linux/PPC Development <linuxppc-dev@lists.ozlabs.org>,
       cbe-oss-dev@ozlabs.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc/cell: Move CBE_IOPTE_* to <asm/cell-regs.h> (was:
 Re: [PATCH 10/33] powerpc/cell: Extract duplicated IOPTE_* to
 <asm/iommu.h>)
In-Reply-To: <1245049942.19217.57.camel@pasglop>
Message-ID: <alpine.LRH.2.00.0907291402520.26399@vixen.sonytel.be>
References: <1244644748-24211-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1244644748-24211-11-git-send-email-Geert.Uytterhoeven@sonycom.com> <1245030085.19217.5.camel@pasglop> <200906150905.30744.arnd@arndb.de> <1245049942.19217.57.camel@pasglop>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-15 at 09:05 +0200, Arnd Bergmann wrote:
> > Good point, that file does not contain hardware specific definitions
> > but
> > only interfaces.
> > 
> > Geert, how about putting them into
> > arch/powerpc/include/asm/cell-regs.h
> > instead?
> 
> I've put the patch in powerpc-next for now. But you may want to send
> another patch later on to move things.

At your service!

---
>From bb2fab2f78b24a80669cc6424bf621e4d113cfe4 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Wed, 29 Jul 2009 13:56:57 +0200
Subject: [PATCH] powerpc/cell: Move CBE_IOPTE_* to <asm/cell-regs.h>

As <asm/iommu.h> doesn't contain any other hardware specific definitions
but only interfaces.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/include/asm/cell-regs.h    |   11 +++++++++++
 arch/powerpc/include/asm/iommu.h        |   10 ----------
 arch/powerpc/platforms/ps3/mm.c         |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c |    2 +-
 drivers/block/ps3vram.c                 |    2 +-
 drivers/video/ps3fb.c                   |    2 +-
 6 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/cell-regs.h b/arch/powerpc/include/asm/cell-regs.h
index fd6fd00..fdf64fd 100644
--- a/arch/powerpc/include/asm/cell-regs.h
+++ b/arch/powerpc/include/asm/cell-regs.h
@@ -303,6 +303,17 @@ struct cbe_mic_tm_regs {
 extern struct cbe_mic_tm_regs __iomem *cbe_get_mic_tm_regs(struct device_node *np);
 extern struct cbe_mic_tm_regs __iomem *cbe_get_cpu_mic_tm_regs(int cpu);
 
+
+/* Cell page table entries */
+#define CBE_IOPTE_PP_W		0x8000000000000000ul /* protection: write */
+#define CBE_IOPTE_PP_R		0x4000000000000000ul /* protection: read */
+#define CBE_IOPTE_M		0x2000000000000000ul /* coherency required */
+#define CBE_IOPTE_SO_R		0x1000000000000000ul /* ordering: writes */
+#define CBE_IOPTE_SO_RW		0x1800000000000000ul /* ordering: r & w */
+#define CBE_IOPTE_RPN_Mask	0x07fffffffffff000ul /* RPN */
+#define CBE_IOPTE_H		0x0000000000000800ul /* cache hint */
+#define CBE_IOPTE_IOID_Mask	0x00000000000007fful /* ioid */
+
 /* some utility functions to deal with SMT */
 extern u32 cbe_get_hw_thread_id(int cpu);
 extern u32 cbe_cpu_to_node(int cpu);
diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 7ead7c1..7464c0d 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -35,16 +35,6 @@
 #define IOMMU_PAGE_MASK       (~((1 << IOMMU_PAGE_SHIFT) - 1))
 #define IOMMU_PAGE_ALIGN(addr) _ALIGN_UP(addr, IOMMU_PAGE_SIZE)
 
-/* Cell page table entries */
-#define CBE_IOPTE_PP_W		0x8000000000000000ul /* protection: write */
-#define CBE_IOPTE_PP_R		0x4000000000000000ul /* protection: read */
-#define CBE_IOPTE_M		0x2000000000000000ul /* coherency required */
-#define CBE_IOPTE_SO_R		0x1000000000000000ul /* ordering: writes */
-#define CBE_IOPTE_SO_RW		0x1800000000000000ul /* ordering: r & w */
-#define CBE_IOPTE_RPN_Mask	0x07fffffffffff000ul /* RPN */
-#define CBE_IOPTE_H		0x0000000000000800ul /* cache hint */
-#define CBE_IOPTE_IOID_Mask	0x00000000000007fful /* ioid */
-
 /* Boot time flags */
 extern int iommu_is_off;
 extern int iommu_force_on;
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 846eb8b..189a25b 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -23,8 +23,8 @@
 #include <linux/memory_hotplug.h>
 #include <linux/lmb.h>
 
+#include <asm/cell-regs.h>
 #include <asm/firmware.h>
-#include <asm/iommu.h>
 #include <asm/prom.h>
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 3f763c5..676f989 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -27,7 +27,7 @@
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
 #include <asm/firmware.h>
-#include <asm/iommu.h>
+#include <asm/cell-regs.h>
 
 #include "platform.h"
 
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 095f97e..c8753a9 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -13,8 +13,8 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
+#include <asm/cell-regs.h>
 #include <asm/firmware.h>
-#include <asm/iommu.h>
 #include <asm/lv1call.h>
 #include <asm/ps3.h>
 #include <asm/ps3gpu.h>
diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index c0af638..9c0144e 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -32,7 +32,7 @@
 #include <linux/init.h>
 
 #include <asm/abs_addr.h>
-#include <asm/iommu.h>
+#include <asm/cell-regs.h>
 #include <asm/lv1call.h>
 #include <asm/ps3av.h>
 #include <asm/ps3fb.h>
-- 
1.6.2.4

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010

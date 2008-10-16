Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbYJPReA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbYJPReA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760449AbYJPRcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:32:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:61647 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760431AbYJPRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=h+VQJ+Pf5grVuBHtb6d48WGMrGcLDGlr+yUyvv8dxns1lCYWoV9SDEKhV5JoeR8G5o
         MjCE7Boo0+jRmZg0G/fxLbStSts3FkJ9jHcztdZE+siFGSSWDKbQqCAyFNlmYe2SCgyF
         G+AVW98LCwaoXlP31QRjxSLb8CHNOBDisw58g=
Message-ID: <386072610810161032i38c666d3sf86242cb3dc7e956@mail.gmail.com>
Date: Fri, 17 Oct 2008 01:32:05 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin updates 2nd piece for 2.6.28 merge window
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 1c86b4492be90460
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/configs/BF526-EZBRD_defconfig        |    2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig        |    2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig        |    4 +-
 arch/blackfin/configs/BF533-STAMP_defconfig        |    2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig        |    4 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig        |    4 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig        |    4 +-
 arch/blackfin/configs/CM-BF527_defconfig           |    2 +-
 arch/blackfin/configs/CM-BF533_defconfig           |    2 +-
 arch/blackfin/configs/CM-BF537E_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF537U_defconfig          |    2 +-
 arch/blackfin/configs/CM-BF548_defconfig           |    4 +-
 arch/blackfin/configs/CM-BF561_defconfig           |    2 +-
 arch/blackfin/include/asm/cacheflush.h             |   27 +++-
 arch/blackfin/include/asm/cplbinit.h               |   17 --
 arch/blackfin/include/asm/io.h                     |   30 ++++
 arch/blackfin/include/asm/timex.h                  |    2 +-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |    5 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |    1 +
 arch/blackfin/mach-bf527/head.S                    |    2 +-
 arch/blackfin/mach-bf533/head.S                    |    2 +-
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   25 ++-
 arch/blackfin/mach-bf537/head.S                    |    2 +-
 arch/blackfin/mach-bf548/head.S                    |    2 +-
 arch/blackfin/mach-bf561/head.S                    |    2 +-
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-common/cache.S                  |  173 +++++++-------------
 arch/blackfin/mach-common/head.S                   |   54 ++++++
 29 files changed, 210 insertions(+), 174 deletions(-)

Bryan Wu (1):
      Blackfin arch: add read/write IO accessor functions to Blackfin

Graf Yang (1):
      Blackfin arch: Zero out bss region in L1/L2 memory.

Michael Hennerich (1):
      Blackfin arch: update AD7879 platform resources in board file

Mike Frysinger (6):
      Blackfin arch: unify/cleanup cache code
      Blackfin arch: use the new bfin_addr_dcachable() function
      Blackfin arch: move bfin_addr_dcachable() and friends into the
cacheflush header where it belongs
      Blackfin arch: update cache flush prototypes with argument names
to make them less mysterious
      Blackfin arch: disable CONFIG_HW_RANDOM and CONFIG_DAB in defconfig files
      Blackfin arch: make sure cycles is marked as volatile so gcc
doesnt reorder on us

Robin Getz (1):
      Blackfin arch: fix bug - build kernel failed at head.S when
reprogram clock on all platforms

Sonic Zhang (1):
      Blackfin arch: fix bug - some serial header files set RTS to an
input when they should all be outputs

diff --git a/arch/blackfin/configs/BF526-EZBRD_defconfig
b/arch/blackfin/configs/BF526-EZBRD_defconfig
index c33bf6f..4443a47 100644
--- a/arch/blackfin/configs/BF526-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF526-EZBRD_defconfig
@@ -748,7 +748,7 @@ CONFIG_BFIN_OTP=y
 #
 # CONFIG_CAN4LINUX is not set
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
 # CONFIG_TCG_TPM is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig
b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 66854a8..4a2a660 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -772,7 +772,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_CAN4LINUX is not set
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig
b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 6bc11db..deeb5e4 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -674,7 +674,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_CAN4LINUX is not set
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
@@ -740,7 +740,7 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set

 #
 # Graphics support
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig
b/arch/blackfin/configs/BF533-STAMP_defconfig
index d77d991..c23267e 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -681,7 +681,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_CAN4LINUX is not set
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig
b/arch/blackfin/configs/BF537-STAMP_defconfig
index 5fd7c4b..63a0f85 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -731,7 +731,7 @@ CONFIG_CAN4LINUX=y
 # CONFIG_CAN_UNCTWINCAN is not set
 CONFIG_CAN_BLACKFIN=m
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
@@ -871,7 +871,7 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set

 #
 # Graphics support
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig
b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 390669e..bf63660 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -855,7 +855,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_CAN4LINUX is not set
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
@@ -1001,7 +1001,7 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set
 # CONFIG_USB_DABUSB is not set

 #
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig
b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 976a4d7..3c70d62 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -719,7 +719,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_CAN4LINUX is not set
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
@@ -785,7 +785,7 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set

 #
 # Graphics support
diff --git a/arch/blackfin/configs/CM-BF527_defconfig
b/arch/blackfin/configs/CM-BF527_defconfig
index 0799aa9..b6a1463 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -679,7 +679,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_CAN4LINUX is not set
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
diff --git a/arch/blackfin/configs/CM-BF533_defconfig
b/arch/blackfin/configs/CM-BF533_defconfig
index 09deea4..c3ba906 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -672,7 +672,7 @@ CONFIG_HWMON=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set

 #
 # Graphics support
diff --git a/arch/blackfin/configs/CM-BF537E_defconfig
b/arch/blackfin/configs/CM-BF537E_defconfig
index 219fc34..cdc6b7f 100644
--- a/arch/blackfin/configs/CM-BF537E_defconfig
+++ b/arch/blackfin/configs/CM-BF537E_defconfig
@@ -703,7 +703,7 @@ CONFIG_HWMON=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set

 #
 # Graphics support
diff --git a/arch/blackfin/configs/CM-BF537U_defconfig
b/arch/blackfin/configs/CM-BF537U_defconfig
index 9873d58..f074bdc 100644
--- a/arch/blackfin/configs/CM-BF537U_defconfig
+++ b/arch/blackfin/configs/CM-BF537U_defconfig
@@ -683,7 +683,7 @@ CONFIG_HWMON=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set

 #
 # Graphics support
diff --git a/arch/blackfin/configs/CM-BF548_defconfig
b/arch/blackfin/configs/CM-BF548_defconfig
index 0e3605f..5c44fdb 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -762,7 +762,7 @@ CONFIG_UNIX98_PTYS=y
 #
 # CONFIG_CAN4LINUX is not set
 # CONFIG_IPMI_HANDLER is not set
-CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
 # CONFIG_RAW_DRIVER is not set
@@ -909,7 +909,7 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set
 # CONFIG_USB_DABUSB is not set

 #
diff --git a/arch/blackfin/configs/CM-BF561_defconfig
b/arch/blackfin/configs/CM-BF561_defconfig
index 59c7cdb..086fe5d 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -684,7 +684,7 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VIDEO_DEV is not set
 # CONFIG_DVB_CORE is not set
-CONFIG_DAB=y
+# CONFIG_DAB is not set

 #
 # Graphics support
diff --git a/arch/blackfin/include/asm/cacheflush.h
b/arch/blackfin/include/asm/cacheflush.h
index 5ef9e35..4403415 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -30,11 +30,11 @@
 #ifndef _BLACKFIN_CACHEFLUSH_H
 #define _BLACKFIN_CACHEFLUSH_H

-extern void blackfin_icache_dcache_flush_range(unsigned int, unsigned int);
-extern void blackfin_icache_flush_range(unsigned int, unsigned int);
-extern void blackfin_dcache_flush_range(unsigned int, unsigned int);
-extern void blackfin_dcache_invalidate_range(unsigned int, unsigned int);
-extern void blackfin_dflush_page(void *);
+extern void blackfin_icache_dcache_flush_range(unsigned long
start_address, unsigned long end_address);
+extern void blackfin_icache_flush_range(unsigned long start_address,
unsigned long end_address);
+extern void blackfin_dcache_flush_range(unsigned long start_address,
unsigned long end_address);
+extern void blackfin_dcache_invalidate_range(unsigned long
start_address, unsigned long end_address);
+extern void blackfin_dflush_page(void *page);

 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
@@ -85,4 +85,21 @@ do { memcpy(dst, src, len); \
 # define flush_dcache_page(page)			do { } while (0)
 #endif

+extern unsigned long reserved_mem_dcache_on;
+extern unsigned long reserved_mem_icache_on;
+
+static inline int bfin_addr_dcachable(unsigned long addr)
+{
+#ifdef CONFIG_BFIN_DCACHE
+	if (addr < (_ramend - DMA_UNCACHED_REGION))
+		return 1;
+#endif
+
+	if (reserved_mem_dcache_on &&
+		addr >= _ramend && addr < physical_mem_end)
+		return 1;
+
+	return 0;
+}
+
 #endif				/* _BLACKFIN_ICACHEFLUSH_H */
diff --git a/arch/blackfin/include/asm/cplbinit.h
b/arch/blackfin/include/asm/cplbinit.h
index d179b74..f845b41 100644
--- a/arch/blackfin/include/asm/cplbinit.h
+++ b/arch/blackfin/include/asm/cplbinit.h
@@ -87,23 +87,6 @@ extern u_long dpdt_swapcount_table[];

 #endif /* CONFIG_MPU */

-extern unsigned long reserved_mem_dcache_on;
-extern unsigned long reserved_mem_icache_on;
-
 extern void generate_cplb_tables(void);

-static inline int bfin_addr_dcachable(unsigned long addr)
-{
-#ifdef CONFIG_BFIN_DCACHE
-	if (addr < (_ramend - DMA_UNCACHED_REGION))
-		return 1;
-#endif
-
-	if (reserved_mem_dcache_on &&
-		addr >= _ramend && addr < physical_mem_end)
-		return 1;
-
-	return 0;
-}
-
 #endif
diff --git a/arch/blackfin/include/asm/io.h b/arch/blackfin/include/asm/io.h
index cbbf7ff..7dc77a2 100644
--- a/arch/blackfin/include/asm/io.h
+++ b/arch/blackfin/include/asm/io.h
@@ -134,6 +134,36 @@ extern void dma_insb(unsigned long port, void
*addr, unsigned short count);
 extern void dma_insw(unsigned long port, void *addr, unsigned short count);
 extern void dma_insl(unsigned long port, void *addr, unsigned short count);

+static inline void readsl(const void __iomem *addr, void *buf, int len)
+{
+	insl((unsigned long)addr, buf, len);
+}
+
+static inline void readsw(const void __iomem *addr, void *buf, int len)
+{
+	insw((unsigned long)addr, buf, len);
+}
+
+static inline void readsb(const void __iomem *addr, void *buf, int len)
+{
+	insb((unsigned long)addr, buf, len);
+}
+
+static inline void writesl(const void __iomem *addr, const void *buf, int len)
+{
+	outsl((unsigned long)addr, buf, len);
+}
+
+static inline void writesw(const void __iomem *addr, const void *buf, int len)
+{
+	outsw((unsigned long)addr, buf, len);
+}
+
+static inline void writesb(const void __iomem *addr, const void *buf, int len)
+{
+	outsb((unsigned long)addr, buf, len);
+}
+
 /*
  * Map some physical address range into the kernel address space.
  */
diff --git a/arch/blackfin/include/asm/timex.h
b/arch/blackfin/include/asm/timex.h
index 22b0806..248aeb0 100644
--- a/arch/blackfin/include/asm/timex.h
+++ b/arch/blackfin/include/asm/timex.h
@@ -16,7 +16,7 @@ typedef unsigned long long cycles_t;
 static inline cycles_t get_cycles(void)
 {
 	unsigned long tmp, tmp2;
-	__asm__("%0 = cycles; %1 = cycles2;" : "=d"(tmp), "=d"(tmp2));
+	__asm__ __volatile__("%0 = cycles; %1 = cycles2;" : "=d"(tmp), "=d"(tmp2));
 	return tmp | ((cycles_t)tmp2 << 32);
 }

diff --git a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
index 5094677..baa52e2 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>

 #include <asm/blackfin.h>
+#include <asm/cacheflush.h>
 #include <asm/cplbinit.h>
 #include <asm/mmu_context.h>

@@ -144,9 +145,7 @@ static noinline int dcplb_miss(void)

 	d_data = CPLB_SUPV_WR | CPLB_VALID | CPLB_DIRTY | PAGE_SIZE_4KB;
 #ifdef CONFIG_BFIN_DCACHE
-	if (addr < _ramend - DMA_UNCACHED_REGION ||
-	    (reserved_mem_dcache_on && addr >= _ramend &&
-	     addr < physical_mem_end)) {
+	if (bfin_addr_dcachable(addr)) {
 		d_data |= CPLB_L1_CHBL | ANOMALY_05000158_WORKAROUND;
 #ifdef CONFIG_BFIN_WT
 		d_data |= CPLB_L1_AOW | CPLB_WT;
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index 301252e..512f8c9 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>

 #include <asm/blackfin.h>
+#include <asm/cacheflush.h>
 #include <asm/cplb.h>
 #include <asm/cplbinit.h>

diff --git a/arch/blackfin/mach-bf527/head.S b/arch/blackfin/mach-bf527/head.S
index 6588170..0eb1da8 100644
--- a/arch/blackfin/mach-bf527/head.S
+++ b/arch/blackfin/mach-bf527/head.S
@@ -88,7 +88,7 @@ ENTRY(_start_dma_code)
 	r1 = r1 << 8;                    /* Shift it over                   */
 	r0 = r1 | r0;                    /* add them all together           */
 #ifdef ANOMALY_05000265
-	r0 = BITSET(r0, 15);             /* Add 250 mV of hysteresis to
SPORT input pins */
+	BITSET(r0, 15);                  /* Add 250 mV of hysteresis to
SPORT input pins */
 #endif

 	p0.h = hi(PLL_CTL);
diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 619685b..9fc95aa 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -79,7 +79,7 @@ ENTRY(_start_dma_code)
 	r1 = r1 << 8;                    /* Shift it over                   */
 	r0 = r1 | r0;                    /* add them all together           */
 #ifdef ANOMALY_05000265
-	r0 = BITSET(r0, 15);             /* Add 250 mV of hysteresis to
SPORT input pins */
+	BITSET(r0, 15);                  /* Add 250 mV of hysteresis to
SPORT input pins */
 #endif

 	p0.h = hi(PLL_CTL);
diff --git a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
index 34ab0e4..f3d9e49 100644
--- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
@@ -158,7 +158,7 @@ static void bfin_serial_hw_init(struct
bfin_serial_port *uart)
 	}
 	if (uart->rts_pin >= 0) {
 		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->rts_pin, 0);
+		gpio_direction_output(uart->rts_pin, 0);
 	}
 #endif
 }
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c
b/arch/blackfin/mach-bf537/boards/stamp.c
index dc5a308..8d39439 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -577,11 +577,6 @@ static const struct ad7877_platform_data
bfin_ad7877_ts_info = {

 #if defined(CONFIG_TOUCHSCREEN_AD7879) ||
defined(CONFIG_TOUCHSCREEN_AD7879_MODULE)
 #include <linux/spi/ad7879.h>
-static struct bfin5xx_spi_chip spi_ad7879_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-
 static const struct ad7879_platform_data bfin_ad7879_ts_info = {
 	.model			= 7879,	/* Model = AD7879 */
 	.x_plate_ohms		= 620,	/* 620 Ohm from the touch datasheet */
@@ -597,6 +592,13 @@ static const struct ad7879_platform_data
bfin_ad7879_ts_info = {
 };
 #endif

+#if defined(CONFIG_TOUCHSCREEN_AD7879_SPI) ||
defined(CONFIG_TOUCHSCREEN_AD7879_SPI_MODULE)
+static struct bfin5xx_spi_chip spi_ad7879_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
 #if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
 static struct bfin5xx_spi_chip spidev_chip_info = {
 	.enable_dma = 0,
@@ -750,7 +752,7 @@ static struct spi_board_info bfin_spi_board_info[]
__initdata = {
 		.controller_data = &spi_ad7877_chip_info,
 	},
 #endif
-#if defined(CONFIG_TOUCHSCREEN_AD7879) ||
defined(CONFIG_TOUCHSCREEN_AD7879_MODULE)
+#if defined(CONFIG_TOUCHSCREEN_AD7879_SPI) ||
defined(CONFIG_TOUCHSCREEN_AD7879_SPI_MODULE)
 	{
 		.modalias = "ad7879",
 		.platform_data = &bfin_ad7879_ts_info,
@@ -935,7 +937,7 @@ static struct i2c_board_info __initdata
bfin_i2c_board_info[] = {
 #if defined(CONFIG_JOYSTICK_AD7142) || defined(CONFIG_JOYSTICK_AD7142_MODULE)
 	{
 		I2C_BOARD_INFO("ad7142_joystick", 0x2C),
-		.irq = 55,
+		.irq = IRQ_PF5,
 	},
 #endif
 #if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
@@ -946,7 +948,14 @@ static struct i2c_board_info __initdata
bfin_i2c_board_info[] = {
 #if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
 	{
 		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
-		.irq = 72,
+		.irq = IRQ_PG6,
+	},
+#endif
+#if defined(CONFIG_TOUCHSCREEN_AD7879_I2C) ||
defined(CONFIG_TOUCHSCREEN_AD7879_I2C_MODULE)
+	{
+		I2C_BOARD_INFO("ad7879", 0x2F),
+		.irq = IRQ_PG5,
+		.platform_data = (void *)&bfin_ad7879_ts_info,
 	},
 #endif
 };
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index 559a7ee..f5c94bf 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -88,7 +88,7 @@ ENTRY(_start_dma_code)
 	r1 = r1 << 8;                    /* Shift it over                   */
 	r0 = r1 | r0;                    /* add them all together           */
 #ifdef ANOMALY_05000265
-	r0 = BITSET(r0, 15);             /* Add 250 mV of hysteresis to
SPORT input pins */
+	BITSET(r0, 15);                  /* Add 250 mV of hysteresis to
SPORT input pins */
 #endif

 	p0.h = hi(PLL_CTL);
diff --git a/arch/blackfin/mach-bf548/head.S b/arch/blackfin/mach-bf548/head.S
index 051b05c..93b361d 100644
--- a/arch/blackfin/mach-bf548/head.S
+++ b/arch/blackfin/mach-bf548/head.S
@@ -95,7 +95,7 @@ ENTRY(_start_dma_code)
 	r1 = r1 << 8;                    /* Shift it over                   */
 	r0 = r1 | r0;                    /* add them all together           */
 #ifdef ANOMALY_05000265
-	r0 = BITSET(r0, 15);             /* Add 250 mV of hysteresis to
SPORT input pins */
+	BITSET(r0, 15);                  /* Add 250 mV of hysteresis to
SPORT input pins */
 #endif

 	p0.h = hi(PLL_CTL);
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 0b28137..31a777a 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -78,7 +78,7 @@ ENTRY(_start_dma_code)
 	r1 = r1 << 8;                    /* Shift it over                   */
 	r0 = r1 | r0;                    /* add them all together           */
 #ifdef ANOMALY_05000265
-	r0 = BITSET(r0, 15);             /* Add 250 mV of hysteresis to
SPORT input pins */
+	BITSET(r0, 15);                  /* Add 250 mV of hysteresis to
SPORT input pins */
 #endif

 	p0.h = hi(PLL_CTL);
diff --git a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
index f532726..043bfcf 100644
--- a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
@@ -158,7 +158,7 @@ static void bfin_serial_hw_init(struct
bfin_serial_port *uart)
 	}
 	if (uart->rts_pin >= 0) {
 		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->rts_pin, 0);
+		gpio_direction_output(uart->rts_pin, 0);
 	}
 #endif
 }
diff --git a/arch/blackfin/mach-common/cache.S
b/arch/blackfin/mach-common/cache.S
index 85f8c79..db53218 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -1,148 +1,91 @@
 /*
- * File:         arch/blackfin/mach-common/cache.S
- * Based on:
- * Author:       LG Soft India
+ * Blackfin cache control code
  *
- * Created:
- * Description:  cache control support
+ * Copyright 2004-2008 Analog Devices Inc.
  *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
+ * Enter bugs at http://blackfin.uclinux.org/
  *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ * Licensed under the GPL-2 or later.
  */

 #include <linux/linkage.h>
-#include <asm/cplb.h>
-#include <asm/entry.h>
 #include <asm/blackfin.h>
 #include <asm/cache.h>
+#include <asm/page.h>

 .text

-/*
- * blackfin_cache_flush_range(start, end)
- * Invalidate all cache lines assocoiated with this
- * area of memory.
+/* Since all L1 caches work the same way, we use the same method for flushing
+ * them.  Only the actual flush instruction differs.  We write this in asm as
+ * GCC can be hard to coax into writing nice hardware loops.
  *
- * start:	Start address
- * end:		End address
+ * Also, we assume the following register setup:
+ * R0 = start address
+ * R1 = end address
  */
-ENTRY(_blackfin_icache_flush_range)
+.macro do_flush flushins:req optflushins optnopins label
+
+	/* end = ((end - 1) & -L1_CACHE_BYTES) + L1_CACHE_BYTES; */
+	R1 += -1;
 	R2 = -L1_CACHE_BYTES;
-	R2 = R0 & R2;
-	P0 = R2;
-	P1 = R1;
-	CSYNC(R3);
-	IFLUSH [P0];
+	R1 = R1 & R2;
+	R1 += L1_CACHE_BYTES;
+
+	/* count = (end - start) >> L1_CACHE_SHIFT */
+	R2 = R1 - R0;
+	R2 >>= L1_CACHE_SHIFT;
+	P1 = R2;
+
+.ifnb \label
+\label :
+.endif
+	P0 = R0;
+	LSETUP (1f, 2f) LC1 = P1;
 1:
-	IFLUSH [P0++];
-	CC = P0 < P1 (iu);
-	IF CC JUMP 1b (bp);
-	IFLUSH [P0];
-	SSYNC(R3);
+.ifnb \optflushins
+	\optflushins [P0];
+.endif
+.ifb \optnopins
+2:
+.endif
+	\flushins [P0++];
+.ifnb \optnopins
+2: \optnopins;
+.endif
+
 	RTS;
-ENDPROC(_blackfin_icache_flush_range)
+.endm

-/*
- * blackfin_icache_dcache_flush_range(start, end)
- * FLUSH all cache lines assocoiated with this
- * area of memory.
- *
- * start:	Start address
- * end:		End address
- */
+/* Invalidate all instruction cache lines assocoiated with this memory area */
+ENTRY(_blackfin_icache_flush_range)
+	do_flush IFLUSH, , nop
+ENDPROC(_blackfin_icache_flush_range)

+/* Flush all cache lines assocoiated with this area of memory. */
 ENTRY(_blackfin_icache_dcache_flush_range)
-	R2 = -L1_CACHE_BYTES;
-	R2 = R0 & R2;
-	P0 = R2;
-	P1 = R1;
-	CSYNC(R3);
-	IFLUSH [P0];
-1:
-	FLUSH [P0];
-	IFLUSH [P0++];
-	CC = P0 < P1 (iu);
-	IF CC JUMP 1b (bp);
-	IFLUSH [P0];
-	FLUSH [P0];
-	SSYNC(R3);
-	RTS;
+	do_flush IFLUSH, FLUSH
 ENDPROC(_blackfin_icache_dcache_flush_range)

 /* Throw away all D-cached data in specified region without any obligation to
- * write them back. However, we must clean the D-cached entries around the
- * boundaries of the start and/or end address is not cache aligned.
- *
- * Start: start address,
- * end  : end address.
+ * write them back.  Since the Blackfin ISA does not have an "invalidate"
+ * instruction, we use flush/invalidate.  Perhaps as a speed optimization we
+ * could bang on the DTEST MMRs ...
  */
-
 ENTRY(_blackfin_dcache_invalidate_range)
-	R2 = -L1_CACHE_BYTES;
-	R2 = R0 & R2;
-	P0 = R2;
-	P1 = R1;
-	CSYNC(R3);
-	FLUSHINV[P0];
-1:
-	FLUSHINV[P0++];
-	CC = P0 < P1 (iu);
-	IF CC JUMP 1b (bp);
-
-	/* If the data crosses a cache line, then we'll be pointing to
-	 * the last cache line, but won't have flushed/invalidated it yet,
-	 * so do one more.
-	 */
-	FLUSHINV[P0];
-	SSYNC(R3);
-	RTS;
+	do_flush FLUSHINV
 ENDPROC(_blackfin_dcache_invalidate_range)

+/* Flush all data cache lines assocoiated with this memory area */
 ENTRY(_blackfin_dcache_flush_range)
-	R2 = -L1_CACHE_BYTES;
-	R2 = R0 & R2;
-	P0 = R2;
-	P1 = R1;
-	CSYNC(R3);
-	FLUSH[P0];
-1:
-	FLUSH[P0++];
-	CC = P0 < P1 (iu);
-	IF CC JUMP 1b (bp);
-
-	/* If the data crosses a cache line, then we'll be pointing to
-	 * the last cache line, but won't have flushed it yet, so do
-	 * one more.
-	 */
-	FLUSH[P0];
-	SSYNC(R3);
-	RTS;
+	do_flush FLUSH, , , .Ldfr
 ENDPROC(_blackfin_dcache_flush_range)

+/* Our headers convert the page structure to an address, so just need to flush
+ * its contents like normal.  We know the start address is page aligned (which
+ * greater than our cache alignment), as is the end address.  So just jump into
+ * the middle of the dcache flush function.
+ */
 ENTRY(_blackfin_dflush_page)
 	P1 = 1 << (PAGE_SHIFT - L1_CACHE_SHIFT);
-	P0 = R0;
-	CSYNC(R3);
-	FLUSH[P0];
-	LSETUP (.Lfl1, .Lfl1) LC0 = P1;
-.Lfl1:	FLUSH [P0++];
-	SSYNC(R3);
-	RTS;
+	jump .Ldfr;
 ENDPROC(_blackfin_dflush_page)
diff --git a/arch/blackfin/mach-common/head.S b/arch/blackfin/mach-common/head.S
index 3069df5..f123a62 100644
--- a/arch/blackfin/mach-common/head.S
+++ b/arch/blackfin/mach-common/head.S
@@ -206,6 +206,60 @@ ENTRY(_real_start)
 	w[p0] = r0;
 	ssync;

+#if L1_DATA_A_LENGTH > 0
+	r1.l = __sbss_l1;
+	r1.h = __sbss_l1;
+	r2.l = __ebss_l1;
+	r2.h = __ebss_l1;
+	r0 = 0 (z);
+	r2 = r2 - r1;
+	cc = r2 == 0;
+	if cc jump .L_a_l1_done;
+	r2 >>= 2;
+	p1 = r1;
+	p2 = r2;
+	lsetup (.L_clear_a_l1, .L_clear_a_l1 ) lc0 = p2;
+.L_clear_a_l1:
+	[p1++] = r0;
+.L_a_l1_done:
+#endif
+
+#if L1_DATA_B_LENGTH > 0
+	r1.l = __sbss_b_l1;
+	r1.h = __sbss_b_l1;
+	r2.l = __ebss_b_l1;
+	r2.h = __ebss_b_l1;
+	r0 = 0 (z);
+	r2 = r2 - r1;
+	cc = r2 == 0;
+	if cc jump .L_b_l1_done;
+	r2 >>= 2;
+	p1 = r1;
+	p2 = r2;
+	lsetup (.L_clear_b_l1, .L_clear_b_l1 ) lc0 = p2;
+.L_clear_b_l1:
+	[p1++] = r0;
+.L_b_l1_done:
+#endif
+
+#if L2_LENGTH > 0
+	r1.l = __sbss_l2;
+	r1.h = __sbss_l2;
+	r2.l = __ebss_l2;
+	r2.h = __ebss_l2;
+	r0 = 0 (z);
+	r2 = r2 - r1;
+	cc = r2 == 0;
+	if cc jump .L_l2_done;
+	r2 >>= 2;
+	p1 = r1;
+	p2 = r2;
+	lsetup (.L_clear_l2, .L_clear_l2 ) lc0 = p2;
+.L_clear_l2:
+	[p1++] = r0;
+.L_l2_done:
+#endif
+
 	/* Zero out the bss region
 	 * Note: this will fail if bss is 0 bytes ...
 	 */

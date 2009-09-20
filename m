Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbZITLvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbZITLvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 07:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZITLvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 07:51:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:43474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZITLvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 07:51:53 -0400
Subject: [GIT-PULL] includecheck fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 20 Sep 2009 17:22:00 +0530
Message-Id: <1253447520.19515.19.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull includecheck fixes.

The following changes since commit 78f28b7c555359c67c2a0d23f7436e915329421e:
  Linus Torvalds (1):
        Merge branch 'x86-platform-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6.git master

Jaswinder Singh Rajput (15):
      includecheck fix: s390, sys_s390.c
      includecheck fix: um, helper.c
      includecheck fix: x86, traps.c
      includecheck fix: x86, shadow.c
      includecheck fix: drivers/scsi, libfcoe.c
      includecheck fix: drivers/scsi, ibmvscsi.c
      includecheck fix: drivers/video, vgacon.c
      includecheck fix: drivers/xen, evtchn.c
      includecheck fix: include/acpi, acpi_bus.h
      includecheck fix: include/drm, drm_memory.h
      includecheck fix: include/linux, aio.h
      includecheck fix: include/linux, page_cgroup.h
      includecheck fix: include/linux, ftrace.h
      includecheck fix: kernel/trace, ring_buffer.c
      includecheck fix: x86, cpu/common.c

 arch/s390/kernel/sys_s390.c      |    1 -
 arch/um/os-Linux/helper.c        |    1 -
 arch/x86/kernel/cpu/common.c     |    1 -
 arch/x86/kernel/traps.c          |    1 -
 arch/x86/mm/kmemcheck/shadow.c   |    1 -
 drivers/scsi/fcoe/libfcoe.c      |    1 -
 drivers/scsi/ibmvscsi/ibmvscsi.c |    1 -
 drivers/video/console/vgacon.c   |    1 -
 drivers/xen/evtchn.c             |    1 -
 include/acpi/acpi_bus.h          |    1 -
 include/drm/drm_memory.h         |    2 --
 include/linux/aio.h              |    2 --
 include/linux/ftrace.h           |    1 -
 include/linux/page_cgroup.h      |    4 ++--
 kernel/trace/ring_buffer.c       |    2 --
 15 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index c7ae4b1..e9d94f6 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -29,7 +29,6 @@
 #include <linux/personality.h>
 #include <linux/unistd.h>
 #include <linux/ipc.h>
-#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include "entry.h"
 
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index 30860b8..b6b1096 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -15,7 +15,6 @@
 #include "os.h"
 #include "um_malloc.h"
 #include "user.h"
-#include <linux/limits.h>
 
 struct helper_data {
 	void (*pre_exec)(void*);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2055fc2..2fea97e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -34,7 +34,6 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/pat.h>
-#include <linux/smp.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/uv/uv.h>
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 7dc0de9..9346e10 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -65,7 +65,6 @@
 #else
 #include <asm/processor-flags.h>
 #include <asm/setup.h>
-#include <asm/traps.h>
 
 asmlinkage int system_call(void);
 
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
index e773b6b..3f66b82 100644
--- a/arch/x86/mm/kmemcheck/shadow.c
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -1,7 +1,6 @@
 #include <linux/kmemcheck.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 62a4c20..11ae5c9 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -29,7 +29,6 @@
 #include <linux/ethtool.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
-#include <linux/netdevice.h>
 #include <linux/errno.h>
 #include <linux/bitops.h>
 #include <net/rtnetlink.h>
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 9928704..d9b0e9d 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -73,7 +73,6 @@
 #include <linux/of.h>
 #include <asm/firmware.h>
 #include <asm/vio.h>
-#include <asm/firmware.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 59d7d5e..74e96cf 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -180,7 +180,6 @@ static inline void vga_set_mem_top(struct vc_data *c)
 }
 
 #ifdef CONFIG_VGACON_SOFT_SCROLLBACK
-#include <linux/slab.h>
 /* software scrollback */
 static void *vgacon_scrollback;
 static int vgacon_scrollback_tail;
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index af03195..79bedba 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -38,7 +38,6 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/major.h>
 #include <linux/proc_fs.h>
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 1fa3ffb..1b3b360 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -356,7 +356,6 @@ void acpi_remove_dir(struct acpi_device *);
 /*
  * Bind physical devices with ACPI devices
  */
-#include <linux/device.h>
 struct acpi_bus_type {
 	struct list_head list;
 	struct bus_type *bus;
diff --git a/include/drm/drm_memory.h b/include/drm/drm_memory.h
index 63e425b..15af9b3 100644
--- a/include/drm/drm_memory.h
+++ b/include/drm/drm_memory.h
@@ -44,8 +44,6 @@
 
 #if __OS_HAS_AGP
 
-#include <linux/vmalloc.h>
-
 #ifdef HAVE_PAGE_AGP
 #include <asm/agp.h>
 #else
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 47f7d93..aea219d 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -225,8 +225,6 @@ static inline void exit_aio(struct mm_struct *mm) { }
 
 #define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
 
-#include <linux/aio_abi.h>
-
 static inline struct kiocb *list_kiocb(struct list_head *h)
 {
 	return list_entry(h, struct kiocb, ki_list);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index dc3b132..3c0924a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -446,7 +446,6 @@ static inline void unpause_graph_tracing(void) { }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 #ifdef CONFIG_TRACING
-#include <linux/sched.h>
 
 /* flags for current->trace */
 enum {
diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 13f126c..ada779f 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -105,14 +105,14 @@ static inline void __init page_cgroup_init_flatmem(void)
 
 #endif
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 #include <linux/swap.h>
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id);
 extern unsigned short lookup_swap_cgroup(swp_entry_t ent);
 extern int swap_cgroup_swapon(int type, unsigned long max_pages);
 extern void swap_cgroup_swapoff(int type);
 #else
-#include <linux/swap.h>
 
 static inline
 unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6eef389..d4ff019 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -201,8 +201,6 @@ int tracing_is_on(void)
 }
 EXPORT_SYMBOL_GPL(tracing_is_on);
 
-#include "trace.h"
-
 #define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
 #define RB_ALIGNMENT		4U
 #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)



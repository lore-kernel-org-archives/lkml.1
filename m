Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbYCCTYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbYCCTYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYCCTYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:24:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:23799 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbYCCTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=awYTS7OH+EUQ8b4GVPX+VLN06Qjj8kd9IPhpQH1pL20828ojgLECBb+JuH1JvgZXGN71c3GW3E3xqlQfNywwvVhu07T//zzL8AKi+UZoVufB6nRWX98FzFyB5c0a9RL7fkMQEpzznLpz8wxeebOXUZLs9skApgtg2B5FZjdJEjE=
Subject: [PATCH] sh: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:23:59 -0800
Message-Id: <1204572239.3266.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sh/boards/renesas/x3proto/ilsel.c |    2 +-
 arch/sh/boards/superh/microdev/io.c    |    2 +-
 arch/sh/kernel/cpu/sh4/sq.c            |    4 ++--
 arch/sh/kernel/cpu/sh5/unwind.c        |    2 +-
 arch/sh/kernel/timers/timer-cmt.c      |    2 +-
 arch/sh/kernel/timers/timer-mtu2.c     |    2 +-
 arch/sh/kernel/topology.c              |    2 +-
 arch/sh/kernel/traps_64.c              |    2 +-
 arch/sh/lib64/c-checksum.c             |    2 +-
 arch/sh/mm/init.c                      |    2 +-
 arch/sh/mm/ioremap_32.c                |    2 +-
 arch/sh/mm/ioremap_64.c                |    4 ++--
 arch/sh/mm/tlbflush_64.c               |    6 +++---
 13 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/sh/boards/renesas/x3proto/ilsel.c b/arch/sh/boards/renesas/x3proto/ilsel.c
index 6d4454f..b5c673c 100644
--- a/arch/sh/boards/renesas/x3proto/ilsel.c
+++ b/arch/sh/boards/renesas/x3proto/ilsel.c
@@ -68,7 +68,7 @@ static void __ilsel_enable(ilsel_source_t set, unsigned int bit)
 	shift = mk_ilsel_shift(bit);
 
 	pr_debug("%s: bit#%d: addr - 0x%08lx (shift %d, set %d)\n",
-		 __FUNCTION__, bit, addr, shift, set);
+		 __func__, bit, addr, shift, set);
 
 	tmp = ctrl_inw(addr);
 	tmp &= ~(0xf << shift);
diff --git a/arch/sh/boards/superh/microdev/io.c b/arch/sh/boards/superh/microdev/io.c
index b704e20..9f8a540 100644
--- a/arch/sh/boards/superh/microdev/io.c
+++ b/arch/sh/boards/superh/microdev/io.c
@@ -127,7 +127,7 @@ static unsigned long microdev_isa_port2addr(unsigned long offset)
 			 *	safe default.
 			 */
 		printk("Warning: unexpected port in %s( offset = 0x%lx )\n",
-		       __FUNCTION__, offset);
+		       __func__, offset);
 		result = PVR;
 	}
 
diff --git a/arch/sh/kernel/cpu/sh4/sq.c b/arch/sh/kernel/cpu/sh4/sq.c
index 8250e01..9561b02 100644
--- a/arch/sh/kernel/cpu/sh4/sq.c
+++ b/arch/sh/kernel/cpu/sh4/sq.c
@@ -216,7 +216,7 @@ void sq_unmap(unsigned long vaddr)
 
 	if (unlikely(!map)) {
 		printk("%s: bad store queue address 0x%08lx\n",
-		       __FUNCTION__, vaddr);
+		       __func__, vaddr);
 		return;
 	}
 
@@ -233,7 +233,7 @@ void sq_unmap(unsigned long vaddr)
 		vma = remove_vm_area((void *)(map->sq_addr & PAGE_MASK));
 		if (!vma) {
 			printk(KERN_ERR "%s: bad address 0x%08lx\n",
-			       __FUNCTION__, map->sq_addr);
+			       __func__, map->sq_addr);
 			return;
 		}
 	}
diff --git a/arch/sh/kernel/cpu/sh5/unwind.c b/arch/sh/kernel/cpu/sh5/unwind.c
index 119c20a..b205b25 100644
--- a/arch/sh/kernel/cpu/sh5/unwind.c
+++ b/arch/sh/kernel/cpu/sh5/unwind.c
@@ -149,7 +149,7 @@ static int lookup_prev_stack_frame(unsigned long fp, unsigned long pc,
 			if (dest >= 63) {
 				printk(KERN_NOTICE "%s: Invalid dest reg %d "
 				       "specified in movi handler. Failed "
-				       "opcode was 0x%lx: ", __FUNCTION__,
+				       "opcode was 0x%lx: ", __func__,
 				       dest, op);
 
 				continue;
diff --git a/arch/sh/kernel/timers/timer-cmt.c b/arch/sh/kernel/timers/timer-cmt.c
index 7131232..d20c8c3 100644
--- a/arch/sh/kernel/timers/timer-cmt.c
+++ b/arch/sh/kernel/timers/timer-cmt.c
@@ -77,7 +77,7 @@ static unsigned long cmt_timer_get_offset(void)
 				count -= LATCH;
 			} else {
 				printk("%s (): hardware timer problem?\n",
-				       __FUNCTION__);
+				       __func__);
 			}
 		}
 	} else
diff --git a/arch/sh/kernel/timers/timer-mtu2.c b/arch/sh/kernel/timers/timer-mtu2.c
index ade9d6e..fe453c0 100644
--- a/arch/sh/kernel/timers/timer-mtu2.c
+++ b/arch/sh/kernel/timers/timer-mtu2.c
@@ -76,7 +76,7 @@ static unsigned long mtu2_timer_get_offset(void)
 				count -= LATCH;
 			} else {
 				printk("%s (): hardware timer problem?\n",
-				       __FUNCTION__);
+				       __func__);
 			}
 		}
 	} else
diff --git a/arch/sh/kernel/topology.c b/arch/sh/kernel/topology.c
index 9b5844a..0838942 100644
--- a/arch/sh/kernel/topology.c
+++ b/arch/sh/kernel/topology.c
@@ -29,7 +29,7 @@ static int __init topology_init(void)
 		ret = register_cpu(&per_cpu(cpu_devices, i), i);
 		if (unlikely(ret))
 			printk(KERN_WARNING "%s: register_cpu %d failed (%d)\n",
-			       __FUNCTION__, i, ret);
+			       __func__, i, ret);
 	}
 
 #if defined(CONFIG_NUMA) && !defined(CONFIG_SMP)
diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index a55ac81..1b58a74 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -238,7 +238,7 @@ DO_ERROR(12, SIGILL,  "reserved instruction", reserved_inst, current)
 /* Called with interrupts disabled */
 asmlinkage void do_exception_error(unsigned long ex, struct pt_regs *regs)
 {
-	show_excp_regs(__FUNCTION__, -1, -1, regs);
+	show_excp_regs(__func__, -1, -1, regs);
 	die_if_kernel("exception", regs, ex);
 }
 
diff --git a/arch/sh/lib64/c-checksum.c b/arch/sh/lib64/c-checksum.c
index 5dfbd8b..5c284e0 100644
--- a/arch/sh/lib64/c-checksum.c
+++ b/arch/sh/lib64/c-checksum.c
@@ -207,7 +207,7 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 	result = (result & 0xffffffff) + (result >> 32);
 
 	pr_debug("%s saddr %x daddr %x len %x proto %x sum %x result %08Lx\n",
-		__FUNCTION__, saddr, daddr, len, proto, sum, result);
+		__func__, saddr, daddr, len, proto, sum, result);
 
 	return (__wsum)result;
 }
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index e2ed6dd..53dde06 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -328,7 +328,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	/* We only have ZONE_NORMAL, so this is easy.. */
 	ret = __add_pages(pgdat->node_zones + ZONE_NORMAL, start_pfn, nr_pages);
 	if (unlikely(ret))
-		printk("%s: Failed, __add_pages() == %d\n", __FUNCTION__, ret);
+		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
 	return ret;
 }
diff --git a/arch/sh/mm/ioremap_32.c b/arch/sh/mm/ioremap_32.c
index 0c7b7e3..882a32e 100644
--- a/arch/sh/mm/ioremap_32.c
+++ b/arch/sh/mm/ioremap_32.c
@@ -141,7 +141,7 @@ void __iounmap(void __iomem *addr)
 
 	p = remove_vm_area((void *)(vaddr & PAGE_MASK));
 	if (!p) {
-		printk(KERN_ERR "%s: bad address %p\n", __FUNCTION__, addr);
+		printk(KERN_ERR "%s: bad address %p\n", __func__, addr);
 		return;
 	}
 
diff --git a/arch/sh/mm/ioremap_64.c b/arch/sh/mm/ioremap_64.c
index e27d165..cea224c 100644
--- a/arch/sh/mm/ioremap_64.c
+++ b/arch/sh/mm/ioremap_64.c
@@ -178,7 +178,7 @@ static unsigned long shmedia_alloc_io(unsigned long phys, unsigned long size,
         } else {
                 if (!printed_full) {
                         printk("%s: done with statics, switching to kmalloc\n",
-			       __FUNCTION__);
+			       __func__);
                         printed_full = 1;
                 }
                 tlen = strlen(name);
@@ -352,7 +352,7 @@ void onchip_unmap(unsigned long vaddr)
 	res = shmedia_find_resource(&shmedia_iomap, vaddr);
 	if (!res) {
 		printk(KERN_ERR "%s: Failed to free 0x%08lx\n",
-		       __FUNCTION__, vaddr);
+		       __func__, vaddr);
 		return;
 	}
 
diff --git a/arch/sh/mm/tlbflush_64.c b/arch/sh/mm/tlbflush_64.c
index 2a98c9e..7876997 100644
--- a/arch/sh/mm/tlbflush_64.c
+++ b/arch/sh/mm/tlbflush_64.c
@@ -131,7 +131,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long writeaccess,
 #ifdef DEBUG_FAULT
 		print_task(tsk);
 		printk("%s:%d fault, address is 0x%08x PC %016Lx textaccess %d writeaccess %d\n",
-		       __FUNCTION__,__LINE__,
+		       __func__, __LINE__,
 		       address,regs->pc,textaccess,writeaccess);
 		show_regs(regs);
 #endif
@@ -145,7 +145,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long writeaccess,
 #ifdef DEBUG_FAULT
 		print_task(tsk);
 		printk("%s:%d fault, address is 0x%08x PC %016Lx textaccess %d writeaccess %d\n",
-		       __FUNCTION__,__LINE__,
+		       __func__, __LINE__,
 		       address,regs->pc,textaccess,writeaccess);
 		show_regs(regs);
 
@@ -157,7 +157,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long writeaccess,
 #ifdef DEBUG_FAULT
 		print_task(tsk);
 		printk("%s:%d fault, address is 0x%08x PC %016Lx textaccess %d writeaccess %d\n",
-		       __FUNCTION__,__LINE__,
+		       __func__, __LINE__,
 		       address,regs->pc,textaccess,writeaccess);
 		show_regs(regs);
 #endif
-- 
1.5.4.3.500.g83a2c




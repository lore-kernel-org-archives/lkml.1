Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbZDHH03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbZDHH03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760528AbZDHHZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:25:58 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:55402 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836AbZDHHZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:25:54 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 4/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF37DA4769.A6BC9B10-ON48257592.00287E6E-48257592.0028CC22@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:23:28 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:23:29,
	Serialize complete at 2009/04/08 ?? 03:23:29
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

asm/kmap_types.h, asm/linkage.h, asm/local.h, asm/mman.h, 
asm/mmu_context.h,
asm/mmu.h, asm/module.h, asm/msgbuf.h, asm/mutex.h, asm/page.h, 
asm/param.h,
asm/pci.h, asm/percpu.h, asm/pgalloc.h, asm/pgtable-32.h, 
asm/pgtable-bits.h,
asm/pgtable.h, asm/poll.h, asm/posix_types.h and asm/processor.h
for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/kmap_types.h 
linux-2.6-git.new/arch/score/include/asm/kmap_types.h
--- linux-2.6-git.ori/arch/score/include/asm/kmap_types.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/kmap_types.h       2009-04-03 
17:01:04.000000000 +0800
@@ -0,0 +1,21 @@
+#ifndef __SCORE_KMAP_TYPES_H
+#define __SCORE_KMAP_TYPES_H
+
+enum km_type {
+       KM_BOUNCE_READ,
+       KM_SKB_SUNRPC_DATA,
+       KM_SKB_DATA_SOFTIRQ,
+       KM_USER0,
+       KM_USER1,
+       KM_BIO_SRC_IRQ,
+       KM_BIO_DST_IRQ,
+       KM_PTE0,
+       KM_PTE1,
+       KM_IRQ0,
+       KM_IRQ1,
+       KM_SOFTIRQ0,
+       KM_SOFTIRQ1,
+       KM_TYPE_NR
+};
+
+#endif
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/linkage.h 
linux-2.6-git.new/arch/score/include/asm/linkage.h
--- linux-2.6-git.ori/arch/score/include/asm/linkage.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/linkage.h  2009-04-03 
17:01:17.000000000 +0800
@@ -0,0 +1,4 @@
+#ifndef __SCORE_LINKAGE_H
+#define __SCORE_LINKAGE_H
+
+#endif
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/local.h 
linux-2.6-git.new/arch/score/include/asm/local.h
--- linux-2.6-git.ori/arch/score/include/asm/local.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/local.h    2009-04-03 
17:01:32.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_LOCAL_H
+#define __SCORE_LOCAL_H
+
+#include <asm-generic/local.h>
+
+#endif /* __SCORE_LOCAL_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/mman.h 
linux-2.6-git.new/arch/score/include/asm/mman.h
--- linux-2.6-git.ori/arch/score/include/asm/mman.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/mman.h     2009-04-03 
17:01:40.000000000 +0800
@@ -0,0 +1,69 @@
+#ifndef __SCORE_MMAN_H
+#define __SCORE_MMAN_H
+
+/*
+ * Protections are chosen from these bits, OR'd together.  The
+ * implementation does not necessarily support PROT_EXEC or PROT_WRITE
+ * without PROT_READ.  The only guarantees are that no writing will be
+ * allowed without PROT_WRITE and no access will be allowed for 
PROT_NONE.
+ */
+#define PROT_NONE      0x00            /* page can not be accessed */
+#define PROT_READ      0x01            /* page can be read */
+#define PROT_WRITE     0x02            /* page can be written */
+#define PROT_EXEC      0x04            /* page can be executed */
+#define PROT_SEM       0x10            /* page may be used for atomic ops 
*/
+#define PROT_GROWSDOWN 0x01000000      /* mprotect flag: extend change to 
start of growsdown vma */
+#define PROT_GROWSUP   0x02000000      /* mprotect flag: extend change to 
end of growsup vma */
+
+/*
+ * Flags for mmap
+ */
+#define MAP_SHARED     0x001           /* Share changes */
+#define MAP_PRIVATE    0x002           /* Changes are private */
+#define MAP_TYPE       0x00f           /* Mask for type of mapping */
+#define MAP_FIXED      0x010           /* Interpret addr exactly */
+
+/* not used by linux, but here to make sure we don't clash with ABI 
defines */
+#define MAP_RENAME     0x020           /* Assign page to file */
+#define MAP_AUTOGROW   0x040           /* File may grow by writing */
+#define MAP_LOCAL      0x080           /* Copy on fork/sproc */
+#define MAP_AUTORSRV   0x100           /* Logical swap reserved on demand 
*/
+
+/* These are linux-specific */
+#define MAP_NORESERVE  0x0400          /* don't check for reservations */
+#define MAP_ANONYMOUS  0x0800          /* don't use a file */
+#define MAP_GROWSDOWN  0x1000          /* stack-like segment */
+#define MAP_DENYWRITE  0x2000          /* ETXTBSY */
+#define MAP_EXECUTABLE 0x4000          /* mark it as an executable */
+#define MAP_LOCKED     0x8000          /* pages are locked */
+#define MAP_POPULATE   0x10000         /* populate (prefault) pagetables 
*/
+#define MAP_NONBLOCK   0x20000         /* do not block on IO */
+
+/*
+ * Flags for msync
+ */
+#define MS_ASYNC       0x0001          /* sync memory asynchronously */
+#define MS_INVALIDATE  0x0002          /* invalidate mappings & caches */
+#define MS_SYNC                0x0004          /* synchronous memory sync 
*/
+
+/*
+ * Flags for mlockall
+ */
+#define MCL_CURRENT    1               /* lock all current mappings */
+#define MCL_FUTURE     2               /* lock all future mappings */
+
+#define MADV_NORMAL    0               /* no further special treatment */
+#define MADV_RANDOM    1               /* expect random page references 
*/
+#define MADV_SEQUENTIAL        2               /* expect sequential page 
references */
+#define MADV_WILLNEED  3               /* will need these pages */
+#define MADV_DONTNEED  4               /* don't need these pages */
+
+/* common parameters: try to keep these consistent across architectures 
*/
+#define MADV_REMOVE    9               /* remove these pages & resources 
*/
+#define MADV_DONTFORK  10              /* don't inherit across fork */
+#define MADV_DOFORK    11              /* do inherit across fork */
+
+/* compatibility flags */
+#define MAP_FILE       0
+
+#endif /* __SCORE_MMAN_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/mmu_context.h 
linux-2.6-git.new/arch/score/include/asm/mmu_context.h
--- linux-2.6-git.ori/arch/score/include/asm/mmu_context.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/mmu_context.h      2009-04-08 
11:04:39.000000000 +0800
@@ -0,0 +1,108 @@
+#ifndef __SCORE_MMU_CONTEXT_H
+#define __SCORE_MMU_CONTEXT_H
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <asm/cacheflush.h>
+#include <asm-generic/mm_hooks.h>
+#include <asm/tlbflush.h>
+#include <asm/scoreregs.h>
+
+/*
+ * For the fast tlb miss handlers, we keep a per cpu array of pointers
+ * to the current pgd for each processor. Also, the proc. id is stuffed
+ * into the context register.
+ */
+extern unsigned long asid_cache;
+extern unsigned long pgd_current;
+
+#define TLBMISS_HANDLER_SETUP_PGD(pgd) (pgd_current = (unsigned 
long)(pgd))
+
+#define TLBMISS_HANDLER_SETUP()                                \
+do {                                                   \
+       write_c0_context(0);                            \
+       TLBMISS_HANDLER_SETUP_PGD(swapper_pg_dir)       \
+} while (0)
+
+/*
+ *  All unused by hardware upper bits will be considered
+ *  as a software asid extension.
+ */
+#define ASID_VERSION_MASK  0xfffff000
+#define ASID_FIRST_VERSION 0x1000
+
+                               /* PEVN    --------- VPN ---------- 
--ASID--- -NA- */
+#define ASID_INC       0x10    /* binary: 0000 0000 0000 0000 0000 0000 
0001 0000 */
+#define ASID_MASK      0xff0   /* binary: 0000 0000 0000 0000 0000 1111 
1111 0000 */
+
+#define cpu_context(cpu, mm)   ((mm)->context[cpu])
+#define cpu_asid(cpu, mm)      (cpu_context((cpu), (mm)) & ASID_MASK)
+#define asid_cache(cpu)                (asid_cache)
+
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct 
task_struct *tsk)
+{}
+
+static inline void
+get_new_mmu_context(struct mm_struct *mm, unsigned long cpu)
+{
+       unsigned long asid = asid_cache(0);
+
+       if (!((asid = asid + ASID_INC) & ASID_MASK)) {
+               local_flush_tlb_all();          /* start new asid cycle */
+               if (!asid)                      /* fix version if needed 
*/
+                       asid = ASID_FIRST_VERSION;
+       }
+       cpu_context(0, mm) = asid_cache(0) = asid;
+}
+
+/*
+ * Initialize the context related info for a new mm_struct
+ * instance.
+ */
+static inline int
+init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+       cpu_context(0, mm) = 0;
+       return 0;
+}
+
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct 
*next,
+                               struct task_struct *tsk)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       if ((cpu_context(0, next) ^ asid_cache(0)) & ASID_VERSION_MASK)
+               get_new_mmu_context(next, 0);
+       set_PEVN(cpu_context(0, next));
+       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
+       local_irq_restore(flags);
+}
+
+/*
+ * Destroy context related info for an mm_struct that is about
+ * to be put to rest.
+ */
+static inline void destroy_context(struct mm_struct *mm)
+{}
+
+#define deactivate_mm(tsk, mm) do {} while (0)
+
+/*
+ * After we have set current->mm to a new value, this activates
+ * the context for the new mm so we see the new mappings.
+ */
+static inline void
+activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       get_new_mmu_context(next, 0);
+       set_PEVN(cpu_context(0, next));
+       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
+       local_irq_restore(flags);
+}
+
+#endif /* __SCORE_MMU_CONTEXT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/mmu.h 
linux-2.6-git.new/arch/score/include/asm/mmu.h
--- linux-2.6-git.ori/arch/score/include/asm/mmu.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/mmu.h      2009-04-08 
10:51:34.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_MMU_H
+#define __SCORE_MMU_H
+
+typedef unsigned long mm_context_t[NR_CPUS];
+
+#endif /* __SCORE_MMU_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/module.h 
linux-2.6-git.new/arch/score/include/asm/module.h
--- linux-2.6-git.ori/arch/score/include/asm/module.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/module.h   2009-04-03 
17:02:05.000000000 +0800
@@ -0,0 +1,45 @@
+#ifndef __SCORE_MODULE_H
+#define __SCORE_MODULE_H
+
+#include <linux/list.h>
+#include <asm/uaccess.h>
+
+struct mod_arch_specific {
+       /* Data Bus Error exception tables */
+       struct list_head dbe_list;
+       const struct exception_table_entry *dbe_start;
+       const struct exception_table_entry *dbe_end;
+};
+
+typedef uint8_t Elf64_Byte;            /* Type for a 8-bit quantity. */
+
+#define Elf_Shdr       Elf32_Shdr
+#define Elf_Sym                Elf32_Sym
+#define Elf_Ehdr       Elf32_Ehdr
+#define Elf_Addr       Elf32_Addr
+
+#ifdef CONFIG_MODULES
+/* Given an address, look for it in the exception tables. */
+const struct exception_table_entry *search_module_dbetables(unsigned long 
addr);
+#else
+/* Given an address, look for it in the exception tables. */
+static inline const struct exception_table_entry
+*search_module_dbetables(unsigned long addr)
+{
+       return NULL;
+}
+#endif
+
+#ifdef CONFIG_CPU_SCORE7
+#define MODULE_PROC_FAMILY "SCORE7"
+#else
+#error MODULE_PROC_FAMILY undefined for your processor configuration
+#endif
+
+#define MODULE_KERNEL_TYPE "32BIT "
+#define MODULE_KERNEL_SMTC ""
+
+#define MODULE_ARCH_VERMAGIC \
+       MODULE_PROC_FAMILY MODULE_KERNEL_TYPE MODULE_KERNEL_SMTC
+
+#endif /* __SCORE_MODULE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/msgbuf.h 
linux-2.6-git.new/arch/score/include/asm/msgbuf.h
--- linux-2.6-git.ori/arch/score/include/asm/msgbuf.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/msgbuf.h   2009-04-03 
17:37:37.000000000 +0800
@@ -0,0 +1,33 @@
+#ifndef __SCORE_SCORE_MSGBUF_H
+#define __SCORE_SCORE_MSGBUF_H
+
+#include <linux/types.h>
+
+/*
+ * The msqid64_ds structure for the SCORE architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - extension of time_t to 64-bit on 32-bitsystem to solve the y2038 
problem
+ * - 2 miscellaneous unsigned long values
+ */
+
+struct msqid64_ds {
+       struct ipc64_perm msg_perm;
+       __kernel_time_t msg_stime;      /* last msgsnd time */
+       u32 __unused1;
+       __kernel_time_t msg_rtime;      /* last msgrcv time */
+       u32 __unused2;
+       __kernel_time_t msg_ctime;      /* last change time */
+       u32 __unused3;
+       u32 msg_cbytes;                 /* current number of bytes on 
queue */
+       u32 msg_qnum;                   /* number of messages in queue */
+       u32 msg_qbytes;                 /* max number of bytes on queue */
+       __kernel_pid_t  msg_lspid;      /* pid of last msgsnd */
+       __kernel_pid_t  msg_lrpid;      /* last receive pid */
+       u32 __unused4;
+       u32 __unused5;
+};
+
+#endif /* __SCORE_SCORE_MSGBUF_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/mutex.h 
linux-2.6-git.new/arch/score/include/asm/mutex.h
--- linux-2.6-git.ori/arch/score/include/asm/mutex.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/mutex.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1 @@
+#include <asm-generic/mutex-dec.h>
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/page.h 
linux-2.6-git.new/arch/score/include/asm/page.h
--- linux-2.6-git.ori/arch/score/include/asm/page.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/page.h     2009-04-07 
20:26:50.000000000 +0800
@@ -0,0 +1,113 @@
+#ifndef __SCORE_PAGE_H
+#define __SCORE_PAGE_H
+
+#define PHYS_OFFSET            (0UL)
+#define PAGE_OFFSET            (0xA0000000UL)
+
+/*
+ * PAGE_SHIFT determines the page size
+ */
+#define PAGE_SHIFT     12
+#define PAGE_SIZE      (1UL << PAGE_SHIFT)
+#define PAGE_MASK      (~((1 << PAGE_SHIFT) - 1))
+
+#ifndef __ASSEMBLY__
+
+#include <linux/pfn.h>
+#include <asm/io.h>
+
+extern void build_clear_page(void);
+extern void build_copy_page(void);
+
+/*
+ * It's normally defined only for FLATMEM config but it's
+ * used in our early mem init code for all memory models.
+ * So always define it.
+ */
+#define ARCH_PFN_OFFSET                PFN_UP(PHYS_OFFSET)
+
+#define clear_page(page)       memset((void *)(page), 0, PAGE_SIZE)
+#define copy_page(to, from)    memcpy((to), (from), PAGE_SIZE)
+
+#define clear_user_page(page, vaddr, pg)       clear_page(page)
+#define copy_user_page(to, from, vaddr, pg)    copy_page(to, from)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long pte; } pte_t;
+#define pte_val(x)     ((x).pte)
+#define __pte(x)       ((pte_t) {(x)})
+typedef struct page    *pgtable_t;
+
+/*
+ * Finall the top of the hierarchy, the pgd
+ */
+typedef struct { unsigned long pgd; } pgd_t;
+#define pgd_val(x)     ((x).pgd)
+#define __pgd(x)       ((pgd_t) {(x)})
+
+/*
+ * Manipulate page protection bits
+ */
+typedef struct { unsigned long pgprot; } pgprot_t;
+#define pgprot_val(x)  ((x).pgprot)
+#define __pgprot(x)    ((pgprot_t) {(x)})
+
+/*
+ *     virt_to_phys    -       map virtual addresses to physical
+ *     @address: address to remap
+ *
+ *     The returned physical address is the physical (CPU) mapping for
+ *     the memory address given. It is only valid to use this function on
+ *     addresses directly mapped or allocated via kmalloc.
+ *
+ *     This function does not give bus mappings for DMA transfers. In
+ *     almost all conceivable cases a device driver should not be using
+ *     this function
+ */
+static inline unsigned long virt_to_phys(volatile const void *address)
+{
+       return (unsigned long)address - PAGE_OFFSET + PHYS_OFFSET;
+}
+
+/*
+ *     phys_to_virt    -       map physical address to virtual
+ *     @address: address to remap
+ *
+ *     The returned virtual address is a current CPU mapping for
+ *     the memory address given. It is only valid to use this function on
+ *     addresses that have a kernel mapping
+ *
+ *     This function does not handle bus mappings for DMA transfers. In
+ *     almost all conceivable cases a device driver should not be using
+ *     this function
+ */
+static inline void *phys_to_virt(unsigned long address)
+{
+       return (void *)(address + PAGE_OFFSET - PHYS_OFFSET);
+}
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * __pa()/__va() should be used only during mem init.
+ */
+
+#define __pa(x)                ((unsigned long) (x) - PAGE_OFFSET + 
PHYS_OFFSET)
+#define __va(x)                ((void *)((unsigned long) (x) + 
PAGE_OFFSET - PHYS_OFFSET))
+#define __pa_symbol(x) __pa(RELOC_HIDE((unsigned long) (x), 0))
+
+#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
+#define pfn_valid(pfn)         ((pfn) >= ARCH_PFN_OFFSET && (pfn) < 
max_mapnr)
+
+#define virt_to_page(kaddr)    pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
+#define virt_addr_valid(kaddr) pfn_valid(PFN_DOWN(virt_to_phys(kaddr)))
+
+#define VM_DATA_DEFAULT_FLAGS  (VM_READ | VM_WRITE | VM_EXEC | \
+                                VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/page.h>
+
+#define HIGHMEM_START  (0x20000000)
+#endif /* __SCORE_PAGE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/param.h 
linux-2.6-git.new/arch/score/include/asm/param.h
--- linux-2.6-git.ori/arch/score/include/asm/param.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/param.h    2009-04-03 
17:02:30.000000000 +0800
@@ -0,0 +1,22 @@
+#ifndef __SCORE_PARAM_H
+#define __SCORE_PARAM_H
+
+#ifdef __KERNEL__
+# define HZ            CONFIG_HZ       /* Internal kernel timer frequency 
*/
+# define USER_HZ       100             /* .. some user interfaces are in 
"ticks" */
+# define CLOCKS_PER_SEC        (USER_HZ)       /* like times() */
+#endif
+
+#ifndef HZ
+#define HZ 100
+#endif
+
+#define EXEC_PAGESIZE  65536
+
+#ifndef NOGROUP
+#define NOGROUP                (-1)
+#endif
+
+#define MAXHOSTNAMELEN 64      /* max length of hostname */
+
+#endif /* __SCORE_PARAM_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pci.h 
linux-2.6-git.new/arch/score/include/asm/pci.h
--- linux-2.6-git.ori/arch/score/include/asm/pci.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pci.h      2009-04-03 
17:02:37.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_PCI_H
+#define __SCORE_PCI_H
+
+#include <linux/mm.h>
+
+#endif /* __SCORE_PCI_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/percpu.h 
linux-2.6-git.new/arch/score/include/asm/percpu.h
--- linux-2.6-git.ori/arch/score/include/asm/percpu.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/percpu.h   2009-04-03 
17:02:46.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_PERCPU_H
+#define __SCORE_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* __SCORE_PERCPU_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pgalloc.h 
linux-2.6-git.new/arch/score/include/asm/pgalloc.h
--- linux-2.6-git.ori/arch/score/include/asm/pgalloc.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pgalloc.h  2009-04-07 
20:27:26.000000000 +0800
@@ -0,0 +1,96 @@
+#ifndef __SCORE_PGALLOC_H
+#define __SCORE_PGALLOC_H
+
+#include <linux/mm.h>
+#include <linux/sched.h>
+
+extern void pagetable_init(void);
+
+static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
+       pte_t *pte)
+{
+       set_pmd(pmd, __pmd((unsigned long)pte));
+}
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+       pgtable_t pte)
+{
+       set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
+}
+
+#define pmd_pgtable(pmd)       pmd_page(pmd)
+
+/*
+ * Initialize a new pmd table with invalid pointers.
+ */
+extern void pmd_init(unsigned long page, unsigned long pagetable);
+
+
+/*
+ * Initialize a new pgd / pmd table with invalid pointers.
+ */
+extern void pgd_init(unsigned long page);
+
+static inline pgd_t *pgd_alloc(struct mm_struct *mm)
+{
+       pgd_t *ret, *init;
+
+       ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
+       if (ret) {
+               init = pgd_offset(&init_mm, 0UL);
+               pgd_init((unsigned long)ret);
+               memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
+                      (PTRS_PER_PGD - USER_PTRS_PER_PGD) * 
sizeof(pgd_t));
+       }
+
+       return ret;
+}
+
+static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
+{
+       free_pages((unsigned long)pgd, PGD_ORDER);
+}
+
+static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
+       unsigned long address)
+{
+       pte_t *pte;
+
+       pte = (pte_t *) 
__get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, PTE_ORDER);
+
+       return pte;
+}
+
+static inline struct page *pte_alloc_one(struct mm_struct *mm,
+       unsigned long address)
+{
+       struct page *pte;
+
+       pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
+       if (pte) {
+               clear_highpage(pte);
+               pgtable_page_ctor(pte);
+       }
+       return pte;
+}
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+       free_pages((unsigned long)pte, PTE_ORDER);
+}
+
+static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
+{
+       pgtable_page_dtor(pte);
+       __free_pages(pte, PTE_ORDER);
+}
+
+#define __pte_free_tlb(tlb, pte)                       \
+do {                                                   \
+       pgtable_page_dtor(pte);                         \
+       tlb_remove_page((tlb), pte);                    \
+} while (0)
+
+#define check_pgt_cache()              do {} while (0)
+
+#endif /* __SCORE_PGALLOC_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pgtable-32.h 
linux-2.6-git.new/arch/score/include/asm/pgtable-32.h
--- linux-2.6-git.ori/arch/score/include/asm/pgtable-32.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pgtable-32.h       2009-04-08 
11:12:17.000000000 +0800
@@ -0,0 +1,114 @@
+#ifndef __SCORE_PGTABLE_32_H
+#define __SCORE_PGTABLE_32_H
+
+#include <linux/const.h>
+#include <asm-generic/pgtable-nopmd.h>
+#include <asm/fixmap.h>
+
+/* PGDIR_SHIFT determines what a third-level page table entry can map */
+#define PGDIR_SHIFT    22
+#define PGDIR_SIZE     (_AC(1, UL) << PGDIR_SHIFT)
+#define PGDIR_MASK     (~(PGDIR_SIZE - 1))
+
+/*
+ * Entries per page directory level: we use two-level, so
+ * we don't really have any PUD/PMD directory physically.
+ */
+#define PGD_ORDER      0
+#define PTE_ORDER      0
+
+#define PTRS_PER_PGD   1024
+#define PTRS_PER_PTE   1024
+
+#define USER_PTRS_PER_PGD      (0x80000000UL/PGDIR_SIZE)
+#define FIRST_USER_ADDRESS     0
+
+#define VMALLOC_START          (0xc0000000UL)
+
+#define PKMAP_BASE             (0xfd000000UL)
+
+#define VMALLOC_END            (FIXADDR_START - 2*PAGE_SIZE)
+
+#define pte_ERROR(e) \
+       printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
+#define pgd_ERROR(e) \
+       printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
+
+extern void load_pgd(unsigned long pg_dir);
+extern pte_t invalid_pte_table[PAGE_SIZE/sizeof(pte_t)];
+
+/*
+ * Empty pgd/pmd entries point to the invalid_pte_table.
+ */
+static inline int pmd_none(pmd_t pmd)
+{
+       return pmd_val(pmd) == (unsigned long) invalid_pte_table;
+}
+
+#define pmd_bad(pmd)           (pmd_val(pmd) & ~PAGE_MASK)
+
+static inline int pmd_present(pmd_t pmd)
+{
+       return pmd_val(pmd) != (unsigned long) invalid_pte_table;
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+       pmd_val(*pmdp) = ((unsigned long) invalid_pte_table);
+}
+
+#define pte_page(x)            pfn_to_page(pte_pfn(x))
+#define pte_pfn(x)             ((unsigned long)((x).pte >> PAGE_SHIFT))
+#define pfn_pte(pfn, prot)     __pte(((unsigned long long)(pfn) << 
PAGE_SHIFT) | pgprot_val(prot))
+
+#define __pgd_offset(address)  pgd_index(address)
+#define __pud_offset(address)  (((address) >> PUD_SHIFT) & 
(PTRS_PER_PUD-1))
+#define __pmd_offset(address)  (((address) >> PMD_SHIFT) & 
(PTRS_PER_PMD-1))
+
+/* to find an entry in a kernel page-table-directory */
+#define pgd_offset_k(address)  pgd_offset(&init_mm, address)
+#define pgd_index(address)     (((address) >> PGDIR_SHIFT) & 
(PTRS_PER_PGD-1))
+
+/* to find an entry in a page-table-directory */
+#define pgd_offset(mm, addr)   ((mm)->pgd + pgd_index(addr))
+
+/* Find an entry in the third-level page table.. */
+#define __pte_offset(address)                                          \
+       (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset(dir, address)                                       \
+       ((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+#define pte_offset_kernel(dir, address) \
+       ((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
+
+#define pte_offset_map(dir, address)                                   \
+       ((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_offset_map_nested(dir, address)                            \
+       ((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
+#define pte_unmap(pte) ((void)(pte))
+#define pte_unmap_nested(pte) ((void)(pte))
+
+
+/*
+ * Swap entries must have VALID and GLOBAL bits cleared.
+ * _PAGE_PRESENT is bit 9
+ * _PAGE_FILE is bit 10
+ * These bits must be 0.
+ */
+#define __swp_type(x)          ((x).val & 0x1f)
+#define __swp_offset(x)        ((x).val >> 11)
+#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 
11)})
+
+/*
+ * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken, split up 30 bits of 
offset into this range:
+ */
+#define PTE_FILE_MAX_BITS      30
+
+#define pte_to_pgoff(_pte)     (((_pte).pte & 0x1ff) | (((_pte).pte >> 
11) << 9))
+
+#define pgoff_to_pte(off)      ((pte_t) {((off) & 0x1ff) | \
+                                (((off) >> 9) << 11) | _PAGE_FILE})
+
+#define __pte_to_swp_entry(pte)        ((swp_entry_t) { pte_val(pte)})
+#define __swp_entry_to_pte(x)  ((pte_t) {(x).val})
+
+#endif /* __SCORE_PGTABLE_32_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pgtable-bits.h 
linux-2.6-git.new/arch/score/include/asm/pgtable-bits.h
--- linux-2.6-git.ori/arch/score/include/asm/pgtable-bits.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pgtable-bits.h     2009-04-03 
17:03:09.000000000 +0800
@@ -0,0 +1,28 @@
+#ifndef __SCORE_PGTABLE_BITS_H
+#define __SCORE_PGTABLE_BITS_H
+
+#define _PAGE_ACCESSED                 (1<<5)  /* implemented in software 
*/
+#define _PAGE_READ                     (1<<6)  /* implemented in software 
*/
+#define _PAGE_WRITE                    (1<<7)  /* implemented in software 
*/
+#define _PAGE_PRESENT                  (1<<9)  /* implemented in software 
*/
+#define _PAGE_MODIFIED                 (1<<10) /* implemented in software 
*/
+#define _PAGE_FILE                     (1<<10)
+
+#define _PAGE_GLOBAL                   (1<<0)
+#define _PAGE_VALID                    (1<<1)
+#define _PAGE_SILENT_READ              (1<<1)  /* synonym */
+#define _PAGE_DIRTY                    (1<<2)  /* Write bit */
+#define _PAGE_SILENT_WRITE             (1<<2)
+#define _PAGE_CACHE                    (1<<3)  /* cache */
+#define _CACHE_MASK                    (1<<3)
+#define _PAGE_BUFFERABLE               (1<<4)  /*Fallow Spec. */
+#define _PAGE_BIG                      (1<<8)  /* Big page (64KB) */
+
+#define _CACHE_UNCACHED                        (1<<11) /*implemented in 
software*/
+
+#define __READABLE     (_PAGE_READ | _PAGE_SILENT_READ | _PAGE_ACCESSED)
+#define __WRITEABLE    (_PAGE_WRITE | _PAGE_SILENT_WRITE | 
_PAGE_MODIFIED)
+#define _PAGE_CHG_MASK (PAGE_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED | 
_PAGE_CACHE)
+#define PAGE_CACHABLE_DEFAULT  _PAGE_CACHE
+
+#endif /* __SCORE_PGTABLE_BITS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/pgtable.h 
linux-2.6-git.new/arch/score/include/asm/pgtable.h
--- linux-2.6-git.ori/arch/score/include/asm/pgtable.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/pgtable.h  2009-04-07 
20:30:35.000000000 +0800
@@ -0,0 +1,208 @@
+#ifndef __SCORE_PGTABLE_H
+#define __SCORE_PGTABLE_H
+
+#include <asm/pgtable-bits.h>
+#include <asm/pgtable-32.h>
+#include <asm/io.h>
+
+struct mm_struct;
+struct vm_area_struct;
+
+#define PAGE_NONE      __pgprot(_PAGE_PRESENT | _PAGE_CACHE)
+#define PAGE_SHARED    __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE 
| \
+                               _PAGE_CACHE)
+#define PAGE_COPY      __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_CACHE)
+#define PAGE_READONLY  __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_CACHE)
+#define PAGE_KERNEL    __pgprot(_PAGE_PRESENT | __READABLE | __WRITEABLE 
| \
+                                _PAGE_GLOBAL | _PAGE_CACHE)
+#define PAGE_KERNEL_UNCACHED __pgprot(_PAGE_PRESENT | __READABLE | \
+                       __WRITEABLE | _PAGE_GLOBAL & ~_PAGE_CACHE)
+
+/*
+ * Dummy values to fill the table in mmap.c
+ * The real values will be generated at runtime
+ */
+#define __P000 __pgprot(0)
+#define __P001 __pgprot(0)
+#define __P010 __pgprot(0)
+#define __P011 __pgprot(0)
+#define __P100 __pgprot(0)
+#define __P101 __pgprot(0)
+#define __P110 __pgprot(0)
+#define __P111 __pgprot(0)
+
+#define __S000 __pgprot(0)
+#define __S001 __pgprot(0)
+#define __S010 __pgprot(0)
+#define __S011 __pgprot(0)
+#define __S100 __pgprot(0)
+#define __S101 __pgprot(0)
+#define __S110 __pgprot(0)
+#define __S111 __pgprot(0)
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero; used
+ * for zero-mapped memory areas etc..
+ */
+
+extern unsigned long empty_zero_page;
+extern unsigned long zero_page_mask;
+extern unsigned long pgd_current;
+
+#define ZERO_PAGE(vaddr) \
+       (virt_to_page((void *)(empty_zero_page + \
+        (((unsigned long)(vaddr)) & zero_page_mask))))
+
+extern void paging_init(void);
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+#define pmd_phys(pmd)          virt_to_phys((void *)pmd_val(pmd))
+#define pmd_page(pmd)          (pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
+#define pmd_page_vaddr(pmd)    pmd_val(pmd)
+
+#define pte_none(pte)          (!(pte_val(pte) & ~_PAGE_GLOBAL))
+#define pte_present(pte)       (pte_val(pte) & _PAGE_PRESENT)
+
+/*
+ * Certain architectures need to do special things when pte's
+ * within a page table are directly modified.  Thus, the following
+ * hook is made available.
+ */
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+       *ptep = pteval;
+}
+
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr, 
pte_t *ptep)
+{
+       set_pte_at(mm, addr, ptep, __pte(0));
+}
+
+/*
+ * (pmds are folded into puds so this doesn't get actually called,
+ * but the define is needed for a generic inline function.)
+ */
+#define set_pmd(pmdptr, pmdval) do { *(pmdptr) = (pmdval); } while (0)
+
+#define PGD_T_LOG2     (__builtin_ffs(sizeof(pgd_t)) - 1)
+#define PMD_T_LOG2     (__builtin_ffs(sizeof(pmd_t)) - 1)
+#define PTE_T_LOG2     (__builtin_ffs(sizeof(pte_t)) - 1)
+
+/*
+ * We used to declare this array with size but gcc 3.3 and older are not 
able
+ * to find that this expression is a constant, so the size is dropped.
+ */
+extern pgd_t swapper_pg_dir[];
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+static inline int pte_write(pte_t pte) { return pte_val(pte) & 
_PAGE_WRITE; }
+static inline int pte_dirty(pte_t pte) { return pte_val(pte) & 
_PAGE_MODIFIED; }
+static inline int pte_young(pte_t pte) { return pte_val(pte) & 
_PAGE_ACCESSED; }
+static inline int pte_file(pte_t pte)  { return pte_val(pte) & 
_PAGE_FILE; }
+
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+       pte_val(pte) &= ~(_PAGE_WRITE | _PAGE_SILENT_WRITE);
+       return pte;
+}
+
+static inline pte_t pte_mkclean(pte_t pte)
+{
+       pte_val(pte) &= ~(_PAGE_MODIFIED|_PAGE_SILENT_WRITE);
+       return pte;
+}
+
+static inline pte_t pte_mkold(pte_t pte)
+{
+       pte_val(pte) &= ~(_PAGE_ACCESSED|_PAGE_SILENT_READ);
+       return pte;
+}
+
+static inline pte_t pte_mkwrite(pte_t pte)
+{
+       pte_val(pte) |= _PAGE_WRITE;
+       if (pte_val(pte) & _PAGE_MODIFIED)
+               pte_val(pte) |= _PAGE_SILENT_WRITE;
+       return pte;
+}
+
+static inline pte_t pte_mkdirty(pte_t pte)
+{
+       pte_val(pte) |= _PAGE_MODIFIED;
+       if (pte_val(pte) & _PAGE_WRITE)
+               pte_val(pte) |= _PAGE_SILENT_WRITE;
+       return pte;
+}
+
+static inline pte_t pte_mkyoung(pte_t pte)
+{
+       pte_val(pte) |= _PAGE_ACCESSED;
+       if (pte_val(pte) & _PAGE_READ)
+               pte_val(pte) |= _PAGE_SILENT_READ;
+       return pte;
+}
+
+static inline int pte_special(pte_t pte)       { return 0; }
+static inline pte_t pte_mkspecial(pte_t pte)   { return pte; }
+
+/*
+ * Macro to make mark a page protection value as "uncacheable".  Note
+ * that "protection" is really a misnomer here as the protection value
+ * contains the memory attribute bits, dirty bits, and various other
+ * bits as well.
+ */
+#define pgprot_noncached pgprot_noncached
+
+static inline pgprot_t pgprot_noncached(pgprot_t _prot)
+{
+       unsigned long prot = pgprot_val(_prot);
+
+       prot = (prot & ~_CACHE_MASK);
+
+       return __pgprot(prot);
+}
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+#define mk_pte(page, pgprot)   pfn_pte(page_to_pfn(page), (pgprot))
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+       return __pte((pte_val(pte) & _PAGE_CHG_MASK) | 
pgprot_val(newprot));
+}
+
+extern void __update_tlb(struct vm_area_struct *vma, unsigned long 
address,
+       pte_t pte);
+extern void __update_cache(struct vm_area_struct *vma, unsigned long 
address,
+       pte_t pte);
+
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+       unsigned long address, pte_t pte)
+{
+       __update_tlb(vma, address, pte);
+       __update_cache(vma, address, pte);
+}
+
+#define kern_addr_valid(addr)  (1)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)                \
+               remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+#include <asm-generic/pgtable.h>
+
+/*
+ * No page table caches to initialise
+ */
+#define pgtable_cache_init()   do {} while (0)
+
+#endif /* __SCORE_PGTABLE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/poll.h 
linux-2.6-git.new/arch/score/include/asm/poll.h
--- linux-2.6-git.ori/arch/score/include/asm/poll.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/poll.h     2009-04-03 
17:03:25.000000000 +0800
@@ -0,0 +1,9 @@
+#ifndef __SCORE_POLL_H
+#define __SCORE_POLL_H
+
+#define POLLWRNORM     POLLOUT
+#define POLLWRBAND     0x0100
+
+#include <asm-generic/poll.h>
+
+#endif /* __SCORE_POLL_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/posix_types.h 
linux-2.6-git.new/arch/score/include/asm/posix_types.h
--- linux-2.6-git.ori/arch/score/include/asm/posix_types.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/posix_types.h      2009-04-07 
21:43:55.000000000 +0800
@@ -0,0 +1,117 @@
+#ifndef __SCORE_POSIX_TYPES_H
+#define __SCORE_POSIX_TYPES_H
+
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.  Also, we cannot
+ * assume GCC is being used.
+ */
+
+typedef unsigned long  __kernel_ino_t;
+typedef unsigned int   __kernel_mode_t;
+typedef unsigned long  __kernel_nlink_t;
+typedef long           __kernel_off_t;
+typedef int            __kernel_pid_t;
+typedef int            __kernel_ipc_pid_t;
+typedef unsigned int   __kernel_uid_t;
+typedef unsigned int   __kernel_gid_t;
+typedef unsigned int   __kernel_size_t;
+typedef int            __kernel_ssize_t;
+typedef int            __kernel_ptrdiff_t;
+typedef long           __kernel_time_t;
+typedef long           __kernel_suseconds_t;
+typedef long           __kernel_clock_t;
+typedef int            __kernel_timer_t;
+typedef int            __kernel_clockid_t;
+typedef long           __kernel_daddr_t;
+typedef char           *__kernel_caddr_t;
+
+typedef unsigned short __kernel_uid16_t;
+typedef unsigned short __kernel_gid16_t;
+typedef unsigned int   __kernel_uid32_t;
+typedef unsigned int   __kernel_gid32_t;
+typedef __kernel_uid_t __kernel_old_uid_t;
+typedef __kernel_gid_t __kernel_old_gid_t;
+typedef unsigned int   __kernel_old_dev_t;
+
+#ifdef __GNUC__
+typedef long long      __kernel_loff_t;
+#endif
+
+typedef struct {
+       long    val[2];
+} __kernel_fsid_t;
+
+#if defined(__KERNEL__)
+
+#undef __FD_SET
+static inline void __FD_SET(unsigned long __fd, __kernel_fd_set 
*__fdsetp)
+{
+       unsigned long __tmp = __fd / __NFDBITS;
+       unsigned long __rem = __fd % __NFDBITS;
+       __fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
+}
+
+#undef __FD_CLR
+static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set 
*__fdsetp)
+{
+       unsigned long __tmp = __fd / __NFDBITS;
+       unsigned long __rem = __fd % __NFDBITS;
+       __fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
+}
+
+#undef __FD_ISSET
+static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set 
*__p)
+{
+       unsigned long __tmp = __fd / __NFDBITS;
+       unsigned long __rem = __fd % __NFDBITS;
+       return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
+}
+
+/*
+ * This will unroll the loop for the normal constant case (8 ints,
+ * for a 256-bit fd_set)
+ */
+#undef __FD_ZERO
+static inline void __FD_ZERO(__kernel_fd_set *__p)
+{
+       unsigned long *__tmp = __p->fds_bits;
+       int __i;
+
+       if (__builtin_constant_p(__FDSET_LONGS)) {
+               switch (__FDSET_LONGS) {
+               case 16:
+                       __tmp[0] = 0; __tmp[1] = 0;
+                       __tmp[2] = 0; __tmp[3] = 0;
+                       __tmp[4] = 0; __tmp[5] = 0;
+                       __tmp[6] = 0; __tmp[7] = 0;
+                       __tmp[8] = 0; __tmp[9] = 0;
+                       __tmp[10] = 0; __tmp[11] = 0;
+                       __tmp[12] = 0; __tmp[13] = 0;
+                       __tmp[14] = 0; __tmp[15] = 0;
+                       return;
+
+               case 8:
+                       __tmp[0] = 0; __tmp[1] = 0;
+                       __tmp[2] = 0; __tmp[3] = 0;
+                       __tmp[4] = 0; __tmp[5] = 0;
+                       __tmp[6] = 0; __tmp[7] = 0;
+                       return;
+
+               case 4:
+                       __tmp[0] = 0; __tmp[1] = 0;
+                       __tmp[2] = 0; __tmp[3] = 0;
+                       return;
+               }
+       }
+       __i = __FDSET_LONGS;
+       while (__i) {
+               __i--;
+               *__tmp = 0;
+               __tmp++;
+       }
+}
+
+#endif /* defined(__KERNEL__) */
+
+#endif /* __SCORE_POSIX_TYPES_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/processor.h 
linux-2.6-git.new/arch/score/include/asm/processor.h
--- linux-2.6-git.ori/arch/score/include/asm/processor.h        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/processor.h        2009-04-08 
11:13:35.000000000 +0800
@@ -0,0 +1,119 @@
+#ifndef __SCORE_PROCESSOR_H
+#define __SCORE_PROCESSOR_H
+
+#include <linux/cpumask.h>
+#include <linux/threads.h>
+
+#define SZREG  4
+
+/*
+ * Return current * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+/*
+ * System setup and hardware flags..
+ */
+extern void (*cpu_wait)(void);
+
+/*
+ * User space process size: 2GB. This is hardcoded into a few places,
+ * so don't change it unless you know what you are doing.
+ */
+#define TASK_SIZE      0x7fff8000UL
+#define STACK_TOP      TASK_SIZE
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE     ((TASK_SIZE / 3) & ~(PAGE_SIZE))
+
+#ifdef __KERNEL__
+#define STACK_TOP_MAX  TASK_SIZE
+#endif
+
+#define INIT_CPUMASK {{0, } }
+
+typedef struct {
+       unsigned long seg;
+} mm_segment_t;
+
+#define ARCH_MIN_TASKALIGN     8
+
+/*
+ * If you change thread_struct remember to change the #defines below too!
+ */
+struct thread_struct {
+       unsigned long reg0, reg2, reg3;
+       unsigned long reg12, reg13, reg14, reg15, reg16;
+       unsigned long reg17, reg18, reg19, reg20, reg21;
+
+       unsigned long cp0_psr;
+
+       unsigned long cp0_ema;          /* Last user fault */
+       unsigned long cp0_badvaddr;     /* Last user fault */
+       unsigned long cp0_baduaddr;     /* Last kernel fault accessing 
USEG */
+       unsigned long error_code;
+       unsigned long trap_no;
+
+       unsigned long mflags;
+       unsigned long reg29;
+
+       unsigned long single_step;
+       unsigned long ss_nextcnt;
+
+       unsigned long insn1_type;
+       unsigned long addr1;
+       unsigned long insn1;
+
+       unsigned long insn2_type;
+       unsigned long addr2;
+       unsigned long insn2;
+
+       mm_segment_t current_ds;
+};
+
+#define INIT_THREAD {                                          \
+       .reg0                   = 0,                            \
+       .reg2                   = 0,                            \
+       .reg3                   = 0,                            \
+       .reg12                  = 0,                            \
+       .reg13                  = 0,                            \
+       .reg14                  = 0,                            \
+       .reg15                  = 0,                            \
+       .reg16                  = 0,                            \
+       .reg17                  = 0,                            \
+       .reg18                  = 0,                            \
+       .reg19                  = 0,                            \
+       .reg20                  = 0,                            \
+       .reg21                  = 0,                            \
+       /*                                                      \
+        * Saved cp0 stuff                                      \
+        */                                                     \
+       .cp0_psr                = 0,                            \
+       .error_code             = 0,                            \
+       .trap_no                = 0,                            \
+}
+
+struct task_struct;
+
+#define release_thread(thread) do {} while (0)
+#define prepare_to_copy(tsk)   do {} while (0)
+
+extern long kernel_thread(int (*fn)(void *), void *arg, unsigned long 
flags);
+extern unsigned long thread_saved_pc(struct task_struct *tsk);
+extern void start_thread(struct pt_regs *regs, unsigned long pc, unsigned 
long sp);
+extern unsigned long get_wchan(struct task_struct *p);
+
+#define __KSTK_TOS(tsk)                ((unsigned 
long)task_stack_page(tsk) + THREAD_SIZE - 32)
+#define task_pt_regs(tsk)      ((struct pt_regs *)__KSTK_TOS(tsk) - 1)
+
+#define KSTK_EIP(tsk)          (task_pt_regs(tsk)->cp0_epc)
+#define KSTK_ESP(tsk)          (task_pt_regs(tsk)->regs[29])
+
+#define cpu_relax()            barrier()
+#define return_address()                                       \
+({__asm__ __volatile__("" : : : "r3"); __builtin_return_address(0); })
+
+#endif /* __SCORE_PROCESSOR_H */

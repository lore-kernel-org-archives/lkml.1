Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbZCPWCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbZCPWCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZCPWCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:02:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:38341 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbZCPWCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:02:05 -0400
Message-ID: <49BECBF4.1000508@kernel.org>
Date: Mon, 16 Mar 2009 15:00:20 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.29_rc8] BIOS Bug: CPU MTRRs don't cover all of memory,
 	losing 0MB of RAM.
References: <49BE58BA.1000907@pardus.org.tr> <86802c440903161121s3ba18abaiaa3ccf6847e0eafe@mail.gmail.com> <49BEB3C9.8070705@pardus.org.tr>
In-Reply-To: <49BEB3C9.8070705@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ozan Çağlayan wrote:
> Yinghai Lu wrote:
> 
>> can you check tip/master?
>>
>> http://people.redhat.com/mingo/tip.git/readme.txt
>>
>> and post boot log.
> 
> I compiled tip/master with the same configuration. Here's the head of the dmesg:
> (BTW, I'm not getting this backtrace with 2.6.25.20. I know its rather old but maybe
> it will help)
> 
> ---
> 
> Initializing cgroup subsys cpuset
> Linux version 2.6.29-rc8-tip-tip (root@stinson) (gcc version 4.3.2 (Pardus Linux) ) #1 SMP Mon Mar 16 21:26:14 EET 2009
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000cfd43000 (usable)
>  BIOS-e820: 00000000cfd43000 - 00000000cfd4c000 (ACPI data)
>  BIOS-e820: 00000000cfd4c000 - 00000000cfd4d000 (usable)
>  BIOS-e820: 00000000cfd4d000 - 00000000d0000000 (reserved)
>  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
>  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 000000082ffff000 (usable)
> DMI 2.5 present.
> last_pfn = 0x82ffff max_arch_pfn = 0x1000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 0000000000 mask 0000000000 write-back
>   1 base 00CFF00000 mask FFFFF00000 uncachable
>   2 base 00D0000000 mask FFF0000000 uncachable
>   3 base 00E0000000 mask FFE0000000 uncachable
>   4 base 0000004000 mask FFFFFFF000 uncachable
>   5 base 0000005000 mask FFFFFFF000 uncachable
>   6 base 0000006000 mask FFFFFFF000 uncachable
>   7 base 0000007000 mask FFFFFFF000 uncachable
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>   get_mtrr: cpu0 reg00 base=0000000000 size=0010000000 write-back
>   get_mtrr: cpu0 reg01 base=00000cff00 size=0000000100 uncachable
>   get_mtrr: cpu0 reg02 base=00000d0000 size=0000010000 uncachable
>   get_mtrr: cpu0 reg03 base=00000e0000 size=0000020000 uncachable
>   get_mtrr: cpu0 reg04 base=0000000004 size=0000000001 uncachable
>   get_mtrr: cpu0 reg05 base=0000000005 size=0000000001 uncachable
>   get_mtrr: cpu0 reg06 base=0000000006 size=0000000001 uncachable
>   get_mtrr: cpu0 reg07 base=0000000007 size=0000000001 uncachable
> e820 update range: 0000000000004000 - 0000000000008000 (usable) ==> (reserved)
> e820 update range: 00000000cff00000 - 0000000100000000 (usable) ==> (reserved)
> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 0MB of RAM.
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/cpu/mtrr/cleanup.c:1079 mtrr_trim_uncached_memory+0x2a9/0x2cd()
> Hardware name: ProLiant DL580 G5
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.29-rc8-tip-tip #1
> Call Trace:
>  [<c0133871>] warn_slowpath+0x71/0xa8
>  [<c011e23a>] ? default_spin_lock_flags+0x9/0xb
>  [<c03aad3c>] ? _spin_unlock_irqrestore+0x17/0x1b
>  [<c011e23a>] ? default_spin_lock_flags+0x9/0xb
>  [<c03aad3c>] ? _spin_unlock_irqrestore+0x17/0x1b
>  [<c0133edd>] ? release_console_sem+0x176/0x1a3
>  [<c0134358>] ? vprintk+0x276/0x299
>  [<c03a87cc>] ? printk+0xf/0x13
>  [<c054aece>] mtrr_trim_uncached_memory+0x2a9/0x2cd
>  [<c0545cf5>] setup_arch+0x43c/0x9ab
>  [<c0133edd>] ? release_console_sem+0x176/0x1a3
>  [<c0134358>] ? vprintk+0x276/0x299
>  [<c0134358>] ? vprintk+0x276/0x299
>  [<c0548759>] ? __reserve_early+0xe4/0xf8
>  [<c03a87cc>] ? printk+0xf/0x13
>  [<c0543580>] start_kernel+0x77/0x323
>  [<c0543085>] __init_begin+0x85/0x8d
> ---[ end trace 4eaa2a86a8e2da22 ]---
> update e820 for mtrr
> 


please check

[PATCH] x86: workaround system with strange var MTRR

Impact: don't trim e820 according to wrong mtrr

Ozan report his branded server emit strange warning.
it turns out MTRR is some wrong.

Ignore those strange range, and don't trim e820. just emit one warning about
BIOS

Reported-by: Ozan Çağlayan <ozan_at_pardus.org.tr>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/cleanup.c |   13 ++++++++++++-
 arch/x86/kernel/cpu/mtrr/main.c    |   16 ++++++++--------
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    1 +
 3 files changed, 21 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -186,9 +186,20 @@ x86_get_mtrr_mem_range(struct res_range
 		    type != MTRR_TYPE_WRPROT)
 			continue;
 		size = range_state[i].size_pfn;
+		base = range_state[i].base_pfn;
+		if (base < (1<<(20-PAGE_SHIFT)) && mtrr_state.have_fixed &&
+		    (mtrr_state.enabled & 1)) {
+			/* var MTRR contain UC below 1M ?  skip it*/
+			printk(KERN_WARNING "WARNING: BIOS bug: VAR MTRR "
+				"contains strange UC entry under 1M, check "
+				"with your system vendor!\n");
+			if (base + size < (1<<(20-PAGE_SHIFT)))
+				continue;
+			size -= (1<<(20-PAGE_SHIFT)) - base;
+			base = 1<<(20-PAGE_SHIFT);
+		}
 		if (!size)
 			continue;
-		base = range_state[i].base_pfn;
 		subtract_range(range, base, base + size - 1);
 	}
 	if (extra_remove_size)
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -79,6 +79,7 @@ extern struct mtrr_ops * mtrr_if;
 
 extern unsigned int num_var_ranges;
 extern u64 mtrr_tom2;
+extern struct mtrr_state_type mtrr_state;
 
 void mtrr_state_warn(void);
 const char *mtrr_attrib_to_str(int x);
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -574,7 +574,7 @@ struct mtrr_value {
 	unsigned long	lsize;
 };
 
-static struct mtrr_value mtrr_state[MTRR_MAX_VAR_RANGES];
+static struct mtrr_value mtrr_value[MTRR_MAX_VAR_RANGES];
 
 static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
 {
@@ -582,9 +582,9 @@ static int mtrr_save(struct sys_device *
 
 	for (i = 0; i < num_var_ranges; i++) {
 		mtrr_if->get(i,
-			     &mtrr_state[i].lbase,
-			     &mtrr_state[i].lsize,
-			     &mtrr_state[i].ltype);
+			     &mtrr_value[i].lbase,
+			     &mtrr_value[i].lsize,
+			     &mtrr_value[i].ltype);
 	}
 	return 0;
 }
@@ -594,11 +594,11 @@ static int mtrr_restore(struct sys_devic
 	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
-		if (mtrr_state[i].lsize) 
+		if (mtrr_value[i].lsize)
 			set_mtrr(i,
-				 mtrr_state[i].lbase,
-				 mtrr_state[i].lsize,
-				 mtrr_state[i].ltype);
+				 mtrr_value[i].lbase,
+				 mtrr_value[i].lsize,
+				 mtrr_value[i].ltype);
 	}
 	return 0;
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYDOXWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYDOXWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbYDOXWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:22:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53307 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754145AbYDOXWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:22:15 -0400
Date: Tue, 15 Apr 2008 16:22:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <Pine.LNX.4.64.0804151517530.4038@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0804151609510.5018@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi>
 <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
 <20080415211359.GA1531@elte.hu> <20080415212430.GA5467@elte.hu>
 <Pine.LNX.4.64.0804151437300.3252@schroedinger.engr.sgi.com>
 <20080415215504.GA9066@elte.hu> <Pine.LNX.4.64.0804151455520.4038@schroedinger.engr.sgi.com>
 <20080415221314.GA12094@elte.hu> <Pine.LNX.4.64.0804151517530.4038@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... If one enables CONFIG_X86_PAE (even with no highmem) then 
everything is fine. For PAE to be enabled some other things also fall by 
the wayside. Diff to your failing config follows. Will try to minimize 
the diff even further:

--- config-Thu_Apr_10_10_41_16_CEST_2008.bad.rc9	2008-04-15 06:02:13.000000000 +0000
+++ .config	2008-04-15 23:15:53.000000000 +0000
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.25-rc9
-# Tue Apr 15 07:37:33 2008
+# Tue Apr 15 23:15:53 2008
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -169,11 +169,11 @@
 # CONFIG_X86_VSMP is not set
 # CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
 CONFIG_PARAVIRT_GUEST=y
+# CONFIG_XEN is not set
 CONFIG_VMI=y
-# CONFIG_LGUEST_GUEST is not set
 CONFIG_PARAVIRT=y
 # CONFIG_M386 is not set
-CONFIG_M486=y
+# CONFIG_M486 is not set
 # CONFIG_M586 is not set
 # CONFIG_M586TSC is not set
 # CONFIG_M586MMX is not set
@@ -196,20 +196,23 @@
 # CONFIG_MVIAC3_2 is not set
 # CONFIG_MVIAC7 is not set
 # CONFIG_MPSC is not set
-# CONFIG_MCORE2 is not set
+CONFIG_MCORE2=y
 # CONFIG_GENERIC_CPU is not set
 # CONFIG_X86_GENERIC is not set
 CONFIG_X86_CMPXCHG=y
-CONFIG_X86_L1_CACHE_SHIFT=4
+CONFIG_X86_L1_CACHE_SHIFT=6
 CONFIG_X86_XADD=y
-# CONFIG_X86_PPRO_FENCE is not set
-CONFIG_X86_F00F_BUG=y
 CONFIG_X86_WP_WORKS_OK=y
 CONFIG_X86_INVLPG=y
 CONFIG_X86_BSWAP=y
 CONFIG_X86_POPAD_OK=y
-CONFIG_X86_ALIGNMENT_16=y
-CONFIG_X86_MINIMUM_CPU_FAMILY=4
+CONFIG_X86_GOOD_APIC=y
+CONFIG_X86_INTEL_USERCOPY=y
+CONFIG_X86_USE_PPRO_CHECKSUM=y
+CONFIG_X86_P6_NOP=y
+CONFIG_X86_TSC=y
+CONFIG_X86_MINIMUM_CPU_FAMILY=6
+CONFIG_X86_DEBUGCTLMSR=y
 # CONFIG_HPET_TIMER is not set
 # CONFIG_IOMMU_HELPER is not set
 CONFIG_NR_CPUS=8
@@ -229,11 +232,11 @@
 CONFIG_MICROCODE_OLD_INTERFACE=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
-# CONFIG_NOHIGHMEM is not set
-CONFIG_HIGHMEM4G=y
+CONFIG_NOHIGHMEM=y
+# CONFIG_HIGHMEM4G is not set
 # CONFIG_HIGHMEM64G is not set
 CONFIG_PAGE_OFFSET=0xC0000000
-CONFIG_HIGHMEM=y
+CONFIG_X86_PAE=y
 CONFIG_NEED_NODE_MEMMAP_SIZE=y
 CONFIG_ARCH_FLATMEM_ENABLE=y
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
@@ -246,13 +249,11 @@
 CONFIG_HAVE_MEMORY_PRESENT=y
 CONFIG_SPARSEMEM_STATIC=y
 # CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
-# CONFIG_MEMORY_HOTPLUG is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
-# CONFIG_RESOURCES_64BIT is not set
+CONFIG_RESOURCES_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
-# CONFIG_HIGHPTE is not set
 # CONFIG_MATH_EMULATION is not set
 CONFIG_MTRR=y
 CONFIG_EFI=y
@@ -265,13 +266,11 @@
 CONFIG_HZ=1000
 # CONFIG_SCHED_HRTICK is not set
 CONFIG_KEXEC=y
-CONFIG_CRASH_DUMP=y
 CONFIG_PHYSICAL_START=0x100000
 # CONFIG_RELOCATABLE is not set
 CONFIG_PHYSICAL_ALIGN=0x100000
 # CONFIG_HOTPLUG_CPU is not set
 CONFIG_COMPAT_VDSO=y
-CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 
 #
 # Power management options
@@ -1844,7 +1843,6 @@
 #
 CONFIG_PROC_FS=y
 # CONFIG_PROC_KCORE is not set
-CONFIG_PROC_VMCORE=y
 CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y


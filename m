Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbZHYVQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbZHYVQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZHYVQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:16:52 -0400
Received: from smtp08.online.nl ([194.134.42.53]:53873 "EHLO smtp08.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbZHYVQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:16:51 -0400
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 17:16:51 EDT
Date: Tue, 25 Aug 2009 23:05:21 +0200 (CEST)
From: "Robert M. Stockmann" <stock@stokkie.net>
X-X-Sender: stock@dellie2.hardebol.nl
To: techsupport@tyan.com, <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@osdl.org>
Subject: Thunder K8W S2885 V2.07 BIOS Upgrade
Message-ID: <Pine.LNX.4.44.0908252234070.5313-100000@dellie2.hardebol.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Online-Scanned: by Cloudmark authority (on smtp08.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I would like to mention that after i upgraded the BIOS of my 
Thunder K8W (S2885) from V2.04 to V2.07 the Linux version Mandrake 
10.1 x86_64 with kernel 2.6.15 has started to run with much greater 
performance.

All these Opteron features like NUMA etc. seem finally have started 
to work like expected!

The memory usage is way way down, where i 'only' have 2Gb RAM ECC 
installed, leaving me an extra 14Gb RAM to go. Important is to 
reverse the CPU options for the Opteron inside the Linux kernel 
back to the Linux platform defaults like Linus Torvalds ships 
these with his kernels inside arch/x86_64/defconfig :

#
# Processor type and features
#
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_TSC=y
CONFIG_X86_GOOD_APIC=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_HT=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_MTRR=y
CONFIG_SMP=y
CONFIG_SCHED_SMT=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_BKL=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
# CONFIG_NUMA_EMU is not set
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_NR_CPUS=32
CONFIG_HOTPLUG_CPU=y
CONFIG_HPET_TIMER=y
CONFIG_X86_PM_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_PHYSICAL_START=0x100000
# CONFIG_KEXEC is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_ISA_DMA_API=y
CONFIG_GENERIC_PENDING_IRQ=y

If your BIOS team and developers keep such standards in good 
practice, Tyan might become the sole system(s) supplier of 
importance.

Keep up the god work!
Best regards,

Robert
PS. These git critters sure know how to store useful
    information, after pppd kept dying with 

	invalid operand: 0000 [1] SMP
	skb_panic_over: text: ffffffff888df03b
	  len:1 put: 1 head: ffff810038017800
	  data: fff810130817800 tail: fff810130817801
	  end: fff810030817e00  dev: <NULL>

     on my x86_64 machine.
   ( I'm sorry for still running on 2006 hardware and software,
     but hey time fly's when your having fun!)

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=8243126c5e29030bf1a3fb75187a513966dcba62;hp=f09484ff87f677056ce631aa3d8e486861501b5

   From: David S. Miller <davem@sunset.davemloft.net>
   Date: Tue, 17 Jan 2006 10:54:21 +0000 (-0800)
   Subject: [NET]: Make second arg to skb_reserved() signed.
   X-Git-Tag: v2.6.16-rc2~367^2~7
   X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=8243126c5e29030bf1a3fb75187a513966dcba62;hp=f09484ff87f677056ce631aa3d8e486861501b5
   
   [NET]: Make second arg to skb_reserved() signed.

   Some subsystems, such as PPP, can send negative values
   here.  It just happened to work correctly on 32-bit with
   an unsigned value, but on 64-bit this explodes.
   
   Figured out by Paul Mackerras based upon several PPP crash
   reports.
   
   Signed-off-by: David S. Miller <davem@davemloft.net>
   ---
   
   diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
   index e5fd66c..ad7cc22 100644
   --- a/include/linux/skbuff.h
   +++ b/include/linux/skbuff.h
   @@ -926,7 +926,7 @@ static inline int skb_tailroom(const struct sk_buff *skb)
     *     Increase the headroom of an empty &sk_buff by reducing the tail
     *     room. This is only allowed for an empty buffer.
     */
   -static inline void skb_reserve(struct sk_buff *skb, unsigned int len)
   +static inline void skb_reserve(struct sk_buff *skb, int len)
    {
           skb->data += len;
           skb->tail += len;

-- 
Robert M. Stockmann - RHCE
Network Engineer - UNIX/Linux Specialist
crashrecovery.org  stock@stokkie.net


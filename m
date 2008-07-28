Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYG1OYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYG1OYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYG1OYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:24:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbYG1OYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:24:09 -0400
Date: Mon, 28 Jul 2008 16:22:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01] x86: L3 cache index disable for 2.6.26
Message-ID: <20080728142256.GF18144@elte.hu>
References: <200807181603.52332.mark.langsdorf@amd.com> <20080721113706.GC23095@elte.hu> <20080721124812.GA25371@elte.hu> <200807221306.03123.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807221306.03123.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> On Monday 21 July 2008, Ingo Molnar wrote:
> > > applied to tip/x86/cpu, thanks Mark.
> > > 
> > > I've done some coding style fixes for the new functions you've 
> > > introduced, see that commit below.
> > 
> > -tip testing found the following build failure:
> > 
> >  arch/x86/kernel/built-in.o: In function `show_cache_disable':
> >  intel_cacheinfo.c:(.text+0xbbf2): undefined reference to `k8_northbridges'
> >  arch/x86/kernel/built-in.o: In function `store_cache_disable':
> >  intel_cacheinfo.c:(.text+0xbd91): undefined reference to `k8_northbridges'
> > 
> > please send a delta fix patch against the tip/x86/cpu branch:
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> > 
> > which has your patch plus the cleanup applied.
> 
> delta fix patch follows.  It removes the dependency on k8_northbridges.

applied, thanks. I fixed up some whitespace damage, see below. That file 
could use a thorough cleanup ...

	Ingo

---------------------->
Subject: re: x86 l3 cache index disable for 2 6 26 fix
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Jul 28 16:20:08 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   39 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 19 deletions(-)

Index: tip/arch/x86/kernel/cpu/intel_cacheinfo.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ tip/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -1,8 +1,8 @@
 /*
- *      Routines to indentify caches on Intel CPU.
+ *	Routines to indentify caches on Intel CPU.
  *
- *      Changes:
- *      Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
+ *	Changes:
+ *	Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
  *		Ashok Raj <ashok.raj@intel.com>: Work with CPU hotplug infrastructure.
  *	Andi Kleen / Andreas Herrmann	: CPUID4 emulation on AMD.
  */
@@ -136,9 +136,9 @@ struct _cpuid4_info {
 };
 
 static struct pci_device_id k8_nb_id[] = {
-        { PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-        { PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
-        {}
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
+	{}
 };
 
 unsigned short			num_cache_leaves;
@@ -190,9 +190,10 @@ static unsigned short assocs[] __cpuinit
 static unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
 static unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
 
-static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
-		       union _cpuid4_leaf_ebx *ebx,
-		       union _cpuid4_leaf_ecx *ecx)
+static void __cpuinit
+amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
+		     union _cpuid4_leaf_ebx *ebx,
+		     union _cpuid4_leaf_ecx *ecx)
 {
 	unsigned dummy;
 	unsigned line_size, lines_per_tag, assoc, size_in_kb;
@@ -264,7 +265,7 @@ amd_check_l3_disable(int index, struct _
 {
 	if (index < 3)
 		return;
-	this_leaf->can_disable = 1;	
+	this_leaf->can_disable = 1;
 }
 
 static int
@@ -474,7 +475,7 @@ unsigned int __cpuinit init_intel_cachei
 
 /* pointer to _cpuid4_info array (for each cache leaf) */
 static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
-#define CPUID4_INFO_IDX(x, y)    (&((per_cpu(cpuid4_info, x))[y]))
+#define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
 
 #ifdef CONFIG_SMP
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
@@ -511,7 +512,7 @@ static void __cpuinit cache_remove_share
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
 	for_each_cpu_mask(sibling, this_leaf->shared_cpu_map) {
-		sibling_leaf = CPUID4_INFO_IDX(sibling, index);	
+		sibling_leaf = CPUID4_INFO_IDX(sibling, index);
 		cpu_clear(cpu, sibling_leaf->shared_cpu_map);
 	}
 }
@@ -593,7 +594,7 @@ struct _index_kobject {
 
 /* pointer to array of kobjects for cpuX/cache/indexY */
 static DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
-#define INDEX_KOBJECT_PTR(x, y)    (&((per_cpu(index_kobject, x))[y]))
+#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
 static ssize_t show_##file_name						\
@@ -675,7 +676,7 @@ static struct pci_dev *get_k8_northbridg
 		if (!dev)
 			break;
 	}
-	return dev;	
+	return dev;
 }
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
@@ -736,7 +737,7 @@ store_cache_disable(struct _cpuid4_info 
 		printk(KERN_ERR "Attempting AMD northbridge operation on a system with no northbridge\n");
 		return -EINVAL;
 	}
-	
+
 	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
 	wbinvd();
 	pci_write_config_dword(dev, 0x1BC + index * 4, val);
@@ -789,7 +790,7 @@ static ssize_t show(struct kobject * kob
 	ret = fattr->show ?
 		fattr->show(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
 			buf) :
-	       	0;
+		0;
 	return ret;
 }
 
@@ -800,9 +801,9 @@ static ssize_t store(struct kobject * ko
 	struct _index_kobject *this_leaf = to_object(kobj);
 	ssize_t ret;
 
-        ret = fattr->store ?
-                fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-                        buf, count) :
+	ret = fattr->store ?
+		fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
+			buf, count) :
 		0;
 	return ret;
 }

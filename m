Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbZCRWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbZCRWDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757639AbZCRWDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:03:22 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:26461
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754892AbZCRWDV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:03:21 -0400
X-BigFish: VPS-34(zz542N1432R1805M936fK9371P103dKzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KGQ2KZ-02-G2Z-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [tip:x86/cpu] x86, cpu: intel_cacheinfo.c: use cpumask_first(to_cpumask())
Date: Wed, 18 Mar 2009 17:03:12 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AF23@sausexmb4.amd.com>
In-Reply-To: <tip-d42c33ef0a236c6874c748438500c78edfaa1187@git.kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [tip:x86/cpu] x86, cpu: intel_cacheinfo.c: use cpumask_first(to_cpumask())
Thread-Index: AcmoEpxfaiRhqATLQqWP7RKwkyfgeQAArXNg
References: <tip-d42c33ef0a236c6874c748438500c78edfaa1187@git.kernel.org>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <hpa@zytor.com>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>, <tglx@linutronix.de>,
       <hpa@linux.intel.com>
X-OriginalArrivalTime: 18 Mar 2009 22:03:12.0713 (UTC) FILETIME=[54CADB90:01C9A815]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks! 

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@linux.intel.com] 
> Sent: Wednesday, March 18, 2009 4:43 PM
> To: linux-tip-commits@vger.kernel.org
> Cc: hpa@zytor.com; mingo@redhat.com; Langsdorf, Mark; 
> tglx@linutronix.de; hpa@linux.intel.com
> Subject: [tip:x86/cpu] x86, cpu: intel_cacheinfo.c: use 
> cpumask_first(to_cpumask())
> 
> Commit-ID:  d42c33ef0a236c6874c748438500c78edfaa1187
> Gitweb:     
> http://git.kernel.org/tip/d42c33ef0a236c6874c748438500c78edfaa1187
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Wed, 18 Mar 2009 14:36:02 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 18 Mar 2009 14:38:36 -0700
> 
> x86, cpu: intel_cacheinfo.c: use cpumask_first(to_cpumask())
> 
> Impact: fix warning and possible UP build failure
> 
> Instead of using first_cpu() on a raw bitmask, use
> cpumask_first(to_cpumask()).
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Mark Langsdorf <mark.langsdorf@amd.com>
> 
> 
> ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c 
> b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index b728325..6f4d2a3 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -643,7 +643,8 @@ static ssize_t show_##file_name		
> 				\
>  static ssize_t show_cache_disable(struct _cpuid4_info 
> *this_leaf, char *buf,
>  		 unsigned int index)
>  {
> -	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> +	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> +	int node = cpu_to_node(cpu);
>  	struct pci_dev *dev = k8_northbridges[node];
>  	unsigned int reg = 0;
>  
> @@ -665,7 +666,8 @@ static ssize_t
>  store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
>  		 size_t count, unsigned int index)
>  {
> -	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> +	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
> +	int node = cpu_to_node(cpu);
>  	struct pci_dev *dev = k8_northbridges[node];
>  	unsigned long val = 0;
>  	unsigned int scrubber = 0;
> 
> 


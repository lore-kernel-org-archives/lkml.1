Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZIRAkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZIRAkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZIRAkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:40:20 -0400
Received: from sous-sol.org ([216.99.217.87]:35237 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754892AbZIRAkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:40:11 -0400
Date: Thu, 17 Sep 2009 17:34:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.osdl.org
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Message-ID: <20090918003412.GI26034@sequoia.sous-sol.org>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253233028.19731.63.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alok Kataria (akataria@vmware.com) wrote:
> We ran a few experiments to compare performance of VMware's
> paravirtualization technique (VMI) and hardware MMU technologies (HWMMU)
> on VMware's hypervisor.
> 
> To give some background, VMI is VMware's paravirtualization
> specification which tries to optimize CPU and MMU operations of the
> guest operating system. For more information take a look at this
> http://www.vmware.com/interfaces/paravirtualization.html
> 
> In most of the benchmarks, EPT/NPT (hwmmu) technologies are at par or
> provide better performance compared to VMI.
> The experiments included comparing performance across various micro and
> real world like benchmarks.
> 
> Host configuration used for testing.
> * Dell PowerEdge 2970
> * 2 x quad-core AMD Opteron 2384 2.7GHz (Shanghai C2), RVI capable.
> * 8 GB (4 x 2GB) memory, NUMA enabled
> * 2 x 300GB RAID 0 storage
> * 2 x embedded 1Gb NICs (Braodcom NetXtreme II BCM5708 1000Base-T)
> * Running developement build of ESX.
> 
> The guest VM was a SLES 10 SP2 based VM for both the VMI and non-VMI
> case. kernel version: 2.6.16.60-0.37_f594963d-vmipae.
> 
> Below is a short summary of performance results between HWMMU and VMI.
> These results are averaged over 9 runs. The memory was sized at 512MB
> per VCPU in all experiments.
> For the ratio results comparing hwmmu technologies to vmi, higher than 1
> means hwmmu is better than vmi.
> 
> compile workloads - 4-way : 1.02, i.e. about 2% better.
> compile workloads - 8-way : 1.14, i,e. 14% better.
> oracle swingbench - 4-way (small pages) : 1.34, i.e. 34% better.
> oracle swingbench - 4-way (large pages) : 1.03, i.e. 3% better.
> specjbb (large pages)   : 0.99, i.e. 1% degradation.

Not entirely surprising.  Curious if you ran specjbb w/ small pages too?

> Please note that specjbb is the worst case benchmark for hwmmu, due to
> the higher TLB miss latency, so it's a good result that the worst case
> benchmark has a degradation of only 1%.
> 
> VMware expects that these hardware virtualization features will be
> ubiquitous by 2011.
> 
> Apart from the performance benefit, VMI was important for Linux on
> VMware's platform, from timekeeping point of view, but with the tickless
> kernels and TSC improvements that were done for the mainline tree, we
> think VMI has outlived those requirements too.
> 
> In light of these results and availability of such hardware, we have
> decided to stop supporting VMI in our future products.
> 
> Given this new development, I wanted to discuss how should we go about
> retiring the VMI code from mainline Linux, i.e. the vmi_32.c and
> vmiclock_32.c bits.
> 
> One of the options that I am contemplating is to drop the code from the
> tip tree in this release cycle, and given that this should be a low risk
> change we can remove it from Linus's tree later in the merge cycle.
> 
> Let me know your views on this or if you think we should do this some
> other way.

Typically we give time measured in multiple release cycles
before deprecating a feature.  This means placing an entry in
Documentation/feature-removal-schedule.txt, and potentially
adding some noise to warn users they are using a deprecated
feature.

thanks,
-chris

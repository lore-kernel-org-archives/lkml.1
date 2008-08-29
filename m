Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYH2GZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYH2GZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYH2GUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:20:24 -0400
Received: from main.gmane.org ([80.91.229.2]:41853 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYH2GUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:20:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Fri, 29 Aug 2008 09:20:05 +0300
Message-ID: <87fxoofilm.fsf@jondo.cante.net>
References: <48B76FF5.6010507@yahoo.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:KKz+BN16UEDQf7oL7+jozrpVMuo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar> writes:

> When booted kernel with no iommu parameter, it uses the iommu gart
> (from amd) and the size of the aperture is 64MB You can try to grow
> this size with iommu=memaper=2 for 128MB or 3 for 256MB. I don't have
> experience with this, but i read that this, solves the problem.

See my original bug report, which included experiences with
memaper. Unofrtunately they didn't help:

    REF: http://article.gmane.org/gmane.linux.kernel/725293 (thread start)

but I'll try that once more with this 2.6.26 kernel to double check.

> I have the similar hardware, but when boot in 64 bits, limit the
> memory with mem=4G (discarded 0.5G that are (remaped from pci space)
> beyond 4G) and iommu=noaperture. (This is not option for you, will be
> discard 4G of RAM)

Interestingly 'noaperture' together with 'noagp' has been the best
option so far. It gives workign system for about week, but eventually
the "out of IOMMU space" messages start appear.

The system has always seen the full 8 GB memory without problems.

> Asus M2N32-SLI DELUXE (BIOS Phoenix ver 1603 [12/17/2007])
> 4 x 1GB OCZ DDR2 PC2-6400 Platinum Rev2 ( OCZ2P800R21G )
> AMD Athlon 64 X2 5200+ ( ADA5200IAA6CS ) (stepping F2)

The only difference to your system is more recent CPU:

$ cat/proc/cpuinfo

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Athlon(tm) X2 Dual Core Processor BE-2400
stepping        : 2
cpu MHz         : 2310.516
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch
bogomips        : 4625.06
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc
...

> I have realiced some test an posted here (sorry in spanish): http://www.pcmasmas.com/viewtopic.php?t=31445

Could you explain this a bit more. Is the mentioned "tip-latest" the
current kernel development tree? Should I try to compile this kernel and
use it for testing?

Jari



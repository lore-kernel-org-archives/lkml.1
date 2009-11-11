Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbZKKUjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbZKKUjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758875AbZKKUju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:39:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:64826 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863AbZKKUjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tSHTlowUxCeXbP+lZVh4K+ksla1MKICCqPdoeZEnAWfxFuK1d8KAhpTY74+G4A8ysZ
         yoVeBMV46as54yZv7itYUGi8rp52wlqdMBdO709CP2DCS5NfV5lOWiX5IO396PTUK2wa
         v81dDH29IY2keaIcpsfZyZMsfvmm9MjRYMYoQ=
Date: Wed, 11 Nov 2009 23:34:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
	fast string.
Message-ID: <20091111203425.GA25401@lenovo>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu> <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 03:05:34PM +0800, Ma, Ling wrote:
> Hi All
> Please use the memcpy.c(cc -o memcpy memcpy.c -O2) to test more cases,
> if you have interest. In this program we did simple modification
> on memcpy_new function.
> 
> Thanks
> Ling

Just my 0.2$ :)

	-- Cyrill
---
                       			memcpy_orig	memcpy_new
TPT: Len 1024, alignment  8/ 0:		490		570
TPT: Len 2048, alignment  8/ 0:		826		329
TPT: Len 3072, alignment  8/ 0:		441		464
TPT: Len 4096, alignment  8/ 0:		579		596
TPT: Len 5120, alignment  8/ 0:		723		729
TPT: Len 6144, alignment  8/ 0:		859		861
TPT: Len 7168, alignment  8/ 0:		996		994
TPT: Len 8192, alignment  8/ 0:		1165		1127
TPT: Len 9216, alignment  8/ 0:		1273		1260
TPT: Len 10240, alignment  8/ 0:	1402		1395
TPT: Len 11264, alignment  8/ 0:	1543		1525
TPT: Len 12288, alignment  8/ 0:	1682		1659
TPT: Len 13312, alignment  8/ 0:	1869		1815
TPT: Len 14336, alignment  8/ 0:	1982		1951
TPT: Len 15360, alignment  8/ 0:	2185		2110
---

I've run this test a few times and results almost the same,
with alignment 1024, 3072, 4096, 5120, 6144, new version a bit slowly.

---
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     T8100  @ 2.10GHz
stepping	: 6
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida tpr_shadow vnmi flexpriority
bogomips	: 4189.60
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     T8100  @ 2.10GHz
stepping	: 6
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm ida tpr_shadow vnmi flexpriority
bogomips	: 4189.46
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


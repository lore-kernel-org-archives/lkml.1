Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZLYHiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZLYHiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 02:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZLYHix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 02:38:53 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:51332 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZLYHiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 02:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dq9GCq9kpfrANz3bw9WFp2zetlBwEmPUpksy6n9MidmYa4gAAQBbcf9Bv7MLJW2n8A
         jdgxUbar/1WQONxq4a/U0AG6WPduQqMO0CEF86wN1BYlbX3WvtOAfackdNc5QilgCXSB
         v1L0yt4Cgj+MwbZlvlsgE7v67rhDmVseYhlYI=
MIME-Version: 1.0
In-Reply-To: <4B324B76.9020901@blueyonder.co.uk>
References: <4B324B76.9020901@blueyonder.co.uk>
Date: Thu, 24 Dec 2009 23:38:51 -0800
X-Google-Sender-Auth: b7f3969b16381b8c
Message-ID: <86802c440912242338q4a9adb03k8739d90042394d05@mail.gmail.com>
Subject: Re: All kernels after 2.6.32-git10 show only 1 CPU
From: Yinghai Lu <yinghai@kernel.org>
To: sboyce@blueyonder.co.uk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 8:55 AM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
> On the 4P box, 2.6.32-git10 boots and shows 4 CPU's, 2.6.32-git12 boots
> and shows 1 CPU, 2.6.32-git15 to 2.6.33-rc1-git3 1 CPU and lots of oops,
> continues with something like "Sending NMI interrupts to CPU's",
> [udev] unexpectedly returned with status 0x0100
> [udev] failed while handling /devices/pci000:00 -----etc--- same for
> other devices.
> Unable to capture via serial console as USB doesn't come ready.
>
> On 2P laptop, up to 2.6.33-rc1 boots, 1 CPU and boot option "acpi=noirq"
> needed, without it boot hangs, I think from 2.6.32-git15.
>  Building kernels, I have used the .config from previous kernel and
> "make oldconfig".
>
> # uname -r
> 2.6.32-git12-smp
> slipstream:~ # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.597
> cache size      : 512 KB
> physical id     : 0
> siblings        : 1
> core id         : 0
> cpu cores       : 1
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc up rep_good nonstop_tsc
> pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm
> sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
> bogomips        : 6027.18
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
>
> # uname -r
> 2.6.32-git10-smp
>
> # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.774
> cache size      : 512 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 4
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
> bogomips        : 6027.53
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
>
> processor       : 1
> vendor_id       : AuthenticAMD
> cpu family      : 16
> model           : 4
> model name      : AMD Phenom(tm) II X4 940 Processor
> stepping        : 2
> cpu MHz         : 3013.774
> cache size      : 512 KB
> physical id     : 0
> siblings        : 4
> core id         : 1
> cpu cores       : 4
> apicid          : 1
> initial apicid  : 1
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext
> fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good
> nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm
> extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt
> bogomips        : 6027.27
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 48 bits physical, 48 bits virtual
> power management: ts ttp tm stc 100mhzsteps hwpstate
>
> etc., up to processor 4.
>
> On a 2P laptop
> ===============
> tindog:~ # uname -r
> 2.6.33-rc1-smp
>
> tindog:~ # cat /proc/cpuinfo
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 67
> model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
> stepping        : 3
> cpu MHz         : 1000.000
> cache size      : 1024 KB
> physical id     : 0
> siblings        : 1
> core id         : 0
> cpu cores       : 1
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
> cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> rdtscp lm 3dnowext 3dnow up rep_good pni cx16 lahf_lm cmp_legacy svm
> extapic cr8_legacy
> bogomips        : 2009.33
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 40 bits physical, 48 bits virtual
> power management: ts fid vid ttp tm stc
>
> The .config for the 4P and 2.6.33-rc1-git3 attached.

Can you disable MAXSMP?

YH

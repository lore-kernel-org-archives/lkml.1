Return-Path: <linux-kernel-owner+w=401wt.eu-S1422897AbXBBME1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422897AbXBBME1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 07:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422944AbXBBME0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 07:04:26 -0500
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:39130 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422897AbXBBME0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 07:04:26 -0500
Date: Fri, 2 Feb 2007 13:04:08 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slower CPU frequency reported by the kernel
Message-ID: <20070202130408.05212b10@localhost>
In-Reply-To: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 12:11:25 +0100
"Francis Moreau" <francis.moro@gmail.com> wrote:

> Hi,
> 
> I'm using a PC with AMD 64 3000+ cpu which is theoricaly running at
> 2Ghz. But when looking at /proc/cpuinfo, the kernel reports that it
> runs only at 1Ghz:
> 
> # cat /proc/cpuinfo
> 
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 12
> model name      : AMD Athlon(tm) 64 Processor 3000+
> stepping        : 0
> cpu MHz         : 1000.000
> cache size      : 512 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm
> 3dnowext 3dnow ts fid vid ttp
> bogomips        : 2004.89
> 
> I tried with a 2.6.20-rc7 kernel and still have the same.
> 
> What's going wrong ?


You are using frequency scaling(*) and "/proc/cpuinfo" reflects the
current speed.


(*) = 
#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m


Read "Documentation/cpu-freq/user-guide.txt" for more info.

-- 
	Paolo Ornati
	Linux 2.6.20-rc7 on x86_64

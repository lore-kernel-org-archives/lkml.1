Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0APM2Y (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 07:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330Ab0APM2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 07:28:23 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:41293 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0APM2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 07:28:22 -0500
Message-ID: <4B51B0E8.1010302@pardus.org.tr>
Date: Sat, 16 Jan 2010 14:28:24 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jaswinder@kernel.org, stable@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
References: <4B4E1633.8010700@pardus.org.tr> <4B4EC0A1.3090503@pardus.org.tr> <4B4ECB1C.6070000@kernel.org> <4B4EF35D.3040203@pardus.org.tr> <4B4F1764.2040406@pardus.org.tr> <4B4F1DE7.307@pardus.org.tr>
In-Reply-To: <4B4F1DE7.307@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ozan Çağlayan wrote:
> Ozan Çağlayan wrote On 14-01-2010 15:08:
> 
> (CC'ing stable)
> 
>>> From 5095f59bda6793a7b8f0856096d6893fe98e0e51 Mon Sep 17 00:00:00 2001
>>> From: Jaswinder Singh Rajput <jaswinder@kernel.org>
>>> Date: Fri, 5 Jun 2009 23:27:17 +0530
>>> Subject: [PATCH] x86: cpu_debug: Remove model information to reduce encoding-decoding
>> Reverting this commit on top of 2.6.31.11 fixes the boot hangs with AMD Athlon XP processors.
>> I'll double check with other reporters in a day or two.
> 
> OK we've verified on 2 separate systems with Athlon XP that reverting the commit fixes the issue.
> Here's proc/cpuinfo and relevant dmesg output for reference:
> 
> processor    : 0
> vendor_id    : AuthenticAMD
> cpu family    : 6
> model        : 10
> model name    : AMD Athlon(tm) XP 2600+
> stepping    : 0
> cpu MHz        : 1920.500
> cache size    : 512 KB
> fdiv_bug    : no
> hlt_bug        : no
> f00f_bug    : no
> coma_bug    : no
> fpu        : yes
> fpu_exception    : yes
> cpuid level    : 1
> wp        : yes
> flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow up
> bogomips    : 3842.29
> clflush size    : 32
> power management: ts
> 
> 
> 
> [    0.461404] Freeing initrd memory: 5191k freed
> [    0.467844] initcall populate_rootfs+0x0/0x62 returned 0 after 217975 usecs
> [    0.467947] calling  i8259A_init_sysfs+0x0/0x1d @ 1
> [    0.468093] initcall i8259A_init_sysfs+0x0/0x1d returned 0 after 41 usecs
> [    0.468190] calling  sbf_init+0x0/0xda @ 1
> [    0.468282] initcall sbf_init+0x0/0xda returned 0 after 0 usecs
> [    0.468378] calling  i8237A_init_sysfs+0x0/0x1d @ 1
> [    0.468484] initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 12 usecs
> [    0.468582] calling  add_rtc_cmos+0x0/0x94 @ 1
> [    0.468679] initcall add_rtc_cmos+0x0/0x94 returned 0 after 4 usecs
> [    0.468780] calling  cache_sysfs_init+0x0/0x55 @ 1
> [    0.468940] initcall cache_sysfs_init+0x0/0x55 returned 0 after 64 usecs
> [    0.469041] calling  cpu_debug_init+0x0/0x1f @ 1
> [    0.469190] cpu0(1) debug files 5
> [    0.469282] initcall cpu_debug_init+0x0/0x1f returned 0 after 143 usecs <-- That call wasn't returning at all
> 
> I think that the commit should be reverted or a fix should be released for linux-2.6 tree,
> as well as .31 and .32 stable trees.


Linux 2.6.31 is released on Sep 9th. So people having an Athlon XP processor + a kernel newer than 4 months
which enables CONFIG_X86_CPU_DEBUG can't even boot into a linux kernel. I was *at least* expecting a comment from the relevant
people but nope for 2 days.

It seems to be a serious regression which doesn't get caught. I'm also CC'ing Rafael, maybe he can inject this
in one of his regression threads.

Thanks
Ozan Caglayan

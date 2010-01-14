Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132Ab0ANHpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0ANHpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978Ab0ANHpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:45:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:33916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab0ANHpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:45:10 -0500
Message-ID: <4B4ECB1C.6070000@kernel.org>
Date: Wed, 13 Jan 2010 23:43:24 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
References: <4B4E1633.8010700@pardus.org.tr> <4B4EC0A1.3090503@pardus.org.tr>
In-Reply-To: <4B4EC0A1.3090503@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 10:58 PM, Ozan Çağlayan wrote:
> Ozan Çağlayan wrote On 13-01-2010 20:51:
> 
> (CC'ing relevant people)
> 
>> Hi,
>>
>> A lot of our users complains about the problem in $subject. Here are some clues:
>>
>> - All users have mainboards with nForce2 chipset:
>>   nVidia Corporation nForce2 IGP2 [10de:01e0] (rev c1)
>> - The last working kernel for them is 2.6.30.9. They can't boot into 2.6.31.9-11,
>> - They all tried several boot parameters to disable acpi, lapic, mce, etc. none of them works,
>>
> 
> I just made them boot with:
> 
> bootmem_debug debug debugpat dynamic_printk earlyprintk=vga initcall_debug
> loglevel=7 mminit_loglevel=4 pnp.debug sched_debug apic=debug
> 
> and we had more relevant messages:
> 
> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> initcall inet_init+0x0/0x199 returned 0 after 3585 usecs
> calling af_unix_init+0x0/0x47 @ 1
> NET: Registered protocol family 1
> initcall af_unix_init+0x0/0x47 returned 0 after 101 usecs
> calling populate_rootfs+0x0/0x62 @ 1
> Unpacking initramfs...
> Freeing initrd memory: 5109k freed
> initcall populate_rootfs+0x0/0x62 returned 0 after 215338 usecs
> calling i8259A_init_sysfs+0x0/0x1d @ 1
> initcall i8259A_init_sysfs+0x0/0x1d returned 0 after 42 usecs
> calling sbf_init+0x0/0xda @ 1
> initcall sbf_init+0x0/0xda returned 0 after 0 usecs
> calling i8237A_init_sysfs+0x0/0x1d @ 1
> initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 13 usecs
> calling add_rtc_cmos+0x0/0x94 @ 1
> initcall add_rtc_cmos+0x0/0x94 returned 0 after 4 usecs
> calling cache_sysfs_init+0x0/0x55 @ 1
> initcall cache_sysfs_init+0x0/0x55 returned 0 after 64 usecs
> calling cpu_debug_init+0x0/0xe3 @ 1
> 
> and it hangs. Not that this is the place where on 2.6.30.9 it continues with:
> 
> [    0.404102] cpu0(1) debug files 5 <--
> [    0.404109] Machine check exception polling timer started.
> [    0.404119] cpufreq-nforce2: Detected nForce2 chipset revision C1
> [    0.404122] cpufreq-nforce2: FSB changing is maybe unstable and can lead to
> crashes and data loss.
> [    0.404135] cpufreq-nforce2: FSB currently at 167 MHz, FID 11.5
> [    0.404155] ondemand governor failed, too long transition latency of HW,
> fallback to performance governor
> 
> The users all have an AMD Athlon XP series processor. There are 576 changes in arch/x86/kernel and 291
> in arch/x86/kernel/cpu between 2.6.30 and 2.6.31. Need some hands where to start to debug the problem.

can you just deselect CONFIG_X86_CPU_DEBUG in your .config ?

YH

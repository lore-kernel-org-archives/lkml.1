Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYJaXTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYJaXTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 19:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYJaXTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 19:19:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:37390 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYJaXTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 19:19:39 -0400
Message-ID: <490B9281.9080402@kernel.org>
Date: Fri, 31 Oct 2008 16:19:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PAT and MTRRs
References: <200810262246.21807.dvadell@linuxclusters.com.ar>    <86802c440810262217h13f78e57l1f234e8e86b72785@mail.gmail.com> <59727.163.10.1.174.1225492920.squirrel@sec.bit-consulting.com.ar>
In-Reply-To: <59727.163.10.1.174.1225492920.squirrel@sec.bit-consulting.com.ar>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego M. Vadell wrote:
>> can you try 2.6.28-rc2 ot tip/master and boot with mtrr_cleanup_debug ?
>>
>> YH
> 
> Hello,
>   Thank you very much and sorry for the delay. This is a remote site and I
> have to travel to get here.
> 
>   I upgradedt to 2.6.28-rc2 but the problem persists. Here is the
> (hopefully) relevant part of dmesg:
> 
> BIOS EBDA/lowmem at: 0009fc00/0009fc00
> Linux version 2.6.28-rc2 (root@compute-0-5.local) (gcc version 3.4.6
> 20060404 (Red Hat 3.4.6-8))
> #1 SMP Fri Oct 31 18:01:52 ART 2008
> Command line: ro root=LABEL=/  mtrr_cleanup_debug
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   Centaur CentaurHauls
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
>  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000cf561000 (usable)
>  BIOS-e820: 00000000cf561000 - 00000000cf56e000 (reserved)
>  BIOS-e820: 00000000cf56e000 - 00000000cf612000 (usable)
>  BIOS-e820: 00000000cf612000 - 00000000cf6e9000 (ACPI NVS)
>  BIOS-e820: 00000000cf6e9000 - 00000000cf6ed000 (usable)
>  BIOS-e820: 00000000cf6ed000 - 00000000cf6f2000 (ACPI data)
>  BIOS-e820: 00000000cf6f2000 - 00000000cf6f3000 (usable)
>  BIOS-e820: 00000000cf6f3000 - 00000000cf6ff000 (ACPI data)
>  BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
>  BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
>  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
>  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
> DMI 2.4 present.
> last_pfn = 0x12c000 max_arch_pfn = 0x3ffffffff
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> After WB checking
> MTRR MAP PFN: 0000000000000000 - 00000000000d0000
> After UC checking
> MTRR MAP PFN: 0000000000000000 - 00000000000cf700
> After sorting
> MTRR MAP PFN: 0000000000000000 - 00000000000cf700
> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 704MB of RAM.
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1662
> mtrr_trim_uncached_memory+0x331/0x358()
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.28-rc2 #1
> Call Trace:
>  [<ffffffff80232c63>] warn_on_slowpath+0x51/0x6d
>  [<ffffffff80233b5f>] printk+0x8d/0x95
>  [<ffffffff80306735>] generic_swap+0x0/0x19
>  [<ffffffff8060a92e>] cmp_range+0x0/0x6
>  [<ffffffff8060b4f0>] mtrr_trim_uncached_memory+0x331/0x358
>  [<ffffffff803efcf7>] dmi_table+0x6f/0x96
>  [<ffffffff80621aa3>] dmi_decode+0x0/0x4ab
>  [<ffffffff806072a8>] setup_arch+0x3f9/0x63c
>  [<ffffffff8060083c>] start_kernel+0x6a/0x307
>  [<ffffffff806003a1>] x86_64_start_kernel+0xef/0xf3
> ---[ end trace 4eaa2a86a8e2da22 ]---
> update e820 for mtrr
> modified physical RAM map:
>  modified: 0000000000000000 - 000000000008f000 (usable)
>  modified: 000000000008f000 - 00000000000a0000 (reserved)
>  modified: 00000000000e0000 - 0000000000100000 (reserved)
>  modified: 0000000000100000 - 00000000cf561000 (usable)
>  modified: 00000000cf561000 - 00000000cf56e000 (reserved)
>  modified: 00000000cf56e000 - 00000000cf612000 (usable)
>  modified: 00000000cf612000 - 00000000cf6e9000 (ACPI NVS)
>  modified: 00000000cf6e9000 - 00000000cf6ed000 (usable)
>  modified: 00000000cf6ed000 - 00000000cf6f2000 (ACPI data)
>  modified: 00000000cf6f2000 - 00000000cf6f3000 (usable)
>  modified: 00000000cf6f3000 - 00000000cf6ff000 (ACPI data)
>  modified: 00000000cf6ff000 - 00000000cf700000 (usable)
>  modified: 00000000cf700000 - 00000000d0000000 (reserved)
>  modified: 00000000fff00000 - 000000012c000000 (reserved)
> last_pfn = 0xcf700 max_arch_pfn = 0x3ffffffff

do you have 

# grep MTRR .config
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

in your config files..

it seems mtrr_cleanup is not triggered...

also please put debug in your boot command line. like
ro root=LABEL=/  mtrr_cleanup_debug debug

YH

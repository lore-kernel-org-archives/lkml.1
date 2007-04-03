Return-Path: <linux-kernel-owner+w=401wt.eu-S965752AbXDCRTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965752AbXDCRTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965765AbXDCRTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:19:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:18379 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965752AbXDCRTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:19:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,366,1170662400"; 
   d="scan'208"; a="207504226:sNHT19796623"
Message-ID: <46128C92.2020908@intel.com>
Date: Tue, 03 Apr 2007 10:19:14 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc5-mm4
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <Pine.LNX.4.64.0704031455200.10589@twin.jikos.cz> <46126EAA.3050000@intel.com> <Pine.LNX.4.64.0704031725300.28249@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0704031725300.28249@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2007 17:19:16.0124 (UTC) FILETIME=[34D66DC0:01C77614]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 3 Apr 2007, Kok, Auke wrote:
> 
>> Also, it would help a lot if you knew what kind of settings your init 
>> scripts are trying to configure. It seems that something is setting 
>> multicast or promiscuous mode. Do you happen to know which command is 
>> being executed by the shell?
> 
> It's 100% reproducible by running dhclient on the interface.
> 
> The kernel also panics (with different stacktrace but the same wrong 
> address it tries to dereference - 0xffffffff) when I do this:
> 
> (none):/# modprobe e1000
> Intel(R) PRO/1000 Network Driver - version 7.4.35-k2-NAPI
> Copyright (c) 1999-2007 Intel Corporation.
> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 
> 00:0e:0c:72:b8:ad
> e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> (none):/# ifconfig eth0 up
> BUG: unable to handle kernel paging request at virtual address ffffffff
>  printing eip:
> ffffffff
> *pde = 00005067
> *pte = 00000000
> Oops: 0000 [#1]
> SMP
> last sysfs file: power/resume
> Modules linked in: e1000 ext3 mbcache jbd edd sg fan generic ata_piix 
> libata thermal processor sd_mod scsi_mod ide_disk ide_core
> CPU:    0
> EIP:    0060:[<ffffffff>]    Not tainted VLI
> EFLAGS: 00010046   (2.6.21-rc5-mm4-default #3)
> EIP is at 0xffffffff
> eax: 00000000   ebx: 00000000   ecx: 00000000   edx: 00000000
> esi: 00000000   edi: c0462008   ebp: 00000080   esp: c0463f94
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process swapper (pid: 0, ti=c0462000 task=c038d340 task.ti=c0462000)
> Stack: c0102297 00000060 00000246 00000000 c049f5a4 c1d095a4 c01023fa c0363b12
>        20070126 c1d11000 c0467ae7 c034a48a c04671b9 00000000 00000000 00000000
>        00000000 00010000 00000000 00000000 00000000 c04887c0 00020800 00099800
> Call Trace:
>  [<c0102297>] mwait_idle_with_hints+0x3b/0x3f
>  [<c01023fa>] cpu_idle+0xa6/0xbf
>  [<c0467ae7>] start_kernel+0x459/0x461
>  [<c04671b9>] unknown_bootoption+0x0/0x202
>  =======================
> INFO: lockdep is turned off.
> Code:  Bad EIP value.
> EIP: [<ffffffff>] 0xffffffff SS:ESP 0068:c0463f94
> Kernel panic - not syncing: Attempted to kill the idle task!
> 
> 
> Seeing "mwait" there, it seemed like ACPI might be involved. Booting with 
> acpi=off didn't improve the situation though.
> 
> I just pulled your e1000 git tree into vanilla 2.6.21-rc5 ytrr and I can't 
> reproduce the problem, so it might be caused by something else.

we're also having problems reproducing it on that same combination (2.6.21-rc4 + 
my tree), so it points to something in -mm. Since your trace is completely 
different right now it looks like something else is fuzzing it up.

Since the e1000 changes are in rc5-mm3 as well, that might help to narrow it 
down quickly.

Auke

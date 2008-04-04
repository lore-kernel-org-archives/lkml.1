Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYDDUTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYDDUTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYDDUTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:19:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42504 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYDDUTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:19:38 -0400
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080404180518.GA12642@ldl.fc.hp.com>
References: <1207331616.5916.15.camel@badari-desktop>
	 <20080404180518.GA12642@ldl.fc.hp.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 13:19:31 -0700
Message-Id: <1207340371.5916.23.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-04 at 12:05 -0600, Alex Chiang wrote:
> Hi Badari,
> 
> * Badari Pulavarty <pbadari@us.ibm.com>:
> > Hi Andrew & Alex,
> > 
> > I get following panic in rpaphp_register_slot() on
> > 2.6.25-rc8-mm1. Known issue ?
> 
> I know about it now... :-/
> 
> Any chance you could turn debugging on for both rpaphp and
> pci_hotplug?
> 

I did set "debug" variables in rpaphp_core.c and pci_hotplug_core.c
to 1. But it didn't give any more information. How do I enable
the debug ?

I just changed dbg() to printk() in rpaphp_register_slot() to
print out more information.

Thanks,
Badari


pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
rpaphp_register_slot registering slot:path[/pci@800000020000003/pci@2,4] index[22010003], name[U787E.001.AAA3015-P2-C1] pdomain[22010003] type[16]
Unable to handle kernel paging request for data at address 0x00000070
Faulting instruction address: 0xc00000000031e4ac
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: c00000000031e4ac LR: c00000000031e434 CTR: 800000000013f270
REGS: c0000000700dba30 TRAP: 0300   Not tainted  (2.6.25-rc8-mm1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 22002022  XER: 00000004
DAR: 0000000000000070, DSISR: 0000000040000000
TASK = c0000000700d7990[1] 'swapper' THREAD: c0000000700d8000 CPU: 0
GPR00: c0000000006c6f10 c0000000700dbcb0 c0000000007691c0 c000000070372440 
GPR04: c000000070217400 0000000000000001 0000000000000000 0000000000000001 
GPR08: c0000000007917cc 0000000000000000 00000000000050b3 c0000000007917c8 
GPR12: 0000000000004000 c000000000690400 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 4000000001c00000 0000000000000000 0000000002247c38 0000000000000000 
GPR24: 0000000002247ea8 c000000071fff1b8 0000000000000000 c0000000023e8f48 
GPR28: c000000070372440 c00000006e036780 c0000000006f77f8 c0000000006c6f10 
NIP [c00000000031e4ac] .rpaphp_register_slot+0xcc/0x158
LR [c00000000031e434] .rpaphp_register_slot+0x54/0x158
Call Trace:
[c0000000700dbcb0] [c00000000031e434] .rpaphp_register_slot+0x54/0x158 (unreliable)
[c0000000700dbd40] [c00000000031dd60] .rpaphp_add_slot+0x1a4/0x260
[c0000000700dbe20] [c000000000636864] .rpaphp_init+0x34/0x68
[c0000000700dbea0] [c0000000006103ec] .kernel_init+0x1f8/0x38c
[c0000000700dbf90] [c000000000023f80] .kernel_thread+0x4c/0x68
Instruction dump:
48000020 e8bd0020 e89e8010 e87e8048 4bd38c15 60000000 3860fff5 48000080 
e93d0028 e89d0030 7f83e378 e9290038 <e9290070> 80a90004 78a5eee2 4bffee89 
---[ end trace 561bb236c800851f ]---




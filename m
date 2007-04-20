Return-Path: <linux-kernel-owner+w=401wt.eu-S1767132AbXDTPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767132AbXDTPnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767133AbXDTPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:43:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767132AbXDTPnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:43:40 -0400
Message-ID: <4628DEEE.3060205@redhat.com>
Date: Fri, 20 Apr 2007 10:40:30 -0500
From: Robert Peterson <rpeterso@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: qla2xxx hba crashes with older 2310 cards
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've seen some chatter about the qla2xxx driver but not paid attention, so
I'm sorry if this is a known issue.  I've got an older qlogic hba, and recent
drivers don't seem to play nice with it.  I've got the latest firmware from
qlogic's web site.  I'm using a 2.6.21-rc6 kernel from Steve Whitehouse's
-nmw git tree.  Reverting to an older driver (but same kernel) and it works.
The current driver gives this:

Starting udev: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
*pde = 1e511067
*pte = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: qla2xxx
CPU:    0
EIP:    0060:[<e003229d>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-rc6 #2)
EIP is at qla2x00_init_host_attr+0x11/0x155 [qla2xxx]
eax: de5262fc   ebx: de527528   ecx: 00000000   edx: de526000
esi: 00000000   edi: 00000000   ebp: de5262fc   esp: de58dd34
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process modprobe (pid: 1827, ti=de58c000 task=df15c030 task.ti=de58c000)
Stack: de527528 e003440f de12b810 de5262fc e001f8dd e001e45e de5262fc e00343a4 
       de527680 00000000 e0016000 00000000 35373d72 00003136 00000000 00000086 
       c0115c1a df426800 c13f1f00 00000000 c16eeba0 00000246 00000000 de526000 
Call Trace:
 [<e001f8dd>] qla2x00_probe_one+0xf69/0x1064 [qla2xxx]
 [<e001e45e>] qla2x00_do_dpc+0x0/0x442 [qla2xxx]
 [<c0115c1a>] try_to_wake_up+0x38c/0x396
 [<c0180dfa>] sysfs_make_dirent+0x29/0x35
 [<c0181bd7>] sysfs_create_link+0x128/0x141
 [<c02072fb>] kobject_get+0xf/0x13
 [<c021382d>] pci_device_probe+0x36/0x57
 [<c027337e>] really_probe+0xbd/0x146
 [<c027344b>] driver_probe_device+0x44/0xa5
 [<c0273536>] __driver_attach+0x0/0x87
 [<c0273588>] __driver_attach+0x52/0x87
 [<c0272a04>] bus_for_each_dev+0x37/0x59
 [<c0273206>] driver_attach+0x16/0x18
 [<c0273536>] __driver_attach+0x0/0x87
 [<c0272cb6>] bus_add_driver+0x5e/0x15f
 [<c021398c>] __pci_register_driver+0x6b/0x97
 [<e00140b4>] qla2x00_module_init+0xb4/0xd6 [qla2xxx]
 [<c01332ca>] sys_init_module+0x1578/0x16bc
 [<c014e9b2>] kmem_cache_destroy+0x0/0xc5
 [<c0151dba>] vfs_read+0x88/0x10a
 [<c01030d8>] sysenter_past_esp+0x5d/0x81
 [<c0400000>] rpc_free_task+0xc/0x37
 =======================
Code: cb 08 c1 e1 08 09 df 09 ce 89 b0 c4 00 00 00 89 b8 c8 00 00 00 5b 5e 5f 5d c3 55 31 c9 57 56 31 f6 53 8b b8 cc 13 00 00 8b 50 08 <0f> b6 1f 8b aa f8 02 00 00 0f b6 57 07 89 de bb 00 00 00 00 c1 
EIP: [<e003229d>] qla2x00_init_host_attr+0x11/0x155 [qla2xxx] SS:ESP 0068:de58dd34

The older driver that works properly gives this:

qla2xxx 0000:01:00.0: Found an ISP2300, irq 21, iobase 0xe0016000
qla2xxx 0000:01:00.0: Configuring PCI space...
qla2xxx 0000:01:00.0: Configure NVRAM parameters...
qla2xxx 0000:01:00.0: Inconsistent NVRAM detected: checksum=0x1a id=<FF> version
=0xff.
qla2xxx 0000:01:00.0: Falling back to functioning (yet invalid -- WWPN) defaults
.
qla2xxx 0000:01:00.0: Verifying loaded RISC code...
qla2xxx 0000:01:00.0: Allocated (412 KB) for firmware dump...
scsi0 : qla2xxx
qla2xxx 0000:01:00.0: LIP reset occured (f7f7).
qla2xxx 0000:01:00.0: LOOP UP detected (1 Gbps).
qla2xxx 0000:01:00.0: 
 QLogic Fibre Channel HBA Driver: 8.01.07-k4
  QLogic QLA2310 - 
  ISP2300: PCI (33 MHz) @ 0000:01:00.0 hdma-, host#=0, fw=3.03.20 IPX

Is this a known problem, or is someone working to fix it?

Regards,

Bob Peterson
Red Hat Cluster Suite

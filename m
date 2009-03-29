Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbZC2QDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbZC2QDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZC2QDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:03:21 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62352 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbZC2QDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:03:19 -0400
From: "Morten P.D. Stevens" <mstevens@win-professional.com>
To: "'Yinghai Lu'" <yinghai@kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       <linux-kernel@vger.kernel.org>
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F21@exchange01.corp.win-professional.com> <86802c440902101052m223792ddi43d27423844b1d5b@mail.gmail.com> <B4ED8DE8E195E84A872496A085BC07822F22@exchange01.corp.win-professional.com> <4991E752.8010903@kernel.org> <B4ED8DE8E195E84A872496A085BC07822F23@exchange01.corp.win-professional.com> <86802c440902102106o54e4ea2fua4d108c8564ff8a@mail.gmail.com> <B4ED8DE8E195E84A872496A085BC07822F2A@exchange01.corp.win-professional.com> <49931E54.7000305@kernel.org>
In-Reply-To: <49931E54.7000305@kernel.org>
Subject: RE: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with 2.6.29-rc3 on IBM x3400
Date: Sun, 29 Mar 2009 18:03:12 +0200
Organization: win-professional.com
Message-ID: <!&!AAAAAAAAAAAuAAAAAAAAAMn4NYSk+t9Fne5+ltELSpUBALTtjejhlehKhySWoIW8B4IAAAAAXswAABAAAAAirXejnimtRZ8yb9LVzWt3AQAAAAA=@win-professional.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcmMefJs/g8scCGsQ5mV79MTvZodPwkDZpWQ
Content-Language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> so that bios need to be fixed too.

a small update:
IBM said the BIOS-provided physical RAM map should be okay and they will not
release a new bios... IBM said, this is a linux problem triggered through
arch/x86/kernel/cpu/mtrr/...

After installing and testing ubuntu server 9.04 (linux 2.6.28) i get this
warning/failure in dmesg:

[    0.000000] BIOS EBDA/lowmem at: 0009c400/0009c400
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-11-server (buildd@crested) (gcc version
4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #37-Ubuntu SMP Mon Mar 23 17:33:24 UTC 2009
(Ubuntu 2.6.28-11.37-server)
[    0.000000] Command line: root=/dev/mapper/ubuntu--server-root ro quiet
splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009c400 (usable)
[    0.000000]  BIOS-e820: 000000000009c400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff60000 (usable)
[    0.000000]  BIOS-e820: 00000000bff60000 - 00000000bff6a000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bff6a000 - 00000000bff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bff80000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x3ffffffff
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at
/build/buildd/linux-2.6.28/arch/x86/kernel/cpu/mtrr/generic.c:411
generic_get_mtrr+0xfa/0x130()
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28-11-server #37-Ubuntu
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80250927>] warn_slowpath+0xb7/0xf0
[    0.000000]  [<ffffffff8041ea88>] ? sprintf+0x68/0x70
[    0.000000]  [<ffffffff8041e5d8>] ? vsnprintf+0x2e8/0x730
[    0.000000]  [<ffffffff8069eaf8>] ? _spin_unlock_irqrestore+0x18/0x20
[    0.000000]  [<ffffffff8069eaf8>] ? _spin_unlock_irqrestore+0x18/0x20
[    0.000000]  [<ffffffff8025124d>] ? release_console_sem+0x1dd/0x230
[    0.000000]  [<ffffffff8025172c>] ? vprintk+0x19c/0x400
[    0.000000]  [<ffffffff80a1aa16>] ? dmi_save_one_device+0x79/0xb4
[    0.000000]  [<ffffffff80220c6a>] generic_get_mtrr+0xfa/0x130
[    0.000000]  [<ffffffff809f7215>] mtrr_trim_uncached_memory+0xa3/0x331
[    0.000000]  [<ffffffff809f26c4>] setup_arch+0x5c6/0x902
[    0.000000]  [<ffffffff80273822>] ?
clockevents_register_notifier+0x42/0x60
[    0.000000]  [<ffffffff809e9b33>] start_kernel+0x6e/0x3b2
[    0.000000]  [<ffffffff809e92b4>] x86_64_start_reservations+0x94/0xb9
[    0.000000]  [<ffffffff809e93ee>] x86_64_start_kernel+0xf2/0x101
[    0.000000]  [<ffffffff809e9140>] ? early_idt_handler+0x0/0x71
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] last_pfn = 0xbff60 max_arch_pfn = 0x3ffffffff
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000008000 (usable)
[    0.000000]  modified: 0000000000008000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000008f400 (usable)
[    0.000000]  modified: 000000000009c400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bff60000 (usable)
[    0.000000]  modified: 00000000bff60000 - 00000000bff6a000 (ACPI data)
[    0.000000]  modified: 00000000bff6a000 - 00000000bff80000 (ACPI NVS)
[    0.000000]  modified: 00000000bff80000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff60000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bff60000 page 4k
[    0.000000] kernel direct mapping tables up to bff60000 @ 10000-15000
[    0.000000] last_map_addr: bff60000 end: bff60000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ 13000-19000
[    0.000000] last_map_addr: 140000000 end: 140000000

root@ubuntu-server:/# uname -a
Linux ubuntu-server 2.6.28-11-server #37-Ubuntu SMP Mon Mar 23 17:33:24 UTC
2009 x86_64 GNU/Linux

root@ubuntu-server:/# cat /proc/mtrr
reg00: base=0x0c0000000 ( 3072MB), size= 1024MB, count=1: uncachable
reg01: base=0x000000000 (    0MB), size= 4096MB, count=1: write-back
reg02: base=0x100000000 ( 4096MB), size= 1024MB, count=1: write-back
reg03: base=0x0bff80000 ( 3071MB), size=  512KB, count=1: uncachable

Morten

-----Original Message-----
From: Yinghai Lu [mailto:yinghai@kernel.org] 
Sent: Wednesday, February 11, 2009 7:52 PM
To: Morten P.D. Stevens
Cc: Ingo Molnar; Thomas Gleixner; H. Peter Anvin; Arjan van de Ven;
linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with
2.6.29-rc3 on IBM x3400

Morten P.D. Stevens wrote:
> Hi,
> 
>> so there is some problem with your BIOS, please ask the vendor to
>> provide one to make
>> 2.6.24 happy.
> 
> I'll report the issue to the IBM support.
> 
> on our IBM x3400 servers running RHEL the same output:
> 
> 2.6.18-92.1.10.el5 #
> 
> reg00: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
> reg01: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> reg03: base=0xbff80000 (3071MB), size=196608MB: uncachable, count=1

so that bios need to be fixed too.

> 
> and in dmesg:
> 
> mtrr: type mismatch for d0000000,1000000 old: uncachable new:
> write-combining
want add one entry for xwindow with your display card.
> 
> 
> Is this a big problem for direct usage? The performance on these servers
> is still fine...?
x window could be some slow.

YH


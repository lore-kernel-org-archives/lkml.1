Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYLOVMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYLOVMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbYLOVMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:12:13 -0500
Received: from static-62-123-141-83.atlanet.it ([62.123.141.83]:54450 "EHLO
	fourier.campana.vi.it" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbYLOVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:12:11 -0500
X-Greylist: delayed 2021 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2008 16:12:09 EST
Message-ID: <4946CEF1.6060405@dei.unipd.it>
Date: Mon, 15 Dec 2008 21:41:05 +0000
From: Ottavio Campana <ottavio.campana@dei.unipd.it>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops when trying to create more than 16000 timers
References: <49468024.1020700@dei.unipd.it> <84144f020812150845g10a1ce26ke2844ab495d2591b@mail.gmail.com>
In-Reply-To: <84144f020812150845g10a1ce26ke2844ab495d2591b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Ottavio,
> 
> On Mon, Dec 15, 2008 at 6:04 PM, Ottavio Campana
> <ottavio.campana@dei.unipd.it> wrote:
>> I am currently developing a software that needs approx 60k timers. I
>> currently use timer_create and all the relative functions to manage timers.
>>
>> I've noticed that after having created 16039 timers I always get an oops
>> from the kernel, which are always of the same kind:
>>
>> Dec 15 15:20:00 evolution kernel: [601680.417064] BUG: unable to handle
>> kernel NULL pointer dereference at 0000000000000040 .
> 
> This would be a kernel bug so can you please post the full oops. See
> REPORTING-BUGS and Documentation/oops-tracing.txt for details.

I hope the report is correct, please tell me if you want me to do
something else.

PGD 7adfc067 PUD 7ad5e067 PMD 0
CPU 1
Modules linked in: ipv6 dm_snapshot dm_mirror dm_log dm_mod loop e1000
snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_timer snd_seq_device
parport_pc psmouse iTCO_wdt snd parport i2c_i801 serio_raw soundcore
i2c_core pcspkr snd_page_alloc evdev button intel_agp dcdbas ext3 jbd
mbcache sg sr_mod cdrom sd_mod ata_piix uhci_hcd ehci_hcd e1000e
ide_pci_generic ide_core ata_generic libata scsi_mod dock thermal
processor fan thermal_sys
Pid: 2743, comm: timer_tester Not tainted 2.6.26-1-amd64 #1
RIP: 0010:[<ffffffff80245291>]  [<ffffffff80245291>]
sys_timer_create+0x79/0x360
RSP: 0018:ffff81007a5ddef8  EFLAGS: 00010286
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000086
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000286
RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000001
R10: 00007f927adb3a50 R11: 0000000000000000 R12: 00000000016ed768
R13: 00000000016ed6d0 R14: 00007fff833dead0 R15: 00000000016ed754
FS:  00007f927b3cd6e0(0000) GS:ffff81007d37a9c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000040 CR3: 000000007b00c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process timer_tester (pid: 2743, threadinfo ffff81007a5dc000, task
ffff81007a7936b0)
Stack:  ffff81007646f9f8 0000000000000000 0000000000000000 ffffffff8029b4ed
  0000000000000000 ffff81007b024c80 0000000000000017 fffffffffffffff7
  00007f927b3da000 ffffffff8029ba36 0000000000000292 0000000000000000
Call Trace:
  [<ffffffff8029b4ed>] vfs_write+0x121/0x156
  [<ffffffff8029ba36>] sys_write+0x60/0x6e
  [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f


Code: c6 0e 05 00 48 85 c0 74 3b 48 89 c5 e8 d0 a0 ff ff 48 85 c0 48 89
45 40 75 11 48 8b 3d e1 22 3e 00 48 89 ee 31 ed e8 fe 10 05 00 <48> 8b
7d 40 31 f6 ba 80 00 00 00 48 83 c7 18 e8 6b ae 0d 00 48
RIP  [<ffffffff80245291>] sys_timer_create+0x79/0x360
 RSP <ffff81007a5ddef8>
CR2: 0000000000000040
 ---[ end trace 2e93d77cdbbd83c6 ]---

Using decodecode

Code: c6 0e 05 00 48 85 c0 74 3b 48 89 c5 e8 d0 a0 ff ff 48 85 c0 48 89
45 40 75 11 48 8b 3d e1 22 3e 00 48 89 ee 31 ed e8 fe 10 05 00 <48> 8b
7d 40 31 f6 ba 80 00 00 00 48 83 c7 18 e8 6b ae 0d 00 48

/tmp/tmp.CcCjFxHOMN.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:	c6                   	(bad)
   1:	0e                   	(bad)
   2:	05 00 48 85 c0       	add    $0xc0854800,%eax
   7:	74 3b                	je     0x44
   9:	48 89 c5             	mov    %rax,%rbp
   c:	e8 d0 a0 ff ff       	callq  0xffffffffffffa0e1
  11:	48 85 c0             	test   %rax,%rax
  14:	48 89 45 40          	mov    %rax,0x40(%rbp)
  18:	75 11                	jne    0x2b
  1a:	48 8b 3d e1 22 3e 00 	mov    0x3e22e1(%rip),%rdi        # 0x3e2302
  21:	48 89 ee             	mov    %rbp,%rsi
  24:	31 ed                	xor    %ebp,%ebp
  26:	e8 fe 10 05 00       	callq  0x51129

/tmp/tmp.CcCjFxHOMN.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
   4:	31 f6                	xor    %esi,%esi
   6:	ba 80 00 00 00       	mov    $0x80,%edx
   b:	48 83 c7 18          	add    $0x18,%rdi
   f:	e8 6b ae 0d 00       	callq  0xdae7f
  14:	48                   	rex.W

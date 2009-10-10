Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbZJJNDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbZJJNDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 09:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761129AbZJJNDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 09:03:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:23127 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761005AbZJJNDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 09:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DwRSzzSjSqFCKJrdeFLOnEerkAfaN66ZGByv+bPRwqbdSfdCSxo1xh2BafQ3MKBbYB
         jEjQH8n5qBR5B5twx+95e65QaJRrSdL8eBAJ/cZKKm0YKTnw4BQXytvHfPazuMqpr8v8
         DppqzEJN3qPGe/ygLkKKAAkHTKB0zpsTjp3Jg=
Date: Sat, 10 Oct 2009 15:01:10 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] GPF in snd_hda_intel
Message-ID: <20091010130110.GA5445@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
with current git kernel (bd381934) I see a GPF when the snd_hda_intel driver is
loaded; the regression is recent, 0eca52a works fine.
The machine is an ASUS laptop (F3Sa), this is the sound card:

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)

The codec is ALC660-VD (snd_hda_codec_realtek). The is the GFP message:

general protection fault: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/wlan0/
CPU 0
Modules linked in: arc4 snd_hda_codec_realtek ecb iwlagn snd_hda_intel(+) usbhid hid btusb snd_hda_codec iwlcore snd_hwdep bluetooth snd_pcm rtc_cmos rtc_core asus_laptop snd_seq snd_timer snd_seq_device snd psmouse mac80211 rtc_lib video soundcore cfg80211 evdev output snd_page_alloc rfkill battery button pcspkr ac processor ext4 mbcache jbd2 crc16 dm_mod sg sr_mod cdrom sd_mod ahci uhci_hcd ata_piix ohci1394 sdhci_pci sdhci mmc_core led_class ieee1394 libata ehci_hcd scsi_mod usbcore intel_agp thermal fan unix [last unloaded: scsi_wait_scan]
Pid: 1027, comm: modprobe Not tainted 2.6.32-rc3-00337-gbd38193 #160 F3Sa    
RIP: 0010:[<ffffffffa033aebd>]  [<ffffffffa033aebd>] snd_hda_sequence_write+0x27/0x34 [snd_hda_codec]
RSP: 0018:ffff88013e0afbe8  EFLAGS: 00010207
RAX: 0000000000000000 RBX: 36434c4100000006 RCX: 000000000000009a
RDX: ffff88013e0afb28 RSI: 36434c4100000006 RDI: ffff88013e259000
RBP: ffff88013e0afbf8 R08: 000000000000005e R09: ffff88013e0af9d8
R10: 0000000000000000 R11: 000000000000d2d0 R12: ffff88013e259000
R13: ffff88013e259000 R14: ffff88013d12c800 R15: ffff88013e0afd08
FS:  00007f423f9086f0(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000061d468 CR3: 000000013e568000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1027, threadinfo ffff88013e0ae000, task ffff88013ddbc290)
Stack:
 0000000000000006 ffff88013d12c830 ffff88013e0afc28 ffffffffa03bc117
<0> ffff88013e259000 0000000000000002 ffff88013dd68258 ffff88013de4f600
<0> ffff88013e0afc48 ffffffffa033aef5 ffff88013dd68258 ffff88013e259000
Call Trace:
 [<ffffffffa03bc117>] alc_init+0x2f8/0x31e [snd_hda_codec_realtek]
 [<ffffffffa033aef5>] snd_hda_codec_build_controls+0x2b/0x4c [snd_hda_codec]
 [<ffffffffa033c8ca>] snd_hda_build_controls+0x23/0x7f [snd_hda_codec]
 [<ffffffffa03899a0>] azx_probe+0x9d9/0xa97 [snd_hda_intel]
 [<ffffffffa0388e10>] ? azx_send_cmd+0x0/0x174 [snd_hda_intel]
 [<ffffffffa0388c19>] ? azx_get_response+0x0/0x1f7 [snd_hda_intel]
 [<ffffffffa0388276>] ? azx_attach_pcm_stream+0x0/0x209 [snd_hda_intel]
 [<ffffffffa0387ec4>] ? azx_bus_reset+0x0/0x79 [snd_hda_intel]
 [<ffffffffa0387d28>] ? azx_power_notify+0x0/0x5d [snd_hda_intel]
 [<ffffffff811829f3>] local_pci_probe+0x12/0x16
 [<ffffffff811836b9>] pci_device_probe+0x5f/0x89
 [<ffffffff81207f68>] ? driver_sysfs_add+0x4c/0x72
 [<ffffffff812080b4>] driver_probe_device+0xad/0x15f
 [<ffffffff812081be>] __driver_attach+0x58/0x7b
 [<ffffffff81208166>] ? __driver_attach+0x0/0x7b
 [<ffffffff81207893>] bus_for_each_dev+0x4e/0x84
 [<ffffffff81207f1a>] driver_attach+0x1c/0x1e
 [<ffffffff81207205>] bus_add_driver+0x126/0x26f
 [<ffffffff812084b2>] driver_register+0xb3/0x121
 [<ffffffffa038f000>] ? alsa_card_azx_init+0x0/0x20 [snd_hda_intel]
 [<ffffffff811838fe>] __pci_register_driver+0x51/0xbc
 [<ffffffffa038f000>] ? alsa_card_azx_init+0x0/0x20 [snd_hda_intel]
 [<ffffffffa038f01e>] alsa_card_azx_init+0x1e/0x20 [snd_hda_intel]
 [<ffffffff81009060>] do_one_initcall+0x5a/0x14a
 [<ffffffff8107270a>] sys_init_module+0xd0/0x229
 [<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
Code: 31 c0 c9 c3 55 48 89 e5 41 54 49 89 fc 53 48 89 f3 eb 18 8b 4b 04 44 8b 43 08 0f b7 f0 31 d2 4c 89 e7 48 83 c3 0c e8 ce f4 ff ff <66> 8b 03 66 85 c0 75 e0 5b 41 5c c9 c3 55 48 89 e5 53 48 89 fb
RIP  [<ffffffffa033aebd>] snd_hda_sequence_write+0x27/0x34 [snd_hda_codec]
 RSP <ffff88013e0afbe8>
---[ end trace 91ec1e9b500145fa ]---

The disassembly:
1e96:       55                      push   %rbp
1e97:       48 89 e5                mov    %rsp,%rbp
1e9a:       41 54                   push   %r12
1e9c:       49 89 fc                mov    %rdi,%r12
1e9f:       53                      push   %rbx
1ea0:       48 89 f3                mov    %rsi,%rbx
1ea3:       eb 18                   jmp    1ebd <snd_hda_sequence_write+0x27>
1ea5:       8b 4b 04                mov    0x4(%rbx),%ecx
1ea8:       44 8b 43 08             mov    0x8(%rbx),%r8d
1eac:       0f b7 f0                movzwl %ax,%esi
1eaf:       31 d2                   xor    %edx,%edx
1eb1:       4c 89 e7                mov    %r12,%rdi
1eb4:       48 83 c3 0c             add    $0xc,%rbx
1eb8:       e8 00 00 00 00          callq  1ebd <snd_hda_sequence_write+0x27>
1ebd:       66 8b 03                mov    (%rbx),%ax <-- fault here
1ec0:       66 85 c0                test   %ax,%ax
1ec3:       75 e0                   jne    1ea5 <snd_hda_sequence_write+0xf>
1ec5:       5b                      pop    %rbx
1ec6:       41 5c                   pop    %r12
1ec8:       c9                      leaveq
1ec9:       c3                      retq


Luca

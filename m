Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYFLUwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYFLUwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYFLUvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:51:52 -0400
Received: from web53709.mail.re2.yahoo.com ([206.190.37.30]:42702 "HELO
	web53709.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754689AbYFLUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:51:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=NIbuPveT8aJciRuklfGt/gZehyUqLWtrkovAFomUYE5Cu+1GlBDFOYgouCzhZ2RSB5yAADqmOGwAki3lzWg8thQXfanpK0tVecNYH6lW66SHJ/7ignmeaDV6czzIDREk7Wd3+tp7x7VTfrGC3E9+dMM95qpj6hNplhDp73nsPXs=;
X-YMail-OSG: k99M_cEVM1lfKHOeVj6jTiQ2A8RFR7r9YskRgI_D8bhf9cfj3J2lQ0kNBZ82fFHxQFEOYpH3dKWgilx3UCcnCBJPhnZeA4pvvA--
Date: Thu, 12 Jun 2008 13:51:48 -0700 (PDT)
From: Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: Re: 2.6.26-rc5-mm3 reproducible BUG and build failures
To: linux-kernel@vger.kernel.org
Cc: benjkidwell@yahoo.com
In-Reply-To: <314477.88718.qm@web53707.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <24548.95429.qm@web53709.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

<horribly botched cut&paste job snipped>

Ugh, sorry, didn't mean to paste the same dmesg and kernel BUG twice. Here's
the BUG report from 2nd boot cycle, basically identical to the 1st I think:

[   33.020043] ------------[ cut here ]------------
[   33.020043] Kernel BUG at c0141256 [verbose debug info unavailable]
[   33.020043] invalid opcode: 0000 [#1] SMP 
[   33.020043] last sysfs file:
/sys/devices/pci0000:00/0000:00:14.4/0000:01:03.0/resource
[   33.020043] Modules linked in: ipv6 sbs sbshc container battery
iptable_filter ip_tables x_tables ac loop af_packet snd_hda_intel serio_raw
snd_pcm snd_timer psmouse snd soundcore snd_page_alloc i2c_piix4 ati_agp
i2c_core agpgart button evdev ext3 jbd mbcache sd_mod ide_cd_mod cdrom usbhid
hid pata_atiixp sata_sil pata_acpi 8139too 8139cp mii atiixp ata_generic
ehci_hcd ohci_hcd libata scsi_mod usbcore dock ide_pci_generic ide_core
thermal processor fan fuse
[   33.020043] 
[   33.020043] Pid: 5390, comm: aplay Not tainted (2.6.26-rc5-mm3mmtry #1)
[   33.020043] EIP: 0060:[<c0141256>] EFLAGS: 00010246 CPU: 0
[   33.020043] EIP is at unlock_page+0xe/0x23
[   33.020043] EAX: 00000000 EBX: c14aee60 ECX: 00000000 EDX: c14aee60
[   33.020043] ESI: 00000001 EDI: c14aee60 EBP: eeec67e8 ESP: ee90adec
[   33.020043]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   33.020043] Process aplay (pid: 5390, ti=ee90a000 task=eee9f960
task.ti=ee90a000)
[   33.020043] Stack: 00000000 c0149c37 0000000e 00004082 c0131baf 00000000
00000000 00000000 
[   33.020043]        ffffffff 0000000e 00000000 c14aee60 c14aee80 c14aeea0
c14aeec0 c14aeee0 
[   33.020043]        c14aef00 c14aef20 c14aef40 c14aef60 c14aef80 c14aefa0
c14aefc0 c14aefe0 
[   33.020043] Call Trace:
[   33.020043]  [<c0149c37>] truncate_inode_pages_range+0xc4/0x336
[   33.020043]  [<c0131baf>] getnstimeofday+0x37/0xdf
[   33.020043]  [<c015d5c7>] shmem_delete_inode+0x0/0xb6
[   33.020043]  [<c0149ec0>] truncate_inode_pages+0x17/0x27
[   33.020043]  [<c015d60f>] shmem_delete_inode+0x48/0xb6
[   33.020043]  [<c015d5c7>] shmem_delete_inode+0x0/0xb6
[   33.020043]  [<c0172fc1>] generic_delete_inode+0x7f/0x100
[   33.020043]  [<c01726c4>] iput+0x44/0x4a
[   33.020043]  [<c017069a>] d_kill+0x2b/0x44
[   33.020043]  [<c01717d6>] dput+0xc3/0x16f
[   33.020043]  [<c016237d>] __fput+0x117/0x16f
[   33.020043]  [<c01a373c>] shm_destroy+0x36/0x3e
[   33.020043]  [<c01a43e1>] sys_shmctl+0x60b/0x61e
[   33.020043]  [<c01764a7>] mnt_drop_write+0x1d/0xd4
[   33.020043]  [<c01a364f>] sys_shmdt+0x10f/0x139
[   33.020043]  [<c0106799>] sys_ipc+0x42/0x28e
[   33.020043]  [<c01535e6>] sys_munmap+0x30/0x35
[   33.020043]  [<c0102de1>] sysenter_past_esp+0x6a/0x91
[   33.020043]  [<c0280000>] setup_local_APIC+0x3f/0x1aa
[   33.020043]  =======================
[   33.020043] Code: 74 09 8b 52 08 85 d2 74 02 ff d2 e8 37 0d 14 00 31 c0 8d
76 00 c3 ba a0 fa 2f c0 eb de 53 89 c3 f0 0f ba 30 00 19 c0 85 c0 75 04 <0f>
0b eb fe 89 d8 e8 7f f4 ff ff 31 c9 89 da 5b e9 9e b8 fe ff 
[   33.020043] EIP: [<c0141256>] unlock_page+0xe/0x23 SS:ESP 0068:ee90adec
[   33.020043] ---[ end trace 516df9d441a65b28 ]---



      

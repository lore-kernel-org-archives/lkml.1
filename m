Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbZKBUa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbZKBUa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407AbZKBUa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:30:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:56779 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbZKBUa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:30:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=IFEWO8n/Jl0BUIi2thqlDtPf0NOpM0xcwNkYLq/aYlW5Rns7E+HeRWKogDE/EBRlDR
         7yfu7iVF8ynyt/j+ZpHvYgf77+GjkanFd+rIjnP6CTemzIEH0ZgUoFxAOGBQcmRZiZbn
         r0hGkGBPL2QhIw5ctfh6Uj6aVEHvelokffSKc=
Message-ID: <4AEF4181.9080100@gmail.com>
Date: Mon, 02 Nov 2009 22:30:57 +0200
From: Todor Gyumyushev <yodor1@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at mm/highmem.c:259
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello I got this recently

Nov  2 22:21:52 macmini kernel: [   50.576427] ------------[ cut here 
]------------
Nov  2 22:21:52 macmini kernel: [   50.576543] kernel BUG at 
mm/highmem.c:259!
Nov  2 22:21:52 macmini kernel: [   50.576622] invalid opcode: 0000 [#1] 
SMP
Nov  2 22:21:52 macmini kernel: [   50.576785] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:1/0:0:1:0/block/sda/size
Nov  2 22:21:52 macmini kernel: [   50.576902] Modules linked in: sr_mod 
cdrom btusb bluetooth usblp arc4 ecb rt73usb usb_storage crc_itu_t 
rt2x00usb rt2x00lib led_class input_polldev mac80211 fuse 
snd_hda_codec_idt intel_agp video agpgart snd_hda_intel backlight 
snd_hda_codec snd_hwdep snd_pcm snd_timer output iTCO_wdt evdev uhci_hcd 
snd_page_alloc iTCO_vendor_support sky2 ehci_hcd tpm_infineon tpm 
tpm_bios sg rtc_cmos rtc_core rtc_lib
Nov  2 22:21:52 macmini kernel: [   50.578349]
Nov  2 22:21:52 macmini kernel: [   50.578349] Pid: 1446, comm: dd Not 
tainted (2.6.31.5 #1) Macmini1,1
Nov  2 22:21:52 macmini kernel: [   50.578349] EIP: 0060:[<c108c9f1>] 
EFLAGS: 00010246 CPU: 0
Nov  2 22:21:52 macmini kernel: [   50.578349] EIP is at 
kunmap_high+0xa1/0xb0
Nov  2 22:21:52 macmini kernel: [   50.578349] EAX: 00000000 EBX: 
ffa6f000 ECX: 00000000 EDX: 00000000
Nov  2 22:21:52 macmini kernel: [   50.578349] ESI: 00000000 EDI: 
ffa6f000 EBP: f621be34 ESP: f621be18
Nov  2 22:21:52 macmini kernel: [   50.578349]  DS: 007b ES: 007b FS: 
00d8 GS: 00e0 SS: 0068
Nov  2 22:21:52 macmini kernel: [   50.578349] Process dd (pid: 1446, 
ti=f621b000 task=f6c65800 task.ti=f621b000)
Nov  2 22:21:52 macmini kernel: [   50.578349] Stack:
Nov  2 22:21:52 macmini kernel: [   50.578349]  0000001c 987dfcac 
0000001c f82d77e9 013da5c0 f6f68380 ffa6f000 f6c54000
Nov  2 22:21:52 macmini kernel: [   50.578349] <0> 00000001 0000001c 
00000000 987dfcac 00000001 00000000 0000001c 00000001
Nov  2 22:21:52 macmini kernel: [   50.578349] <0> f82d7cac 0000001c 
00000001 f621be94 00000000 00000001 f6f68380 00001000
Nov  2 22:21:52 macmini kernel: [   50.578349] Call Trace:
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<f82d77e9>] ? 
fuse_ioctl_copy_user+0xe9/0x120 [fuse]
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<f82d7cac>] ? 
fuse_do_ioctl+0x48c/0x4c0 [fuse]
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<f82d7dfd>] ? 
fuse_file_ioctl+0x1d/0x40 [fuse]
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<f82d7de0>] ? 
fuse_file_ioctl+0x0/0x40 [fuse]
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<c10b9e82>] ? 
vfs_ioctl+0x22/0xa0
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<c10ba0a1>] ? 
do_vfs_ioctl+0x81/0x5e0
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<c109061e>] ? 
handle_mm_fault+0x83e/0xa20
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<c105a3d6>] ? 
getnstimeofday+0x56/0x120
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<c10ba64d>] ? 
sys_ioctl+0x4d/0x90
Nov  2 22:21:52 macmini kernel: [   50.578349]  [<c100324f>] ? 
sysenter_do_call+0x12/0x26
Nov  2 22:21:52 macmini kernel: [   50.578349] Code: 04 24 00 00 00 00 
b9 01 00 00 00 ba 03 00 00 00 b8 c8 f9 39 c1 e8 30 d6 f9 ff 8b 44 24 04 
65 33 05 14 00 00 00 75 08 59 5b 5b c3 <0f> 0b eb fe e8 16 b8 fa ff 8d 
b6 00 00 00 00 55 57 56 53 31 db
Nov  2 22:21:52 macmini kernel: [   50.578349] EIP: [<c108c9f1>] 
kunmap_high+0xa1/0xb0 SS:ESP 0068:f621be18
Nov  2 22:21:52 macmini kernel: [   50.585117] ---[ end trace 
0fd8c0da365d38aa ]---

Regards,
Todor


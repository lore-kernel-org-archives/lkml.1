Return-Path: <linux-kernel-owner+w=401wt.eu-S966054AbXEHI5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966054AbXEHI5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965760AbXEHI5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:57:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:37113 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736AbXEHI5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:57:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=f3m9KpRRPPLD8IKW8+nsfffToX9jHamB5BeVpscjCify2MSwYiuGwImf/vyha0iJevJpM5Vkh22V7nTE9c6Jl+FYhhPBYBUnJdvLSdmceqpLWFUJ8nbnex559u4WOzEBaj2iHE/LwCh/l39t23EjM2tMMQVPpKiQmmjWW3dxA3s=
Message-ID: <46403B7F.1050009@gmail.com>
Date: Tue, 08 May 2007 10:57:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
CC: linux-pm@lists.linux-foundation.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: 2.6.21-mm1 hwsusp: BUG at workqueue.c:106
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this occured in dmesg during resuming from hwsusp in 2.6.21-mm1 (captured
through netconsole). Perfectly reproducible, it simply happens each time I
try it.

usb_endpoint usbdev5.1_ep00: PM: resume from 0, parent usb5 still 2
------------[ cut here ]------------
kernel BUG at /home/l/latest/xxx/kernel/workqueue.c:106!
invalid opcode: 0000 [#1]
SMP
Modules linked in: ipv6 floppy ohci1394 ieee1394 parport_pc parport usbhid
ehci_hcd pata_acpi ff_memless sr_mod cdrom
CPU:    1
EIP:    0060:[<c0132161>]    Not tainted VLI
EFLAGS: 00010046   (2.6.21-mm1 #272)
EIP is at insert_work+0x6d/0x71
eax: c1c3b3c0   ebx: c1814aa0   ecx: 00000001   edx: c1814aa0
esi: c1c3b340   edi: 00000282   ebp: c04d2f68   esp: c04d2f50
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c04d2000 task=c1c26030 task.ti=c1c20000)
Stack: c4685f54 c18148ac c04d2f98 c013816f c1c3b340 c1814aa0 c04d2f88 c013256c
       00000066 c1814880 c1c5e000 c04d2fc4 c01325a1
c1c5e000 00000100 c012ba35 00000000 c04d2fb8 c01333f4 Call Trace:
 [<c0104f27>]  [<c0104fe2>] show_stack_log_lvl+0xa5/0xca
show_registers+0x1e2/0x2da
 [<c01053f5>]  [<c010559a>] do_trap+0x84/0xaa
do_invalid_op+0x88/0x92
 [<c0378662>]  [<c013256c>] __queue_work+0x22/0x33
delayed_work_timer_fn+0x24/0x2a
 [<c012ba35>]  [<c01288a9>] __do_softirq+0x75/0xe6
do_softirq+0x63/0xac
 [<c0128713>]  [<c0116d7e>] smp_apic_timer_interrupt+0x5c/0x88
apic_timer_interrupt+0x28/0x30
 [<c010238d>]  [<c0115ad0>] start_secondary+0x25e/0x37a
0x0
 =======================
00 00 ba 03 00 00 40 a3 ff 83 10 5b 5d c3 4e 04 56 04 43 04 42 04 53 04 48
04 46 04 c9 <0f> eb fe 89 e5 ec 0c

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E


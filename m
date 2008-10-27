Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYJ0JEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYJ0JEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYJ0JEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:04:35 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3336 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYJ0JEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:04:34 -0400
Date: Mon, 27 Oct 2008 10:04:27 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.26] OOPS in elv_next_request
Message-ID: <20081027090426.GN8318@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Sat Oct 25 11:44:16 CEST 2008
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running my http://vanheusden.com/pyk/ script (which randomly
inserts and removes modules) I triggered the folllowing oops in a 2.6.26
kernel on a Celeron 400 (Mendocino):

[ 4768.664021] Floppy drive(s): fd0 is 1.44M
[ 4768.682751] FDC 0 is a post-1991 82077
[ 4768.717031] work still pending
[ 4768.718486] BUG: unable to handle kernel NULL pointer dereference at 00000010
[ 4768.718711] IP: [<c01d073f>] elv_next_request+0x17e/0x18e
[ 4768.718898] *pde = 00000000
[ 4768.719035] Oops: 0000 [#1] SMP
[ 4768.719210] Modules linked in: floppy(-) pcspkr gspca shpchp cdrom battery ata_generic libata pci_hotplug gameport snd_rawmidi parport hwmon_vid scsi_mod videodev v4l1_compat dock ipv6 loop snd_seq_device snd_timer snd soundcore via_agp agpgart evdev ext3 jbd mbcache ide_disk via82cxxx ide_pci_generic ide_core 8139too usbcore 8139cp mii processor thermal_sys [last unloaded: floppy]
[ 4768.720058]
[ 4768.720058] Pid: 6, comm: events/0 Not tainted (2.6.26-1-686 #1)
[ 4768.720058] EIP: 0060:[<c01d073f>] EFLAGS: 00010046 CPU: 0
[ 4768.720058] EIP is at elv_next_request+0x17e/0x18e
[ 4768.720058] EAX: c872c078 EBX: c940a820 ECX: 00000000 EDX: 00000000
[ 4768.720058] ESI: c872c078 EDI: ca964f48 EBP: 00000000 ESP: c943ff50
[ 4768.720058]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 4768.720058] Process events/0 (pid: 6, ti=c943e000 task=c942a460 task.ti=c943e000)
[ 4768.720058] Stack: c940a820 c940a820 ca96b494 ca964f48 ca964f91 c58ce5c0 c942a460 c02b7ec7
[ 4768.720058]        c9443500 4bcc15bb 00000456 c942a5ec c1148fa0 00000000 c940a820 ca96b494
[ 4768.720058]        000018e7 00000000 c940a820 ca96b494 ca964f48 00000000 c012edee c940a820
[ 4768.720058] Call Trace:
[ 4768.720058]  [<ca964f48>] redo_fd_request+0x0/0xc5d [floppy]
[ 4768.720058]  [<ca964f91>] redo_fd_request+0x49/0xc5d [floppy]
[ 4768.720058]  [<c02b7ec7>] schedule+0x63d/0x66f
[ 4768.720058]  [<ca964f48>] redo_fd_request+0x0/0xc5d [floppy]
[ 4768.720058]  [<c012edee>] run_workqueue+0x74/0xf2
[ 4768.720058]  [<c012f4c9>] worker_thread+0x0/0xbd
[ 4768.720058]  [<c012f57c>] worker_thread+0xb3/0xbd
[ 4768.720058]  [<c013177c>] autoremove_wake_function+0x0/0x2d
[ 4768.720058]  [<c01316bb>] kthread+0x38/0x5d
[ 4768.720058]  [<c0131683>] kthread+0x0/0x5d
[ 4768.720058]  [<c01044f3>] kernel_thread_helper+0x7/0x10
[ 4768.720058]  =======================
[ 4768.720058] Code: 06 89 e2 89 04 24 89 f0 e8 a9 37 00 00 85 c0 74 0d 8b 1c 24 85 db 0f 85 9e fe ff ff eb 16 39 36 75 dd 8b 46 0c 31 d2 8b 08 89 f0 <ff> 51 10 85 c0 75 ec 31 db 5f 89 d8 5b 5e 5f c3 55 89 cd 57 89
[ 4768.720058] EIP: [<c01d073f>] elv_next_request+0x17e/0x18e SS:ESP 0068:c943ff50
[ 4768.720058] ---[ end trace 6a50caff78c47574 ]---
[ 4769.658313] Floppy drive(s): fd0 is 1.44M
[ 4789.656060] no cont in shutdown!


Folkert van Heusden

-- 
MultiTail è uno flexible tool per seguire di logfiles e effettuazione
di commissioni. Feltrare, provedere da colore, merge, 'diff-view',
etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

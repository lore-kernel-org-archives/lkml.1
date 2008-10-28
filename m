Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbYJ1FLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbYJ1FLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYJ1FLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:11:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:6939 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbYJ1FLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=f4ZOq2X9Z2hJuzpKy5lngwa2sFyLnVHwrT7hy/ds1h4ssIVHjA+bwj+YrmBzg8BJQT
         fAqKFvcNvZ6t9UMnmxkd6kp3lWHBkkKe+DL1fjoBZbDoS3Aj2Bbzg6p/EjKgHAakh8vi
         GtQQh01VLmvaczG5A92uUWY5y/BryOIU63smY=
Message-ID: <a8e1da0810272211s4b145bboef26801c3af0d652@mail.gmail.com>
Date: Tue, 28 Oct 2008 13:11:30 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Folkert van Heusden" <folkert@vanheusden.com>
Subject: Re: [2.6.26] OOPS in elv_next_request
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081027090426.GN8318@vanheusden.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_38935_17913.1225170690934"
References: <20081027090426.GN8318@vanheusden.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_38935_17913.1225170690934
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Oct 27, 2008 at 5:04 PM, Folkert van Heusden
<folkert@vanheusden.com> wrote:
> Hi,
>
> While running my http://vanheusden.com/pyk/ script (which randomly
> inserts and removes modules) I triggered the folllowing oops in a 2.6.26
> kernel on a Celeron 400 (Mendocino):
>
> [ 4768.664021] Floppy drive(s): fd0 is 1.44M
> [ 4768.682751] FDC 0 is a post-1991 82077
> [ 4768.717031] work still pending
> [ 4768.718486] BUG: unable to handle kernel NULL pointer dereference at 00000010
> [ 4768.718711] IP: [<c01d073f>] elv_next_request+0x17e/0x18e
> [ 4768.718898] *pde = 00000000
> [ 4768.719035] Oops: 0000 [#1] SMP
> [ 4768.719210] Modules linked in: floppy(-) pcspkr gspca shpchp cdrom battery ata_generic libata pci_hotplug gameport snd_rawmidi parport hwmon_vid scsi_mod videodev v4l1_compat dock ipv6 loop snd_seq_device snd_timer snd soundcore via_agp agpgart evdev ext3 jbd mbcache ide_disk via82cxxx ide_pci_generic ide_core 8139too usbcore 8139cp mii processor thermal_sys [last unloaded: floppy]
> [ 4768.720058]
> [ 4768.720058] Pid: 6, comm: events/0 Not tainted (2.6.26-1-686 #1)
> [ 4768.720058] EIP: 0060:[<c01d073f>] EFLAGS: 00010046 CPU: 0
> [ 4768.720058] EIP is at elv_next_request+0x17e/0x18e
> [ 4768.720058] EAX: c872c078 EBX: c940a820 ECX: 00000000 EDX: 00000000
> [ 4768.720058] ESI: c872c078 EDI: ca964f48 EBP: 00000000 ESP: c943ff50
> [ 4768.720058]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [ 4768.720058] Process events/0 (pid: 6, ti=c943e000 task=c942a460 task.ti=c943e000)
> [ 4768.720058] Stack: c940a820 c940a820 ca96b494 ca964f48 ca964f91 c58ce5c0 c942a460 c02b7ec7
> [ 4768.720058]        c9443500 4bcc15bb 00000456 c942a5ec c1148fa0 00000000 c940a820 ca96b494
> [ 4768.720058]        000018e7 00000000 c940a820 ca96b494 ca964f48 00000000 c012edee c940a820
> [ 4768.720058] Call Trace:
> [ 4768.720058]  [<ca964f48>] redo_fd_request+0x0/0xc5d [floppy]
> [ 4768.720058]  [<ca964f91>] redo_fd_request+0x49/0xc5d [floppy]
> [ 4768.720058]  [<c02b7ec7>] schedule+0x63d/0x66f
> [ 4768.720058]  [<ca964f48>] redo_fd_request+0x0/0xc5d [floppy]
> [ 4768.720058]  [<c012edee>] run_workqueue+0x74/0xf2
> [ 4768.720058]  [<c012f4c9>] worker_thread+0x0/0xbd
> [ 4768.720058]  [<c012f57c>] worker_thread+0xb3/0xbd
> [ 4768.720058]  [<c013177c>] autoremove_wake_function+0x0/0x2d
> [ 4768.720058]  [<c01316bb>] kthread+0x38/0x5d
> [ 4768.720058]  [<c0131683>] kthread+0x0/0x5d
> [ 4768.720058]  [<c01044f3>] kernel_thread_helper+0x7/0x10
> [ 4768.720058]  =======================
> [ 4768.720058] Code: 06 89 e2 89 04 24 89 f0 e8 a9 37 00 00 85 c0 74 0d 8b 1c 24 85 db 0f 85 9e fe ff ff eb 16 39 36 75 dd 8b 46 0c 31 d2 8b 08 89 f0 <ff> 51 10 85 c0 75 ec 31 db 5f 89 d8 5b 5e 5f c3 55 89 cd 57 89
> [ 4768.720058] EIP: [<c01d073f>] elv_next_request+0x17e/0x18e SS:ESP 0068:c943ff50
> [ 4768.720058] ---[ end trace 6a50caff78c47574 ]---
> [ 4769.658313] Floppy drive(s): fd0 is 1.44M
> [ 4789.656060] no cont in shutdown!
>
>

Hi, could you try the attached test patch?  sorry for using attachment
as there's some problem for my mail client to reply.

-- 
Regards
dave

------=_Part_38935_17913.1225170690934
Content-Type: application/octet-stream;
 name=floppy_flush_workqueue_before_release.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fmu2yikq0
Content-Disposition: attachment;
 filename=floppy_flush_workqueue_before_release.patch

LS0tIGxpbnV4LTIuNi4yNy5vcmlnL2RyaXZlcnMvYmxvY2svZmxvcHB5LmMJMjAwOC0xMC0xMCAw
NjoxMzo1My4wMDAwMDAwMDAgKzA4MDAKKysrIGxpbnV4LTIuNi4yNy9kcml2ZXJzL2Jsb2NrL2Zs
b3BweS5jCTIwMDgtMTAtMjggMTM6MDU6NDUuMDAwMDAwMDAwICswODAwCkBAIC00NTU3LDYgKzQ1
NTcsNyBAQAogCWRlbF90aW1lcl9zeW5jKCZmZF90aW1lcik7CiAJYmxrX2NsZWFudXBfcXVldWUo
ZmxvcHB5X3F1ZXVlKTsKIAorCWZsdXNoX3NjaGVkdWxlZF93b3JrKCk7CiAJaWYgKHVzYWdlX2Nv
dW50KQogCQlmbG9wcHlfcmVsZWFzZV9pcnFfYW5kX2RtYSgpOwogCg==
------=_Part_38935_17913.1225170690934--

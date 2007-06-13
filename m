Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbXFMIdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbXFMIdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbXFMIdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:33:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:5596 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbXFMIdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CTZat3pdIE0q6hkTPcjXoxgYs9Qd77y11IoG626hjGFFPDoc1yOw3yRi8zehTKJMT3JFjkBfDfC5qO8S57e0kuNOAyQ+NQ4Foz79Z+OlqpLmNTkqjP80xe8ri8erJQTz+8hFEL4UHVl8lClcJLUwE+ZSE5dF/Ino0Vl9/vdIP7I=
Message-ID: <466FABDD.1050807@gmail.com>
Date: Wed, 13 Jun 2007 10:33:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, mdharm-usb@one-eyed-alien.net,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       linux-usb-devel@lists.sourceforge.net
Subject: WARNING: at drivers/usb/core/urb.c:293 usb_submit_urb() [Was: 2.6.22-rc4-mm2]
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/

Hi,

after plugging my camera in, I get this:
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: new device found, idVendor=07b4, idProduct=0105
usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: C765UZ
usb 1-1: Manufacturer: OLYMPUS
usb 1-1: SerialNumber: 000375531837
usb 1-1: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi7 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
WARNING: at /home/l/latest/xxx/drivers/usb/core/urb.c:293 usb_submit_urb()
 [<c010516a>] dump_trace+0x1d8/0x207
 [<c01051b3>] show_trace_log_lvl+0x1a/0x30
 [<c0105db9>] show_trace+0x12/0x14
 [<c0105dd1>] dump_stack+0x16/0x18
 [<c0284034>] usb_submit_urb+0x1ea/0x200
 [<c02857fe>] usb_sg_wait+0xba/0x14e
 [<f8985098>] usb_stor_bulk_transfer_sg+0x99/0xe3 [usb_storage]
 [<f89854cc>] usb_stor_Bulk_transport+0x127/0x277 [usb_storage]
 [<f8985637>] usb_stor_invoke_transport+0x1b/0x2f4 [usb_storage]
 [<f89848b9>] usb_stor_transparent_scsi_command+0x8/0xa [usb_storage]
 [<f8986354>] usb_stor_control_thread+0x130/0x195 [usb_storage]
 [<c0136d07>] kthread+0x37/0x59
 [<c0104bfb>] kernel_thread_helper+0x7/0x1c
 =======================





It's not usable, some threads end up in D state. Relevant part of sysrq-t:
scsi_eh_7     D 0080027D     0 23842      2 (L-TLB)
       c2e52f34 00000046 45ad4b85 0080027d c2e52f1c 00000000 c3e88230 45ad46cf
       0080027d c012262a c3e88230 c3e883b8 c180b980 486cfe61 0000027d c037487f
       c2e52f74 00000046 d560826b 0080027a c011c00f c2cecac0 c0545080 c0545080
Call Trace:
 [<c0374f8d>] wait_for_completion+0x87/0xbc
 [<f898462e>] command_abort+0x58/0x74 [usb_storage]
 [<c0263be3>] __scsi_try_to_abort_cmd+0x1c/0x1e
 [<c0264f10>] scsi_error_handler+0x241/0x2bf
 [<c0136d07>] kthread+0x37/0x59
 [<c0104bfb>] kernel_thread_helper+0x7/0x1c
 =======================
usb-storage   D 0080027B     0 23843      2 (L-TLB)
       c2f76e94 00000046 fecf46f3 0080027b c2f76e7c 00000000 00000000 fecf4091
       0080027b c012262a c3e89870 c3e899f8 c180b980 018ef9cf 0000027c c1ce9c00
       c2f76e60 c0125fae c0408a64 c2f76e6c c2f76e6c c1f98e40 c0545080 c0545080
Call Trace:
 [<c0374f8d>] wait_for_completion+0x87/0xbc
 [<c028585a>] usb_sg_wait+0x116/0x14e
 [<f8985098>] usb_stor_bulk_transfer_sg+0x99/0xe3 [usb_storage]
 [<f89854cc>] usb_stor_Bulk_transport+0x127/0x277 [usb_storage]
 [<f8985637>] usb_stor_invoke_transport+0x1b/0x2f4 [usb_storage]
 [<f89848b9>] usb_stor_transparent_scsi_command+0x8/0xa [usb_storage]
 [<f8986354>] usb_stor_control_thread+0x130/0x195 [usb_storage]
 [<c0136d07>] kthread+0x37/0x59
 [<c0104bfb>] kernel_thread_helper+0x7/0x1c
 =======================
usb-stor-scan D 0080027B     0 23844      2 (L-TLB)
       c46fecbc 00000046 febe1f98 0080027b c46feca4 00000000 c46fec68 febe17da
       0080027b c012262a c4345260 c43453e8 c180b980 017dd274 0000027c c43ec000
       c46fec7c c01e2964 c46fec84 c02541f8 c46fecb0 c1f98e40 c0545080 c0545080
Call Trace:
 [<c0374f8d>] wait_for_completion+0x87/0xbc
 [<c01da63d>] blk_execute_rq+0x5a/0x94
 [<c0266479>] scsi_execute+0xc3/0xd7
 [<c02664f3>] scsi_execute_req+0x66/0xc4
 [<c026762f>] scsi_probe_and_add_lun+0x19b/0x891
 [<c0268265>] __scsi_scan_target+0xd3/0x59f
 [<c02687a0>] scsi_scan_channel+0x6f/0x84
 [<c0268818>] scsi_scan_host_selected+0x63/0xd5
 [<c02688f5>] do_scsi_scan_host+0x6b/0x6d
 [<c026897e>] scsi_scan_host+0x87/0x153
 [<f8986416>] usb_stor_scan_thread+0x5d/0x17b [usb_storage]
 [<c0136d07>] kthread+0x37/0x59
 [<c0104bfb>] kernel_thread_helper+0x7/0x1c
 =======================



Are you aware of such problems? Any other info needed?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

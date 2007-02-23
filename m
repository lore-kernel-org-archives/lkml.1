Return-Path: <linux-kernel-owner+w=401wt.eu-S933157AbXBWRYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbXBWRYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965136AbXBWRYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:24:40 -0500
Received: from mail.velocity.net ([66.211.211.55]:38846 "EHLO
	mail.velocity.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157AbXBWRYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:24:39 -0500
X-Greylist: delayed 1451 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 12:24:39 EST
X-AV-Checked: Fri Feb 23 12:00:28 2007 clean
Subject: sata_sil problems with recent kernels
From: Dale Blount <linux-kernel@dale.us>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@dale.us
Content-Type: text/plain
Date: Fri, 23 Feb 2007 12:00:27 -0500
Message-Id: <1172250027.15179.16.camel@dale.velocity.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Excuse me if this has been covered or fixed, I couldn't find anything in
the archives.

I upgraded from 2.6.11.7 to 2.6.20.1 today and found all the drives
connected to 2 brands of sata_sil sata controllers not working.  The
drives are also (now) of various brands, Maxtor 300GB and 500GB
Seagates.

On boot (or after modprobing sata_sil if not configured to load in my
initrd), I get the below messages in dmesg and no drives showing up
in /dev.

There's 4 drives total, and 6 BUGs so I'm a little confused.  One of the
drive (old sdb, which happened to be the first drive on sata_sil
controllers) is known to have bad sectors, but I didn't think it could
cause this... I'm away from the machine currently, so I haven't tested a
single drive to see if it fails also.

I rebooted back into 2.6.11.7 and everything was peachy (minus the known
bad disk).

Any suggestions or hints to more data I could provide to be diagnosed?

Thanks,

Dale

***************

ata3: SATA max UDMA/100 cmd 0xF8848080 ctl 0xF884808A bmdma 0xF8848000
irq 18
ata4: SATA max UDMA/100 cmd 0xF88480C0 ctl 0xF88480CA bmdma 0xF8848008
irq 18
scsi2 : sata_sil
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
BUG: at drivers/ata/libata-core.c:4365 ata_hsm_move()
 [<f882c9ae>] ata_hsm_move+0x1be/0x7d0 [libata]
 [<c033eb42>] schedule_timeout+0x52/0xd0
 [<c0130170>] process_timeout+0x0/0x10
 [<f882fe97>] ata_pio_task+0x27/0x100 [libata]
 [<c01378d3>] run_workqueue+0x93/0x140
 [<f882fe70>] ata_pio_task+0x0/0x100 [libata]
 [<c0138447>] worker_thread+0x147/0x170
 [<c0121360>] default_wake_function+0x0/0x10
 [<c0138300>] worker_thread+0x0/0x170
 [<c013b2eb>] kthread+0xbb/0xf0
 [<c013b230>] kthread+0x0/0xf0
 [<c0103e4f>] kernel_thread_helper+0x7/0x18
 =======================
ata3.00: zero err_mask for failed internal command, assuming
AC_ERR_OTHER
ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
BUG: at drivers/ata/libata-core.c:4365 ata_hsm_move()
 [<f882c9ae>] ata_hsm_move+0x1be/0x7d0 [libata]
 [<c033eb42>] schedule_timeout+0x52/0xd0
 [<c011e519>] __wake_up_common+0x39/0x70
 [<c0130170>] process_timeout+0x0/0x10
 [<f882fe97>] ata_pio_task+0x27/0x100 [libata]
 [<c01378d3>] run_workqueue+0x93/0x140
 [<f882fe70>] ata_pio_task+0x0/0x100 [libata]
 [<c0138447>] worker_thread+0x147/0x170
 [<c0121360>] default_wake_function+0x0/0x10
 [<c0138300>] worker_thread+0x0/0x170
 [<c013b2eb>] kthread+0xbb/0xf0
 [<c013b230>] kthread+0x0/0xf0
 [<c0103e4f>] kernel_thread_helper+0x7/0x18
 =======================
ata3.00: zero err_mask for failed internal command, assuming
AC_ERR_OTHER
ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
BUG: at drivers/ata/libata-core.c:4365 ata_hsm_move()
 [<f882c9ae>] ata_hsm_move+0x1be/0x7d0 [libata]
 [<c033eb42>] schedule_timeout+0x52/0xd0
 [<c011e519>] __wake_up_common+0x39/0x70
 [<c0130170>] process_timeout+0x0/0x10
 [<f882fe97>] ata_pio_task+0x27/0x100 [libata]
 [<c01378d3>] run_workqueue+0x93/0x140
 [<f882fe70>] ata_pio_task+0x0/0x100 [libata]
 [<c0138447>] worker_thread+0x147/0x170
 [<c0121360>] default_wake_function+0x0/0x10
 [<c0138300>] worker_thread+0x0/0x170
 [<c013b2eb>] kthread+0xbb/0xf0
 [<c013b230>] kthread+0x0/0xf0
 [<c0103e4f>] kernel_thread_helper+0x7/0x18
 =======================
ata3.00: zero err_mask for failed internal command, assuming
AC_ERR_OTHER
ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
scsi3 : sata_sil
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
BUG: at drivers/ata/libata-core.c:4365 ata_hsm_move()
 [<f882c9ae>] ata_hsm_move+0x1be/0x7d0 [libata]
 [<c033eb42>] schedule_timeout+0x52/0xd0
 [<c011e519>] __wake_up_common+0x39/0x70
 [<c0130170>] process_timeout+0x0/0x10
 [<f882fe97>] ata_pio_task+0x27/0x100 [libata]
 [<c01378d3>] run_workqueue+0x93/0x140
 [<f882fe70>] ata_pio_task+0x0/0x100 [libata]
 [<c0138447>] worker_thread+0x147/0x170
 [<c0121360>] default_wake_function+0x0/0x10
 [<c0138300>] worker_thread+0x0/0x170
 [<c013b2eb>] kthread+0xbb/0xf0
 [<c013b230>] kthread+0x0/0xf0
 [<c0103e4f>] kernel_thread_helper+0x7/0x18
 =======================
ata4.00: zero err_mask for failed internal command, assuming
AC_ERR_OTHER
ata4.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
BUG: at drivers/ata/libata-core.c:4365 ata_hsm_move()
 [<f882c9ae>] ata_hsm_move+0x1be/0x7d0 [libata]
 [<c033eb42>] schedule_timeout+0x52/0xd0
 [<c011e519>] __wake_up_common+0x39/0x70
 [<c0130170>] process_timeout+0x0/0x10
 [<f882fe97>] ata_pio_task+0x27/0x100 [libata]
 [<c01378d3>] run_workqueue+0x93/0x140
 [<f882fe70>] ata_pio_task+0x0/0x100 [libata]
 [<c0138447>] worker_thread+0x147/0x170
 [<c0121360>] default_wake_function+0x0/0x10
 [<c0138300>] worker_thread+0x0/0x170
 [<c013b2eb>] kthread+0xbb/0xf0
 [<c013b230>] kthread+0x0/0xf0
 [<c0103e4f>] kernel_thread_helper+0x7/0x18
 =======================
ata4.00: zero err_mask for failed internal command, assuming
AC_ERR_OTHER
ata4.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
BUG: at drivers/ata/libata-core.c:4365 ata_hsm_move()
 [<f882c9ae>] ata_hsm_move+0x1be/0x7d0 [libata]
 [<c033eb42>] schedule_timeout+0x52/0xd0
 [<c011e519>] __wake_up_common+0x39/0x70
 [<c0130170>] process_timeout+0x0/0x10
 [<f882fe97>] ata_pio_task+0x27/0x100 [libata]
 [<c01378d3>] run_workqueue+0x93/0x140
 [<f882fe70>] ata_pio_task+0x0/0x100 [libata]
 [<c0138447>] worker_thread+0x147/0x170
 [<c0121360>] default_wake_function+0x0/0x10
 [<c0138300>] worker_thread+0x0/0x170
 [<c013b2eb>] kthread+0xbb/0xf0
 [<c013b230>] kthread+0x0/0xf0
 [<c0103e4f>] kernel_thread_helper+0x7/0x18
 =======================
ata4.00: zero err_mask for failed internal command, assuming
AC_ERR_OTHER
ata4.00: failed to IDENTIFY (I/O error, err_mask=0x100)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)


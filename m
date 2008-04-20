Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYDTKaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYDTKaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYDTK3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:29:54 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:1149 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753690AbYDTK3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ApzHjGJOD8vJz4x3eP5GaNOIpdVDeswbrzrTgG6SEWlkcO5Mevsqo0u8psTjW+ovr71INTPlp1kMYnln4L/f1UQW9FwpToNBTde7qNPk3964UdGr/4dGqt9IA6k/fPxOL3jUSvppjR+T3kGzeDvMQY0WoI+rJweBNgEHiW3ISbM=
Message-ID: <19f34abd0804200329j3308b081vc0732c3ec5c0b721@mail.gmail.com>
Date: Sun, 20 Apr 2008 12:29:52 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: v2.6.25: WARNING: at kernel/lockdep.c:2437 __lock_acquire+0xc69/0xfa0()
Cc: "Tejun Heo" <htejun@gmail.com>, "Jeff Garzik" <jgarzik@pobox.com>,
       "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This appears in clean v2.6.25:

------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2437 __lock_acquire+0xc69/0xfa0()
Pid: 1002, comm: scsi_eh_4 Not tainted 2.6.25 #379
 [<c011bb5c>] warn_on_slowpath+0x3c/0x50
 [<c013b0f9>] ? __lock_acquire+0x219/0xfa0
 [<c013b0f9>] ? __lock_acquire+0x219/0xfa0
 [<c012c2c8>] ? __kernel_text_address+0x8/0x20
 [<c0104fce>] ? dump_trace+0xce/0x120
 [<c010a56c>] ? save_stack_trace+0x1c/0x40
 [<c0138659>] ? save_trace+0x39/0xa0
 [<c013a3d1>] ? mark_lock+0x61/0x540
 [<c013bb49>] __lock_acquire+0xc69/0xfa0
 [<c012b46a>] ? __cancel_work_timer+0x5a/0x140
 [<c01082ac>] ? native_sched_clock+0x5c/0xb0
 [<c013beee>] lock_acquire+0x6e/0x90
 [<c02a8e23>] ? ata_scsi_error+0x33/0x6a0
 [<c02e4946>] _spin_lock_irqsave+0x26/0x60
 [<c02a8e23>] ? ata_scsi_error+0x33/0x6a0
 [<c02a4ee0>] ? ata_bmdma_error_handler+0x0/0x50
 [<c02a8e23>] ata_scsi_error+0x33/0x6a0
 [<c02e249a>] ? schedule+0x27a/0x410
 [<c0256dd1>] ? __scsi_iterate_devices+0x51/0x70
 [<c025c681>] ? scsi_run_host_queues+0x21/0x30
 [<c025ae5e>] scsi_error_handler+0x9e/0x4e0
 [<c02e249a>] ? schedule+0x27a/0x410
 [<c025adc0>] ? scsi_error_handler+0x0/0x4e0
 [<c012dd86>] kthread+0x36/0x60
 [<c012dd50>] ? kthread+0x0/0x60
 [<c0104c27>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 5e5d737e76fd4940 ]---

Full log and config:

http://folk.uio.no/vegardno/linux/log-20080420.txt
http://folk.uio.no/vegardno/linux/config-20080420.txt

(The bootup is from qemu for the ease of harvesting the log -- but it
happens on real hardware too!)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

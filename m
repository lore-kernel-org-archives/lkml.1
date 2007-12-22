Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbXLVR1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbXLVR1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 12:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXLVR1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 12:27:35 -0500
Received: from hancock.steeleye.com ([71.30.118.248]:44520 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267AbXLVR1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 12:27:35 -0500
Subject: Mysterious lockdep warning from the SCSI workqueue code
From: James Bottomley <James.Bottomley@SteelEye.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 11:27:32 -0600
Message-Id: <1198344452.3478.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've no idea why this is occurring:

WARNING: at kernel/lockdep.c:700 look_up_lock_class()
Pid: 2068, comm: scsi_wq_3 Not tainted 2.6.24-rc6 #38
 [<c010535a>] show_trace_log_lvl+0x1a/0x30
 [<c0105ce2>] show_trace+0x12/0x20
 [<c010601c>] dump_stack+0x6c/0x80
 [<c014696d>] __lock_acquire+0x46d/0x10b0
 [<c0147628>] lock_acquire+0x78/0xa0
 [<c0136d18>] run_workqueue+0x128/0x1d0
 [<c013795c>] worker_thread+0x8c/0xf0
 [<c013ab32>] kthread+0x42/0x70
 [<c0104f47>] kernel_thread_helper+0x7/0x10
 =======================

it looks to be happening on the initial workqueue.c:run_workqueue()

	spin_lock_irq(&cwq->lock);

It's caused by lockdep.c:look_up_lock_class()

	WARN_ON_ONCE(class->name != lock->name);

but I'm not entirely sure what this actually means, not fully
understanding lockdep classes and how we acquire them in scsi.

James



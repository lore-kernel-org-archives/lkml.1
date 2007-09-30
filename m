Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbXI3Bqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbXI3Bqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 21:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXI3Bqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 21:46:40 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:14770 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbXI3Bqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 21:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Eu+4gLOJV2jBXYyLIYsUQR9dD/Q/SLO2fgNCZq8PbCyq1mgMD1eKDFqkyYcZXMxZBjoL6hNsyDNn4n3j37fmWJVliFJG01g7GgslOA5ZqV0C8wN5kFKzs1vigb6DST4kDyJSQS052wy8wa4LB24B5QI+pi2kBNPAAwwsoQVZTiI=
Message-ID: <a8e1da0709291846x4abf50c8g32b02a9d40240b6@mail.gmail.com>
Date: Sun, 30 Sep 2007 09:46:38 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: bluetooth: hci_sysfs work queue problem
Cc: bluez-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The hci_sysfs uses work queue to finish the sysfs add/del fuction.
But when the same device connection failed, if another connection of
same device come in before the delete work finish, sysfs will warn
about duplicate filename creating.

Sep 19 12:30:27 darkstar kernel: sysfs: duplicate filename
'acl00194FDB6C71' can not be created
Sep 19 12:30:27 darkstar kernel: WARNING: at fs/sysfs/dir.c:433 sysfs_add_one()
Sep 19 12:30:27 darkstar kernel:  [<c01c3ad0>] sysfs_add_one+0xa0/0xe0
Sep 19 12:30:27 darkstar kernel:  [<c01c3e38>] create_dir+0x48/0xb0
Sep 19 12:30:27 darkstar kernel:  [<c0178df5>] __slab_alloc+0x205/0x250
Sep 19 12:30:27 darkstar kernel:  [<c01c3ee9>] sysfs_create_dir+0x29/0x50
Sep 19 12:30:27 darkstar kernel:  [<c024cf5b>] create_dir+0x1b/0x50
Sep 19 12:30:27 darkstar kernel:  [<c024d226>] kobject_add+0x46/0x150
Sep 19 12:30:27 darkstar kernel:  [<c024d404>] kobject_set_name+0x84/0xf0
Sep 19 12:30:27 darkstar kernel:  [<c02b7035>] device_add+0x95/0x350
Sep 19 12:30:27 darkstar kernel:  [<f88aec60>] add_conn+0x0/0x90 [bluetooth]
Sep 19 12:30:27 darkstar kernel:  [<f88aec6f>] add_conn+0xf/0x90 [bluetooth]
Sep 19 12:30:27 darkstar kernel:  [<c01663d0>] vmstat_update+0x0/0x30
Sep 19 12:30:27 darkstar kernel:  [<c013bdfe>] run_workqueue+0x5e/0x110
Sep 19 12:30:27 darkstar kernel:  [<c013bf5c>] worker_thread+0xac/0x100
Sep 19 12:30:27 darkstar kernel:  [<c0140340>] autoremove_wake_function+0x0/0x50
Sep 19 12:30:27 darkstar kernel:  [<c0140340>] autoremove_wake_function+0x0/0x50
Sep 19 12:30:27 darkstar kernel:  [<c013beb0>] worker_thread+0x0/0x100
Sep 19 12:30:27 darkstar kernel:  [<c013fd49>] kthread+0x59/0xa0
Sep 19 12:30:27 darkstar kernel:  [<c013fcf0>] kthread+0x0/0xa0
Sep 19 12:30:27 darkstar kernel:  [<c0104fb3>] kernel_thread_helper+0x7/0x14
Sep 19 12:30:27 darkstar kernel:  =======================
Sep 19 12:30:27 darkstar kernel: kobject_add failed for
acl00194FDB6C71 with -EEXIST, don't try to register things with the
same name in the same directory.
Sep 19 12:30:27 darkstar kernel:  [<c024d2d6>] kobject_add+0xf6/0x150
Sep 19 12:30:27 darkstar kernel:  [<c02b7035>] device_add+0x95/0x350
Sep 19 12:30:27 darkstar kernel:  [<f88aec60>] add_conn+0x0/0x90 [bluetooth]
Sep 19 12:30:27 darkstar kernel:  [<f88aec6f>] add_conn+0xf/0x90 [bluetooth]
Sep 19 12:30:27 darkstar kernel:  [<c01663d0>] vmstat_update+0x0/0x30
Sep 19 12:30:27 darkstar kernel:  [<c013bdfe>] run_workqueue+0x5e/0x110
Sep 19 12:30:27 darkstar kernel:  [<c013bf5c>] worker_thread+0xac/0x100
Sep 19 12:30:27 darkstar kernel:  [<c0140340>] autoremove_wake_function+0x0/0x50
Sep 19 12:30:27 darkstar kernel:  [<c0140340>] autoremove_wake_function+0x0/0x50
Sep 19 12:30:27 darkstar kernel:  [<c013beb0>] worker_thread+0x0/0x100
Sep 19 12:30:27 darkstar kernel:  [<c013fd49>] kthread+0x59/0xa0
Sep 19 12:30:27 darkstar kernel:  [<c013fcf0>] kthread+0x0/0xa0
Sep 19 12:30:27 darkstar kernel:  [<c0104fb3>] kernel_thread_helper+0x7/0x14
Sep 19 12:30:27 darkstar kernel:  =======================
Sep 19 12:30:27 darkstar kernel: add_conn: Failed to register connection device
Sep 19 12:41:36 darkstar kernel:  [<c0104fb3>] kernel_thread_helper+0x7/0x14

Marcel, how to resolve this problem?  do you have some ideas?

Regards
dave

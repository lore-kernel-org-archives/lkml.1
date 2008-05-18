Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYERXLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYERXLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 19:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYERXLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 19:11:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:49515 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbYERXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 19:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DSU99zk+nzgS+i0v/S07s/2vRERsA60X9YzP7VKJPMX+iwhcZOQ3bMqmu2N7iAtxX7rAYXNjwGvYCypBatPOd9RnBUMlDpKc672ci3OsMWUHD2xPiUQTtTYqvzmQZ/5Zdn4gs1epF0HnM7VExb9gjvoURrpVRdOWux1F2NZx2dg=
Message-ID: <a44ae5cd0805181611g3eb5b351n99dca75283e32ace@mail.gmail.com>
Date: Sun, 18 May 2008 19:11:30 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.26-rc2-mm1 + 2 hotfixes -- possible recursive locking: swapper/1 is trying to acquire lock: (&cls->mutex){--..}, at: [<c02a6564>] device_add+0x3ef/0x4ec
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc2-mm1 #8
---------------------------------------------
swapper/1 is trying to acquire lock:
 (&cls->mutex){--..}, at: [<c02a6564>] device_add+0x3ef/0x4ec

but task is already holding lock:
 (&cls->mutex){--..}, at: [<c02a82e7>] class_for_each_device+0x29/0x95

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (&cls->mutex){--..}, at: [<c02a82e7>] class_for_each_device+0x29/0x95

stack backtrace:
Pid: 1, comm: swapper Not tainted 2.6.26-rc2-mm1 #8
 [<c013e7e8>] __lock_acquire+0x89e/0xbb5
 [<c013d8cb>] ? mark_held_locks+0x4e/0x66
 [<c013da6f>] ? trace_hardirqs_on+0xb/0xd
 [<c013eb4d>] lock_acquire+0x4e/0x6a
 [<c02a6564>] ? device_add+0x3ef/0x4ec
 [<c03b6c80>] mutex_lock_nested+0xc0/0x22a
 [<c02a6564>] ? device_add+0x3ef/0x4ec
 [<c02a6564>] ? device_add+0x3ef/0x4ec
 [<c02a6564>] device_add+0x3ef/0x4ec
 [<c02a5eca>] ? device_initialize+0xd6/0xf7
 [<c02a6673>] device_register+0x12/0x15
 [<c02a66e5>] device_create+0x6f/0x92
 [<c02e1461>] video1394_add_host+0x94/0x9e
 [<c02d8310>] highlevel_for_each_host_reg+0xc/0x3b
 [<c02d9bf4>] __nodemgr_for_each_host+0xf/0x11
 [<c02a8312>] class_for_each_device+0x54/0x95
 [<c02d9be5>] ? __nodemgr_for_each_host+0x0/0x11
 [<c02da83e>] nodemgr_for_each_host+0x1e/0x20
 [<c02d8304>] ? highlevel_for_each_host_reg+0x0/0x3b
 [<c02d8bbb>] hpsb_register_highlevel+0x8f/0x94
 [<c0536c0b>] video1394_init_module+0x48/0x8c
 [<c051a240>] kernel_init+0x128/0x25c
 [<c0102efa>] ? restore_nocheck_notrace+0x0/0xe
 [<c051a118>] ? kernel_init+0x0/0x25c
 [<c051a118>] ? kernel_init+0x0/0x25c
 [<c0103ad3>] kernel_thread_helper+0x7/0x10
 =======================
video1394: Installed video1394 module

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbYAXDDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbYAXDDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 22:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYAXDDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 22:03:00 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:2102 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYAXDC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 22:02:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ettH1x2fCNGi8OvaKLNYlRoPw5E5mphRu3xPxiy6NbwQdC2g60HTXG2QH5fqVY1v7Hv8fR4bRjkJQo03mu/metF7ppe3iiaVXUvn3WNek12/rpEZfS4q18yC17Y5+L6MCeM/0jm0rEwtrdLdy1T1WZ5ikGzLmNj4V/UMrL4kFl4=
Message-ID: <a8e1da0801231902x5ab7691bq5a30e839f6c8cb71@mail.gmail.com>
Date: Thu, 24 Jan 2008 11:02:55 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: bluetooth : lockdep warning on rfcomm
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
       "David Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
       bluez-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=============================================
[ INFO: possible recursive locking detected ]
2.6.24-rc8-mm1 #8
---------------------------------------------
bluepush/3213 is trying to acquire lock:
 (sk_lock-AF_BLUETOOTH){--..}, at: [<f8978c80>]
l2cap_sock_bind+0x40/0x100 [l2cap]

but task is already holding lock:
 (sk_lock-AF_BLUETOOTH){--..}, at: [<f894a31e>]
rfcomm_sock_connect+0x3e/0xe0 [rfcomm]

other info that might help us debug this:
2 locks held by bluepush/3213:
 #0:  (sk_lock-AF_BLUETOOTH){--..}, at: [<f894a31e>]
rfcomm_sock_connect+0x3e/0xe0 [rfcomm]
 #1:  (rfcomm_mutex){--..}, at: [<f8947556>] rfcomm_dlc_open+0x26/0x60 [rfcomm]

stack backtrace:
Pid: 3213, comm: bluepush Not tainted 2.6.24-rc8-mm1 #8
 [<c0132128>] ? printk+0x18/0x20
 [<c0154437>] print_deadlock_bug+0xc7/0xe0
 [<c01544bc>] check_deadlock+0x6c/0x80
 [<c01548fc>] validate_chain+0x14c/0x320
 [<c0156221>] __lock_acquire+0x1c1/0x730
 [<c0156d89>] lock_acquire+0x79/0xb0
 [<f8978c80>] ? l2cap_sock_bind+0x40/0x100 [l2cap]
 [<c03c05f5>] lock_sock_nested+0x55/0x70
 [<f8978c80>] ? l2cap_sock_bind+0x40/0x100 [l2cap]
 [<f8978c80>] l2cap_sock_bind+0x40/0x100 [l2cap]
 [<c03bdb4a>] kernel_bind+0xa/0x10
 [<f8947afc>] rfcomm_session_create+0x4c/0x110 [rfcomm]
 [<f8947509>] __rfcomm_dlc_open+0x129/0x150 [rfcomm]
 [<f8947568>] rfcomm_dlc_open+0x38/0x60 [rfcomm]
 [<f894a396>] rfcomm_sock_connect+0xb6/0xe0 [rfcomm]
 [<c03bcd39>] sys_connect+0x99/0xd0
 [<c010f509>] ? cache_add_dev+0x39/0x1a0
 [<c015323d>] ? put_lock_stats+0xd/0x30
 [<c01532c0>] ? lock_release_holdtime+0x60/0x80
 [<c018e86c>] ? fget+0x7c/0x100
 [<c0156b97>] ? __lock_release+0x47/0x70
 [<c018e86c>] ? fget+0x7c/0x100
 [<c02611b7>] ? copy_from_user+0x37/0x70
 [<c03bd855>] sys_socketcall+0xa5/0x230
 [<c0155659>] ? trace_hardirqs_on+0xb9/0x130
 [<c010501b>] ? restore_nocheck+0x12/0x15

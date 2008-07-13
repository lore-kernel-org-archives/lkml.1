Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYGMKcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYGMKcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 06:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYGMKc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 06:32:26 -0400
Received: from nn7.de ([85.214.94.156]:44775 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYGMKcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 06:32:25 -0400
Subject: 2.6.26rc9+git bluetooth/rfcomm oops
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jul 2008 12:32:05 +0200
Message-Id: <1215945125.4842.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this oops happened after a couple of s2ram cycles so it might be very
well crap. However I somehow triggered it by /etc/init.d/bluetooth
stop/start's which also call hid2hci maybe even a connection was about
to be established at that time. As I remember having seen a problem like
this before I thought I report it (even though I have a madwifi tainted
kernel).

[drm] Num pipes: 1
kobject_add_internal failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 22041, comm: rfcomm Tainted: P          2.6.26-rc9-sonne #39
 [<c026be97>] kobject_add_internal+0xf7/0x1a0
 [<c0273123>] ? kvasprintf+0x43/0x60
 [<c026bfcb>] kobject_add_varg+0x3b/0x70
 [<c026c05c>] kobject_add+0x2c/0x60
 [<c02efb0f>] device_add+0x8f/0x490
 [<c0270990>] ? vsnprintf+0x3a0/0x740
 [<c02eff22>] device_register+0x12/0x20
 [<c02effdb>] device_create_vargs+0xab/0xc0
 [<c02f0019>] device_create+0x29/0x30
 [<c02d954d>] tty_register_device+0xcd/0x100
 [<f8ba84d3>] rfcomm_dev_ioctl+0x5f3/0x840 [rfcomm]
 [<f8ba673c>] rfcomm_sock_ioctl+0x2c/0x50 [rfcomm]
 [<c0375db0>] sock_ioctl+0x60/0x230
 [<c0375d50>] ? sock_ioctl+0x0/0x230
 [<c0192468>] vfs_ioctl+0x28/0x90
 [<c019252e>] do_vfs_ioctl+0x5e/0x2c0
 [<c01927c9>] sys_ioctl+0x39/0x70
 [<c01032d1>] sysenter_past_esp+0x6a/0x91
 =======================

Soeren

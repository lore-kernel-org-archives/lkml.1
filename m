Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbXJMFld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbXJMFld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 01:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXJMFlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 01:41:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:37184 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751203AbXJMFlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 01:41:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+FHWkByZ2FGelE9YfeUqadD6akQBkxjKj6os7Iq9
	WE/AFYGLCcWFKA
Subject: [linux-2.6.git] IDE/ATA fighting over driver name?
From: Mike Galbraith <efault@gmx.de>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 13 Oct 2007 07:41:21 +0200
Message-Id: <1192254081.29452.13.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Perhaps my .config is dainbramaged.  When make oldconfig asked me if I
wanted CONFIG_PATA_PLATFORM, I said "Damned if I know, go for it".

drivers/ide/legacy/ide_platform.c:		.name = "pata_platform",
drivers/ata/pata_platform.c:#define DRV_NAME "pata_platform"

[   26.586663] sysfs: duplicate filename 'pata_platform' can not be created
[   26.601006] WARNING: at fs/sysfs/dir.c:425 sysfs_add_one()
[   26.614080]  [<c010515a>] show_trace_log_lvl+0x1a/0x30
[   26.626777]  [<c0105d33>] show_trace+0x12/0x14
[   26.638668]  [<c0105d4b>] dump_stack+0x16/0x18
[   26.650306]  [<c01b905d>] sysfs_add_one+0x91/0xc6
[   26.662311]  [<c01b954d>] create_dir+0x43/0x7a
[   26.673884]  [<c01b95af>] sysfs_create_dir+0x2b/0x43
[   26.685944]  [<c02c8dfa>] kobject_add+0x97/0x1b5
[   26.697775]  [<c02c8f83>] kobject_register+0x1c/0x37
[   26.709873]  [<c034d089>] bus_add_driver+0x62/0x1cf
[   26.721833]  [<c034dbe9>] driver_register+0x42/0x6c
[   26.733682]  [<c034ecbc>] platform_driver_register+0x66/0x68
[   26.746301]  [<c065f889>] pata_platform_init+0xd/0xf
[   26.758138]  [<c0645556>] kernel_init+0x131/0x2fb
[   26.769631]  [<c0104db3>] kernel_thread_helper+0x7/0x14
[   26.781659]  =======================
[   26.791959] kobject_add failed for pata_platform with -EEXIST, don't try to register things with the same name in the same directory.
[   26.818148]  [<c010515a>] show_trace_log_lvl+0x1a/0x30
[   26.830479]  [<c0105d33>] show_trace+0x12/0x14
[   26.842032]  [<c0105d4b>] dump_stack+0x16/0x18
[   26.853507]  [<c02c8e7f>] kobject_add+0x11c/0x1b5
[   26.865070]  [<c02c8f83>] kobject_register+0x1c/0x37
[   26.876702]  [<c034d089>] bus_add_driver+0x62/0x1cf
[   26.888250]  [<c034dbe9>] driver_register+0x42/0x6c
[   26.899788]  [<c034ecbc>] platform_driver_register+0x66/0x68
[   26.912009]  [<c065f889>] pata_platform_init+0xd/0xf
[   26.923379]  [<c0645556>] kernel_init+0x131/0x2fb
[   26.934490]  [<c0104db3>] kernel_thread_helper+0x7/0x14
[   26.946010]  =======================



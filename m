Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZKAVrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZKAVrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbZKAVrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:47:07 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43591 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZKAVrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:47:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=sol9mcHsWlAf7Qi+V9J8eU4nfD2cEBMJYgvOgolWrRYWhdL97L2TPPCgkjBF5uk7F8
         xvEbtMJ3uu7m/PsWXl/6t1a2D1NjMF4BnDF+t940cIgiMquLGAea3qFb1YkHa/AhYcnL
         n4kox6aCJKk65uTyb1/uGcB3JJxT+4YWEuoyI=
Message-ID: <4AEE01D9.8040902@gmail.com>
Date: Sun, 01 Nov 2009 22:47:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Dave Airlie <airlied@redhat.com>, kvm@vger.kernel.org
Subject: vga_arb warning [was: mmotm 2009-11-01-10-01 uploaded]
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
In-Reply-To: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 07:07 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to

Hi, I got the following warning while booting an image in qemu-kvm:

WARNING: at fs/attr.c:158 notify_change+0x2da/0x310()
Hardware name:
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.32-rc5-mm1_64 #862
Call Trace:
 [<ffffffff81038008>] warn_slowpath_common+0x78/0xb0
 [<ffffffff8103804f>] warn_slowpath_null+0xf/0x20
 [<ffffffff810d32ba>] notify_change+0x2da/0x310
 [<ffffffff810c5b88>] ? fsnotify_create+0x48/0x60
 [<ffffffff810c6d2b>] ? vfs_mknod+0xbb/0xe0
 [<ffffffff812487b6>] devtmpfs_create_node+0x1e6/0x270
 [<ffffffff811170d0>] ? sysfs_addrm_finish+0x20/0x280
 [<ffffffff811175d6>] ? __sysfs_add_one+0x26/0xf0
 [<ffffffff81117b6c>] ? sysfs_do_create_link+0xcc/0x160
 [<ffffffff81241cf0>] device_add+0x1e0/0x5b0
 [<ffffffff8124adb1>] ? pm_runtime_init+0xa1/0xb0
 [<ffffffff81248f05>] ? device_pm_init+0x65/0x70
 [<ffffffff812420d9>] device_register+0x19/0x20
 [<ffffffff81242290>] device_create_vargs+0xf0/0x120
 [<ffffffff812422ec>] device_create+0x2c/0x30
 [<ffffffff810c0516>] ? __register_chrdev+0x86/0xf0
 [<ffffffff81245599>] ? __class_create+0x69/0xa0
 [<ffffffff814326e9>] ? mutex_lock+0x19/0x50
 [<ffffffff811d4e23>] misc_register+0x93/0x170
 [<ffffffff818994a0>] ? vga_arb_device_init+0x0/0x77
 [<ffffffff818994b3>] vga_arb_device_init+0x13/0x77
 [<ffffffff818994a0>] ? vga_arb_device_init+0x0/0x77
 [<ffffffff810001e7>] do_one_initcall+0x37/0x190
 [<ffffffff8187d6ce>] kernel_init+0x172/0x1c8
 [<ffffffff81003c7a>] child_rip+0xa/0x20
 [<ffffffff8187d55c>] ? kernel_init+0x0/0x1c8
 [<ffffffff81003c70>] ? child_rip+0x0/0x20
---[ end trace 4eaa2a86a8e2da22 ]---


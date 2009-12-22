Return-Path: <linux-kernel-owner+w=401wt.eu-S1751409AbZLVMEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbZLVMEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbZLVMES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:04:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34342 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZLVMER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:04:17 -0500
To: linux-kernel@vger.kernel.org
Cc: DSA <debian-admin@lists.debian.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.32.1: BUG and panic: unable to handle kernel NULL pointer dereference at 000000000000001f
From: Andi Kleen <andi@firstfloor.org>
References: <20091215162736.GS13850@anguilla.noreply.org>
Date: Tue, 22 Dec 2009 13:04:16 +0100
In-Reply-To: <20091215162736.GS13850@anguilla.noreply.org> (Peter Palfrader's message of "Tue, 15 Dec 2009 17:27:37 +0100")
Message-ID: <871vindxkv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Palfrader <weasel@debian.org> writes:


> [    5.304749] BUG: unable to handle kernel NULL pointer dereference at 000000000000001f
> ..
> [    5.308739] Call Trace:
> [    5.308739]  [<ffffffff810c3840>] kstrdup+0x40/0x70
> [    5.308739]  [<ffffffff81150d77>] sysfs_new_dirent+0xf7/0x110
> [    5.308739]  [<ffffffff8115121d>] create_dir+0x3d/0xc0
> [    5.308739]  [<ffffffff81090af1>] ? autoremove_wake_function+0x11/0x40
> [    5.308739]  [<ffffffff811512d4>] sysfs_create_dir+0x34/0x50
> [    5.308739]  [<ffffffff8138e7ea>] ? kobject_get+0x1a/0x30
> [    5.308739]  [<ffffffff8138e961>] kobject_add_internal+0xe1/0x1e0
> [    5.308739]  [<ffffffff8138eb78>] kobject_add_varg+0x38/0x60
> [    5.308739]  [<ffffffff8138ec15>] kobject_init_and_add+0x75/0x90
> [    5.308739]  [<ffffffff81150560>] ? sysfs_ilookup_test+0x0/0x20
> [    5.308739]  [<ffffffff8115082d>] ? sysfs_find_dirent+0x2d/0x40
> [    5.308739]  [<ffffffff81150ec1>] ? sysfs_addrm_finish+0x21/0x250
> [    5.308739]  [<ffffffff8138e7ea>] ? kobject_get+0x1a/0x30
> [    5.308739]  [<ffffffff810e6fe4>] ? kmem_cache_alloc+0x84/0xc0
> [    5.308739]  [<ffffffff814238d4>] bus_add_driver+0x94/0x260
> [    5.308739]  [<ffffffff81424ed9>] driver_register+0x79/0x160
> [    5.308739]  [<ffffffff815a28a3>] __hid_register_driver+0x43/0x80
> [    5.308739]  [<ffffffff81a3d7ff>] ? gyration_init+0x0/0x1b
> [    5.308739]  [<ffffffff81a3d818>] gyration_init+0x19/0x1b

Seems to be caused by the "gyration driver" whatever that is. Do you
have such a USB device?  

It could be some module mismatch, it looks suspicious
and from a quick look the gyration driver does nothing bad 
in that init path. Try a make clean and remove/rebuild/reinstall all the modules
on the target system.

If that doesn't help perhaps disable CONFIG_HID_GYRATION,
but from your other oops something more seems to be broken anyways.

> [    5.308739]  [<ffffffff81009048>] do_one_initcall+0x38/0x1a0
> [    5.308739]  [<ffffffff81a0e6b5>] kernel_init+0x172/0x1ca
> [    5.308739]  [<ffffffff81036a0a>] child_rip+0xa/0x20
> [    5.308739]  [<ffffffff81a0e543>] ? kernel_init+0x0/0x1ca
> [    5.308739]  [<ffffffff81036a00>] ? child_rip+0x0/0x20

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

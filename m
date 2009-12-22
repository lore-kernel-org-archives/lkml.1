Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZLVSd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZLVSd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZLVSd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:33:56 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:59175 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZLVSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:33:55 -0500
Date: Tue, 22 Dec 2009 19:33:54 +0100
From: Peter Palfrader <weasel@debian.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, DSA <debian-admin@lists.debian.org>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.32.1: BUG and panic: unable to handle kernel NULL pointer dereference at 000000000000001f
Message-ID: <20091222183354.GM13850@anguilla.noreply.org>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, DSA <debian-admin@lists.debian.org>,
	linux-input@vger.kernel.org
References: <20091215162736.GS13850@anguilla.noreply.org> <871vindxkv.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <871vindxkv.fsf@basil.nowhere.org>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, Andi Kleen wrote:

> > [    5.304749] BUG: unable to handle kernel NULL pointer dereference at 000000000000001f
> > ..
> > [    5.308739] Call Trace:
> > [    5.308739]  [<ffffffff810c3840>] kstrdup+0x40/0x70
> > [    5.308739]  [<ffffffff81150d77>] sysfs_new_dirent+0xf7/0x110
> > [    5.308739]  [<ffffffff8115121d>] create_dir+0x3d/0xc0
> > [    5.308739]  [<ffffffff81090af1>] ? autoremove_wake_function+0x11/0x40
> > [    5.308739]  [<ffffffff811512d4>] sysfs_create_dir+0x34/0x50
> > [    5.308739]  [<ffffffff8138e7ea>] ? kobject_get+0x1a/0x30
> > [    5.308739]  [<ffffffff8138e961>] kobject_add_internal+0xe1/0x1e0
> > [    5.308739]  [<ffffffff8138eb78>] kobject_add_varg+0x38/0x60
> > [    5.308739]  [<ffffffff8138ec15>] kobject_init_and_add+0x75/0x90
> > [    5.308739]  [<ffffffff81150560>] ? sysfs_ilookup_test+0x0/0x20
> > [    5.308739]  [<ffffffff8115082d>] ? sysfs_find_dirent+0x2d/0x40
> > [    5.308739]  [<ffffffff81150ec1>] ? sysfs_addrm_finish+0x21/0x250
> > [    5.308739]  [<ffffffff8138e7ea>] ? kobject_get+0x1a/0x30
> > [    5.308739]  [<ffffffff810e6fe4>] ? kmem_cache_alloc+0x84/0xc0
> > [    5.308739]  [<ffffffff814238d4>] bus_add_driver+0x94/0x260
> > [    5.308739]  [<ffffffff81424ed9>] driver_register+0x79/0x160
> > [    5.308739]  [<ffffffff815a28a3>] __hid_register_driver+0x43/0x80
> > [    5.308739]  [<ffffffff81a3d7ff>] ? gyration_init+0x0/0x1b
> > [    5.308739]  [<ffffffff81a3d818>] gyration_init+0x19/0x1b
> 
> Seems to be caused by the "gyration driver" whatever that is. Do you
> have such a USB device?  

Doubtful.

> It could be some module mismatch, it looks suspicious
> and from a quick look the gyration driver does nothing bad 
> in that init path. Try a make clean and remove/rebuild/reinstall all the modules
> on the target system.
> 
> If that doesn't help perhaps disable CONFIG_HID_GYRATION,
> but from your other oops something more seems to be broken anyways.

This is a static kernel - no module support.  Anyway, I also tried
without CONFIG_USB_HID (which pulls in all the other HID_* things) but
no luck.

-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/

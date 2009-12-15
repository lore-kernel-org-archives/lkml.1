Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbZLOQeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbZLOQeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 11:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbZLOQee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 11:34:34 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:44716 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759699AbZLOQec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 11:34:32 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2009 11:34:32 EST
Date: Tue, 15 Dec 2009 17:27:37 +0100
From: Peter Palfrader <weasel@debian.org>
To: linux-kernel@vger.kernel.org
Cc: DSA <debian-admin@lists.debian.org>
Subject: 2.6.32.1: BUG and panic: unable to handle kernel NULL pointer dereference at 000000000000001f
Message-ID: <20091215162736.GS13850@anguilla.noreply.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	DSA <debian-admin@lists.debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we tried to upgrade a couple of our proliant servers from 2.6.31.6 to
2.6.32.1.

On two of our DL385g1 servers we had problems booting 2.6.32.1, as they
paniced.

One of them eventually booted correctly when it was decided to log its
serial console output; that strategy proved unsuccessful with the second
box.


[    5.304749] BUG: unable to handle kernel NULL pointer dereference at 000000000000001f
..
[    5.308739] Call Trace:
[    5.308739]  [<ffffffff810c3840>] kstrdup+0x40/0x70
[    5.308739]  [<ffffffff81150d77>] sysfs_new_dirent+0xf7/0x110
[    5.308739]  [<ffffffff8115121d>] create_dir+0x3d/0xc0
[    5.308739]  [<ffffffff81090af1>] ? autoremove_wake_function+0x11/0x40
[    5.308739]  [<ffffffff811512d4>] sysfs_create_dir+0x34/0x50
[    5.308739]  [<ffffffff8138e7ea>] ? kobject_get+0x1a/0x30
[    5.308739]  [<ffffffff8138e961>] kobject_add_internal+0xe1/0x1e0
[    5.308739]  [<ffffffff8138eb78>] kobject_add_varg+0x38/0x60
[    5.308739]  [<ffffffff8138ec15>] kobject_init_and_add+0x75/0x90
[    5.308739]  [<ffffffff81150560>] ? sysfs_ilookup_test+0x0/0x20
[    5.308739]  [<ffffffff8115082d>] ? sysfs_find_dirent+0x2d/0x40
[    5.308739]  [<ffffffff81150ec1>] ? sysfs_addrm_finish+0x21/0x250
[    5.308739]  [<ffffffff8138e7ea>] ? kobject_get+0x1a/0x30
[    5.308739]  [<ffffffff810e6fe4>] ? kmem_cache_alloc+0x84/0xc0
[    5.308739]  [<ffffffff814238d4>] bus_add_driver+0x94/0x260
[    5.308739]  [<ffffffff81424ed9>] driver_register+0x79/0x160
[    5.308739]  [<ffffffff815a28a3>] __hid_register_driver+0x43/0x80
[    5.308739]  [<ffffffff81a3d7ff>] ? gyration_init+0x0/0x1b
[    5.308739]  [<ffffffff81a3d818>] gyration_init+0x19/0x1b
[    5.308739]  [<ffffffff81009048>] do_one_initcall+0x38/0x1a0
[    5.308739]  [<ffffffff81a0e6b5>] kernel_init+0x172/0x1ca
[    5.308739]  [<ffffffff81036a0a>] child_rip+0xa/0x20
[    5.308739]  [<ffffffff81a0e543>] ? kernel_init+0x0/0x1ca
[    5.308739]  [<ffffffff81036a00>] ? child_rip+0x0/0x20

is from the machine that reliably fails to boot.
http://asteria.noreply.org/~weasel/volatile/2009-12-15-1VAB84BxJzE/ravel
hosts the complete serial console output.




What I caught on the second box, that eventually decided to boot is
similar, but not identical:
[   19.028333] Call Trace:
[   19.028333]  [<ffffffff81150560>] ? sysfs_ilookup_test+0x0/0x20
[   19.028333]  [<ffffffff810c3840>] kstrdup+0x40/0x70
[   19.028333]  [<ffffffff81150d77>] sysfs_new_dirent+0xf7/0x110
[   19.028333]  [<ffffffff81150b17>] ? sysfs_add_one+0x27/0xd0
[   19.028333]  [<ffffffff81151bf7>] sysfs_do_create_link+0x87/0x160
[   19.028333]  [<ffffffff81151cee>] sysfs_create_link+0xe/0x10
[   19.028333]  [<ffffffff81422072>] device_add+0x272/0x730
[   19.028333]  [<ffffffff8139779e>] ? kvasprintf+0x6e/0x90
[   19.028333]  [<ffffffff81422549>] device_register+0x19/0x20
[   19.028333]  [<ffffffff8142262c>] device_create_vargs+0xdc/0xf0
[   19.028333]  [<ffffffff8142268b>] device_create+0x4b/0x50
[   19.028333]  [<ffffffff813e9702>] ? extract_entropy+0xe2/0x140
[   19.028333]  [<ffffffff813f573f>] misc_register+0xbf/0x180
[   19.028333]  [<ffffffff8107a4e0>] ? init_oops_id+0x0/0x40
[   19.028333]  [<ffffffff81a2626b>] ? pm_qos_power_init+0x0/0xe1
[   19.028333]  [<ffffffff81a262a3>] pm_qos_power_init+0x38/0xe1
[   19.028333]  [<ffffffff81009048>] do_one_initcall+0x38/0x1a0
[   19.028333]  [<ffffffff81a0e6b5>] kernel_init+0x172/0x1ca
[   19.028333]  [<ffffffff81036a0a>] child_rip+0xa/0x20
[   19.028333]  [<ffffffff81a0e543>] ? kernel_init+0x0/0x1ca
[   19.028333]  [<ffffffff81036a00>] ? child_rip+0x0/0x20

http://asteria.noreply.org/~weasel/volatile/2009-12-15-1VAB84BxJzE/klecker-bad

http://asteria.noreply.org/~weasel/volatile/2009-12-15-1VAB84BxJzE/klecker-good
for the output during a successful boot.

The config file can be found at
http://asteria.noreply.org/~weasel/volatile/2009-12-15-1VAB84BxJzE/config-2.6.32.1-dsa-amd64


Cheers,
Peter
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/

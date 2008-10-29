Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYJ2JlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYJ2JlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYJ2Jky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:40:54 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4765 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJ2Jkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:40:53 -0400
Date: Wed, 29 Oct 2008 10:40:49 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26] kobject_add_internal failed for 2:0 with -EEXIST /
	unable to handle kernel NULL pointer dereference in
	sysfs_create_link
Message-ID: <20081029094041.GO11214@vanheusden.com>
References: <20081028151157.GI11214@vanheusden.com> <ac3eb2510810281607o19266977l4c77d3d3ab4bb849@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510810281607o19266977l4c77d3d3ab4bb849@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Oct 29 12:57:18 CET 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > While running my http://vanheusden.com/pyk/ script (which randomly
> > inserts and removes modules) I triggered the folllowing oops in a 2.6.26
> > kernel on an IBM xSeries 260. This oops (in fact no oops at all) did not
> > get triggered in a 2.6.18 kernel on that system.
> >
> > [   42.507375] FDC 0 is a National Semiconductor PC87306
> > [   42.509057] kobject_add_internal failed for 2:0 with -EEXIST, don't try to register things with the same name in the same directory.
> > [   42.509291] Pid: 5301, comm: modprobe Not tainted 2.6.26-1-amd64 #1
> > [   42.509431]
> > [   42.509433] Call Trace:
> > [   42.509685]  [<ffffffff8031b031>] kobject_add_internal+0x13f/0x17e
> > [   42.509823]  [<ffffffff8031b46e>] kobject_add+0x74/0x7c
> > [   42.509969]  [<ffffffff802e2470>] sysfs_addrm_finish+0x19/0x1ea
> > [   42.510141]  [<ffffffff802e21b4>] sysfs_find_dirent+0x1b/0x2f
> > [   42.510331]  [<ffffffff802e2741>] create_dir+0x5a/0x87
> > [   42.510466]  [<ffffffff8031ae88>] kobject_get+0x12/0x17
> > [   42.510614]  [<ffffffff80382771>] get_device+0x17/0x20
> > [   42.510754]  [<ffffffff80382d81>] device_add+0x9b/0x53f
> > [   42.510915]  [<ffffffff8031acf2>] kobject_init+0x41/0x69
> > [   42.511374]  [<ffffffff803832d1>] device_create_vargs+0x9a/0xc6
> > [   42.511519]  [<ffffffff8027d23b>] bdi_register+0x57/0xb4
> 
> Looks like bdi sees two devices with the same devnum, or didn't
> cleanup an old entry.
> What does: ls -l "/sys/class/bdi/" print?

The following:
folkert@debiantesthw:~$ ls -l /sys/class/bdi/
total 0
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:0
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:1
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:10
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:11
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:12
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:13
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:14
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:15
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:2
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:3
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:4
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:5
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:6
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:7
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:8
drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:9
drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:0
drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:1
drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:0
drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:1
drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:2
drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:3
drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:4
drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:5
drwxr-xr-x 3 root root 0 2008-10-28 18:32 3:0
drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:0
drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:1
drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:2
drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:3
drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:4
drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:5
drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:6
drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:7
drwxr-xr-x 3 root root 0 2008-10-28 18:32 8:0
drwxr-xr-x 3 root root 0 2008-10-28 18:32 default

> How many floppies (or emulated floppies) does this system have?

1 physical.


Folkert van Heusden

-- 
Ever wonder what is out there? Any alien races? Then please support
the seti@home project: setiathome.ssl.berkeley.edu
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

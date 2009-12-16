Return-Path: <linux-kernel-owner+w=401wt.eu-S935864AbZLPWmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935864AbZLPWmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935863AbZLPWmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:42:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35999 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935853AbZLPWl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:41:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CcohqoIUHaNXzFPt7zJFnxC34pyRFhZlohp7E7/LxtcRe1EDUXME2MF8RRsPt67+H8
         DP0JA4GQY9H+pFdq6AEMAeoFUUlVXSOSJmm0mkz69Up2GfHEqfJPgimQ/4B9CtNoPaLw
         y491a6NAjw093dlxdQXsK0gEKGySkOfpTFZfo=
MIME-Version: 1.0
In-Reply-To: <20091216185157.GL14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk>
Date: Thu, 17 Dec 2009 01:41:48 +0300
Message-ID: <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com>
Subject: Re: [git pull] VFS stuff, part 1
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/16 Al Viro <viro@zeniv.linux.org.uk>:
> This ought to get rid of the bulk of namei.c patches affecting the
> areas where my and Nick's series step on the same code.  There's
> also some struct file work, plus a bunch of fixes all over the place
> (in particular, Eric's series dealing with IMA horrors, partially
> modified to merge), but most of that stuff is fighting the call
> graph in fs/namei.c and massaging things into more or less sane shape
> there.
>
> Please, pull from
> git.kernel.org//pub/scm/linux/kernel/git/viro/vfs-2.6.git/

Hi

Here is a regression between
5ac4d63 (Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block)
and
bac5e54 (Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6)


[   17.462212] REISERFS (device sda1): found reiserfs format "3.6"
with standard journal
[   17.470199] REISERFS (device sda1): using ordered data mode
[   17.480645] REISERFS (device sda1): journal params: device sda1,
size 8192, journal first block 18, max trans len 1024, max batch 900,
max commit age 30, max trans age 30
[   17.497079] REISERFS (device sda1): checking transaction log (sda1)
[   17.503457] REISERFS debug (device sda1): journal-1153: found in
header: first_unflushed_offset 6839, last_flushed_trans_id 2074215
[   17.521242] REISERFS debug (device sda1): journal-1206: Starting
replay from offset 8908689884846775, trans_id 4161904640
[   17.532296] REISERFS debug (device sda1): journal-1299: Setting
newest_mount_id to 315
[   17.573874] REISERFS (device sda1): Using r5 hash to sort names
[   17.603715] VFS: Mounted root (reiserfs filesystem) readonly on device 8:1.
[   17.610972] Freeing unused kernel memory: 280k freed
[   17.790027] ohci_hcd 0000:00:02.0: auto-stop root hub
INIT: version 2.87 booting
[   18.290029] ohci_hcd 0000:00:02.1: auto-stop root hub
[   18.595537] kbd_mode used greatest stack depth: 6028 bytes left
Loading /lib/rc/console/keymap
[   18.648845] loadkeys used greatest stack depth: 5764 bytes left
[   18.655619] init-early.sh used greatest stack depth: 5276 bytes left

   OpenRC 0.5.3 is starting up Gentoo Linux (i686)

* Mounting /proc...
[   18.819236] mount used greatest stack depth: 5260 bytes left
 [ ok ]
mkdir `/lib/rc/init.d/starting': Operation not supported
mkdir `/lib/rc/init.d/started': Operation not supported
mkdir `/lib/rc/init.d/stopping': Operation not supported
mkdir `/lib/rc/init.d/inactive': Operation not supported
mkdir `/lib/rc/init.d/wasinactive': Operation not supported
mkdir `/lib/rc/init.d/failed': Operation not supported
mkdir `/lib/rc/init.d/hotplugged': Operation not supported
mkdir `/lib/rc/init.d/daemons': Operation not supported
mkdir `/lib/rc/init.d/options': Operation not supported
mkdir `/lib/rc/init.d/exclusive': Operation not supported
mkdir `/lib/rc/init.d/scheduled': Operation not supported
mkdir `/lib/rc/init.d/tmp': Operation not supported
* Caching service dependencies...
[   20.203989] gendepends.sh used greatest stack depth: 5176 bytes left
 [ ok ]
* rc: failed to cr* rc: failed to crINIT: Entering runlevel: 3
* rc: failed to create stopping dir `/lib/rc/init.d/rc.stopping':
Operation not supported
[   21.075265] device: 'vcs6': device_add
[   21.078101] device: 'vcsa6': device_add
[   21.086896] device: 'vcs4': device_add
[   21.087221] device: 'vcsa4': device_add
[   21.095348] device: 'vcs2': device_add
[   21.095696] device: 'vcsa2': device_add
[   21.103825] device: 'vcs3': device_add
[   21.104151] device: 'vcsa3': device_add
[   21.112285] device: 'vcs5': device_add
[   21.112604] device: 'vcsa5': device_add
INIT: Id "s0" respawni
INIT: Id "s0" respawni


Is it obvious for you or do I need to bisect ?

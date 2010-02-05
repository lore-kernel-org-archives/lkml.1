Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab0BEBqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:46:46 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33509 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab0BEBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vrFicK/2g+V+TTr+yQAuutvyCaRf667KX4EM9q9HOg6uqoKgZHibg5OzEhShPJiT1+
         gSf3ndQ4+R98P67QDwMmvj3wW3mfpCFgUWwkCJTZRBTpnCuY2y5hV1/Sq5UPV7JA7RQa
         rYWFpwtiQ4uHdHKjltHaLccfjijwcNgyty1yE=
MIME-Version: 1.0
In-Reply-To: <20100203225232.GI5068@nowhere>
References: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com>
	 <a4423d671002031108x6c2682edl9a147c35ac9c2815@mail.gmail.com>
	 <20100203202909.GA5068@nowhere>
	 <a4423d671002031443q283bab49wd15cd4de556d9557@mail.gmail.com>
	 <20100203225232.GI5068@nowhere>
Date: Fri, 5 Feb 2010 04:46:38 +0300
Message-ID: <a4423d671002041746q1d918972i7c180d38a7c1d52@mail.gmail.com>
Subject: Re: reiserfs deadlock
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic

Does it help?

2 locks held by metalog/1558:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>]
generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>]
reiserfs_write_lock_once+0x28/0x50

2 locks held by svscan/1600:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>]
vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40

3 locks held by agetty/1868:
 #0:  (&p->cred_guard_mutex){+.+.+.}, at: [<c10972f4>]
prepare_bprm_creds+0x24/0x60
 #1:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109a4bb>]
do_lookup+0xbb/0x1c0
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>]
reiserfs_write_lock_once+0x28/0x50

2 locks held by modprobe/1871:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c10a0112>]
vfs_readdir+0x52/0xa0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40

2 locks held by fcron/1872:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c109d903>]
do_filp_open+0x173/0x9f0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>]
reiserfs_write_lock_once+0x28/0x50

3 locks held by ddclient/1588:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c1091417>]
do_truncate+0x57/0x90
 #1:  (&sb->s_type->i_alloc_sem_key#3){+.+...}, at: [<c10a65e6>]
notify_change+0x1d6/0x330
 #2:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>]
reiserfs_write_lock_once+0x28/0x50

2 locks held by multilog/1615:
 #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<c106a501>]
generic_file_aio_write+0x41/0xb0
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110ed8>]
reiserfs_write_lock_once+0x28/0x50

2 locks held by nfsd/1734:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40
2 locks held by nfsd/1735:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40
2 locks held by nfsd/1736:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40
2 locks held by nfsd/1737:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40
2 locks held by nfsd/1738:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40
2 locks held by nfsd/1739:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40
2 locks held by nfsd/1740:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40
2 locks held by nfsd/1741:
 #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
 #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>]
reiserfs_write_lock+0x28/0x40

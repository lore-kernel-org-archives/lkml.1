Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZHYCcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZHYCcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 22:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZHYCcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 22:32:54 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41395 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbZHYCcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 22:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RvPnkzotODMso/NQ8ZXu263WKO2G9ay2JPwUFcixtWUYq0C0vYDqCcz9gYhctgKIkh
         gYiM8kZVhJbpuh2423Yymb9GCu45uBFYVhUhRin3kNSFfFRU5qXs0ZAU8SXLprR2Y67F
         WY6nY03EN/MiWJ8ysh7Q/Jb5wznFsZsLkg/SU=
From: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH 0/4] kill-the-bkl/reiserfs: fix some lock dependency inversions
Date: Tue, 25 Aug 2009 04:32:46 +0200
Message-Id: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
To: LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small set fixes some lock dependency inversions found in reiserfs
xattr and mmap paths.
I guess there are still some of them that I'll have to hunt, especially one
reported by Laurent Riffard and another one introduced by the reiserfs_readdir
path optimization (though I'm not sure about the latter, I have yet to find a
way to reproduce it properly).

As usual, these patches can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
	reiserfs/kill-bkl

Thanks,
Frederic.

Frederic Weisbecker (4):
  kill-the-bkl/reiserfs: fix "reiserfs lock" / "inode mutex" lock
    inversion dependency
  kill-the-bkl/reiserfs: fix recursive reiserfs lock in
    reiserfs_mkdir()
  kill-the-bkl/reiserfs: fix recursive reiserfs write lock in
    reiserfs_commit_write()
  kill-the-bkl/reiserfs: panic in case of lock imbalance

 fs/reiserfs/inode.c |   11 ++---------
 fs/reiserfs/lock.c  |    7 +++----
 fs/reiserfs/namei.c |    7 ++++---
 fs/reiserfs/xattr.c |    2 +-
 4 files changed, 10 insertions(+), 17 deletions(-)



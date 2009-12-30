Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZL3Umc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZL3Umc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZL3Umb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:42:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54067 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbZL3Uma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:42:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UtJioLN0HbFBC6vlf4JtdUZhaUzLdjo+uAdKUDL6P0pw2GXArnLcJZktmZ/wVwvNaD
         tH+WWrs0UH5d6uxIiVZ7MsOZn+2YzLjGoryWr1xRHYq4qO5TaV7l1Tk7yT+hzhqhiNGQ
         JPZyW7JKqy+/z44JSImeaW+NmtS7o5oY0X+Cg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH 0/5] reiserfs lock inversion fixes on xattr
Date: Wed, 30 Dec 2009 21:42:22 +0100
Message-Id: <1262205747-9208-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
References: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Christian Kujau's use of dbench to test reiserfs xattr has inspired me.
I tried dbench -x yesterday and got various soft-lockups and lockdep
reports.

I fixed all those I've seen in this batch and it passed through 6 hours
of stress testing (if a loop of dbench -x -t 60 20 can be called stress
testing) and things look pretty fine now.

I hope you can give it a try (and/or review) before I send the whole
to Linus.

Thanks!

It's on:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
        reiserfs/kill-bkl

How to get it:

git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
cd linux-2.6.git
git-pull git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git reiserfs/kill-bkl

Frederic Weisbecker (5):
  reiserfs: Relax lock before open xattr dir in reiserfs_xattr_set_handle()
  reiserfs: Fix unwanted recursive reiserfs lock in reiserfs_unlink()
  reiserfs: Fix journal mutex <-> inode mutex lock inversion
  reiserfs: Safely acquire i_mutex from reiserfs_for_each_xattr
  reiserfs: Safely acquire i_mutex from xattr_rmdir

 fs/reiserfs/namei.c |    7 ++++---
 fs/reiserfs/xattr.c |   20 ++++++++++++++------
 2 files changed, 18 insertions(+), 9 deletions(-)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZL3FVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZL3FVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZL3FVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:21:36 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50412 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZL3FVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mvhPK99Mr7AM+7XtKnr28kMxmIQWCVg28nG88elh9UBpwMjCx1jSjf7qgCy3ntCB+x
         d73dGe8lyR+JldbJ386U4okft9nKQCz7pzelKBHFRrKn15/MRMTQoggNRSFv29pB1UI/
         B304ap6pZhNiqddkAxRC01HrrNlUjzR4tXdXA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4] Some reiserfs fixes
Date: Wed, 30 Dec 2009 06:21:27 +0100
Message-Id: <1262150491-9983-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches should fix most of the lock inversions you've reported,
plus some others I've encountered, except may be the one reported by
Yinghai Lu that I'm still trying to reproduce.

I just hope these fixes won't enlight more lock inversions.

Anyway, please give it a try, your reports have been really helpful.

You can merge my branch into latest upstream tree to test it:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

Thanks!

Frederic Weisbecker (4):
  reiserfs: Fix reiserfs lock <-> i_xattr_sem dependency inversion
  reiserfs: Warn on lock relax if taken recursively
  reiserfs: Fix reiserfs lock <-> i_mutex dependency inversion on xattr
  reiserfs: Relax reiserfs lock while freeing the journal

 fs/reiserfs/journal.c       |    3 ++-
 fs/reiserfs/lock.c          |    9 +++++++++
 fs/reiserfs/xattr.c         |   11 ++++++++---
 include/linux/reiserfs_fs.h |   13 ++++++++++---
 4 files changed, 29 insertions(+), 7 deletions(-)


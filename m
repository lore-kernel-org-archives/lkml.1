Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbZDNDek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbZDNDek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZDNDe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:34:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:53200 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZDNDe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kxYtoSexVMRU2Z3xFVof4V+Gv5RNSDFBSHxyemDt4+XpAn3o7znGs8/NeRpncKUFcW
         8IxeT+Kb4PxaHQCv49UTroXZhkowRq0v98EjNgN+vB09IoXfHIWPEpbHmmRDUfmUUimI
         qxw6Z12IwOqg8ozLhO7/MpEgbBcup3vfGOQck=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 0/3] kill-the-BKL/reiserfs: reiserfs fixes
Date: Tue, 14 Apr 2009 05:34:22 +0200
Message-Id: <1239680065-25013-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This small patchset fixes some deadlocks I've faced after trying
some pressures with dbench on a reiserfs partition.

There is still some work pending such as adding some checks to ensure we
_always_ release the lock before sleeping, as you suggested.
Also I have to fix a lockdep warning reported by Alessio Igor Bogani.
And also some optimizations....

Thanks,
Frederic.

Frederic Weisbecker (3):
  kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
  kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
  kill-the-BKL/reiserfs: only acquire the write lock once in
    reiserfs_dirty_inode

 fs/reiserfs/inode.c         |   10 +++++++---
 fs/reiserfs/lock.c          |   26 ++++++++++++++++++++++++++
 fs/reiserfs/super.c         |   15 +++++++++------
 include/linux/reiserfs_fs.h |    2 ++
 4 files changed, 44 insertions(+), 9 deletions(-)


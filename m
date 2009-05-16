Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZEPSCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZEPSCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 14:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZEPSCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 14:02:07 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62708 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZEPSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 14:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Vlfi8003YW9+6m0YdU/2PuHG7VQGj62IknESInAJ85zPT8KCtoxHrHvrHNWr4L+qKF
         avedkpsoP/6oPgTko6fkqPIuZzT9mMLq+JIZN3pqSA7fAYHvHBG/dhqa1JEvreQ3T+jC
         7/DTaaTuoxsszfIKdxXMtJMu2pTg0SLqkk83E=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 0/2] kill-the-bkl/reiserfs: rebase against -rc6, fixes
Date: Sat, 16 May 2009 20:02:00 +0200
Message-Id: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al, Stephen,

This patchset is subsequent to a rebase of the bkl killing in reiserfs
work rebased against -rc6. It contains only fixes.
The old topic is left unchanged but the new one reiserfs/kill-bkl-rc6 can
be pulled against -rc6 without problem.

Also, Al, I don't know if you would still accept to apply this work in the VFS
tree.
The fact is that it becomes late in the process, we are already in -rc6
and I would like it to be tested at least in linux-next.

So, it's up to you. Whether you prefer to apply it and make it
available to next, or I can ask Stephen to pull directly from my tree.

Thanks,
Frederic.

The following changes since commit b693ba70c541a5a26eb4e8f2db5ade454afe1c74:
  Frederic Weisbecker (1):
        kill-the-bkl/reiserfs: unlock only when needed in search_by_key

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl-rc6

Frederic Weisbecker (2):
      kill-the-bkl/reiserfs: acquire the inode mutex safely
      kill-the-bkl/reiserfs: move the concurrent tree accesses checks per superblock

 fs/reiserfs/do_balan.c         |   17 +++++------------
 fs/reiserfs/fix_node.c         |    5 +----
 fs/reiserfs/journal.c          |   34 ----------------------------------
 fs/reiserfs/prints.c           |    4 ----
 fs/reiserfs/stree.c            |    5 +----
 fs/reiserfs/xattr.c            |    4 ++--
 include/linux/reiserfs_fs.h    |   35 +++++++++++++++++++++++++++++++++++
 include/linux/reiserfs_fs_sb.h |   11 +++++++++++
 8 files changed, 55 insertions(+), 60 deletions(-)

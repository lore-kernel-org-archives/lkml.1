Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYJLWRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYJLWRP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 18:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYJLWQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 18:16:59 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39774 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753398AbYJLWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 18:16:58 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 updates for 2.6.27-git2
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Kp9F7-0000Dd-RC@closure.thunk.org>
Date: Sun, 12 Oct 2008 18:16:53 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This fixes a typo in fs/Kconfig, a build problem when CONFIG_PROC_FS is
not defined, and some patches that address error handling for disk write
failures that had been forward ported from ext3 by Hidehiro-san that I
hadn't time to audit before my last pull.

Thanks!!

                                                - Ted

Alexander Beregalov (1):
      ext4: fix build failure without procfs

Hidehiro Kawai (5):
      jbd2: abort when failed to log metadata buffers
      jbd2: fix error handling for checkpoint io
      ext4: add checks for errors from jbd2
      jbd2: don't dirty original metadata buffer on abort
      ext4: add an option to control error handling on file data

Jan Engelhardt (1):
      ext4: fix kconfig typo and extra whitespace

 Documentation/filesystems/ext4.txt |    5 +++
 fs/Kconfig                         |    4 +-
 fs/ext4/ext4.h                     |    2 +
 fs/ext4/ioctl.c                    |   12 ++++++---
 fs/ext4/super.c                    |   41 +++++++++++++++++++++++++++---
 fs/jbd2/checkpoint.c               |   49 +++++++++++++++++++++++++++---------
 fs/jbd2/commit.c                   |   10 ++++++-
 fs/jbd2/journal.c                  |   28 ++++++++++++++++----
 fs/jbd2/recovery.c                 |    7 +++-
 include/linux/jbd2.h               |    5 +++-
 10 files changed, 131 insertions(+), 32 deletions(-)

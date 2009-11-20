Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZKTUZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZKTUZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZKTUZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:25:46 -0500
Received: from lazybastard.de ([212.112.238.170]:48494 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbZKTUWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:22:17 -0500
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
From: Joern Engel <joern@logfs.org>
Subject: [PATCH 0/17] [LogFS] New flash filesystem
Message-ID: <20091120181113.GA2159@logfs.org>
Date: Fri, 20 Nov 2009 20:37:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logfs has been around a couple of times.  Linus last word was "go and
don't come back until all format changes are done".  Or something
along those lines at least.

Format changes are done.  And I don't even intend to break git-bisect
for anyone crazy enough to use logfs for /.  But then again, logfs
doesn't have the hype of btrfs, nor does it deserve it.

Most controversial bit (for me, at least) is the btree code.  It is
generic enough to be used by others as well, but last time I checked,
rbtree performed better.  So unless someone (me?) spends some time to
see what's going on, a short-term option would be to move it all under
fs/logfs/, making it unavailable for others and remove it completely
unless good arguments are found in favor.

Patch 18 is a bonus for anyone lucky enough to have a decent device.
For those not too familiar with mtd - all mtd operations are
synchronous.  Which makes the interface horribly slow on devices that
support asynchronous operations, queueing or even parallel operations
on multiple chips.  I have a prototype device that shows promise,
along with the usual problems of prototypes.  So together with the
paper-thin infrastructure patch [1] and a decent device, that patch
allows logfs to make several thousand IO/s.

Mails are purely for review and comments.  If this is deemed
merge-ready, please the git tree at
http://git.kernel.org/?p=linux/kernel/git/joern/logfs.git
instead.

[1] http://lists.infradead.org/pipermail/linux-mtd/2009-November/028065.html

 Documentation/filesystems/00-INDEX  |    2 +
 Documentation/filesystems/logfs.txt |  241 ++++
 fs/Kconfig                          |    1 +
 fs/Makefile                         |    1 +
 fs/logfs/Kconfig                    |   17 +
 fs/logfs/Makefile                   |   13 +
 fs/logfs/compr.c                    |   95 ++
 fs/logfs/dev_bdev.c                 |  263 ++++
 fs/logfs/dev_mtd.c                  |  253 ++++
 fs/logfs/dir.c                      |  818 +++++++++++++
 fs/logfs/file.c                     |  263 ++++
 fs/logfs/gc.c                       |  730 ++++++++++++
 fs/logfs/inode.c                    |  417 +++++++
 fs/logfs/journal.c                  |  879 ++++++++++++++
 fs/logfs/logfs.h                    |  722 +++++++++++
 fs/logfs/logfs_abi.h                |  627 ++++++++++
 fs/logfs/readwrite.c                | 2246 +++++++++++++++++++++++++++++++++++
 fs/logfs/segment.c                  |  924 ++++++++++++++
 fs/logfs/super.c                    |  634 ++++++++++
 include/linux/btree-128.h           |  109 ++
 include/linux/btree-type.h          |  147 +++
 include/linux/btree.h               |  243 ++++
 lib/Kconfig                         |    3 +
 lib/Makefile                        |    1 +
 lib/btree.c                         |  797 +++++++++++++
 25 files changed, 10446 insertions(+), 0 deletions(-)

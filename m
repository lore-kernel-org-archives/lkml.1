Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZIKEiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZIKEiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 00:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbZIKEiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 00:38:24 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:19966 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZIKEiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 00:38:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAH9xqUqrR7O6/2dsb2JhbADEUYhGAZA1BYQYgks
X-IronPort-AV: E=Sophos;i="4.44,368,1249257600"; 
   d="scan'208";a="240286611"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jsquyres@cisco.com
Cc: linux-rdma@vger.kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull ummunotify
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Sep 2009 21:38:22 -0700
Message-ID: <aday6omhz9d.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Sep 2009 04:38:22.0925 (UTC) FILETIME=[B1E217D0:01CA3299]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please consider pulling from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify

This will get "ummunotify," a new character device that allows a
userspace library to register for MMU notifications; this is
particularly useful for MPI implementions (message passing libraries
used in HPC) to be able to keep track of what wacky things consumers
do to their memory mappings.  My colleague Jeff Squyres from the Open
MPI project posted a blog entry about why MPI wants this:

http://blogs.cisco.com/ciscotalk/performance/comments/better_linux_memory_tracking/

His summary of ummunotify:

  "It’s elegant, doesn’t require strange linker tricks, and seems to
   work in all cases.  Yay!"

This code went through several review iterations on lkml and was in
-mm and -next for quite a few weeks.  Andrew is OK with merging it (I
think -- Andrew please correct me if I misunderstood you).

Roland Dreier (1):
      ummunotify: Userspace support for MMU notifications

 Documentation/Makefile                  |    3 +-
 Documentation/ummunotify/Makefile       |    7 +
 Documentation/ummunotify/ummunotify.txt |  150 ++++++++
 Documentation/ummunotify/umn-test.c     |  200 +++++++++++
 drivers/char/Kconfig                    |   12 +
 drivers/char/Makefile                   |    1 +
 drivers/char/ummunotify.c               |  566 +++++++++++++++++++++++++++++++
 include/linux/Kbuild                    |    1 +
 include/linux/ummunotify.h              |  121 +++++++
 9 files changed, 1060 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ummunotify/Makefile
 create mode 100644 Documentation/ummunotify/ummunotify.txt
 create mode 100644 Documentation/ummunotify/umn-test.c
 create mode 100644 drivers/char/ummunotify.c
 create mode 100644 include/linux/ummunotify.h

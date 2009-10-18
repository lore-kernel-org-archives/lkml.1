Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZJRURu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZJRURu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 16:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZJRURs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 16:17:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbZJRURq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 16:17:46 -0400
Subject: [GIT PULL] inotify, dnotify, and fsnotify fixes
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, yjwei@cn.fujitsu.com, agruen@suse.de
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Oct 2009 16:17:41 -0400
Message-Id: <1255897061.15182.120.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three fixes and something I should have sent during the merge window.  I
should have added the patch to the feature-removal-list stating that I
plan to drop the in kernel inotify hooks all together in .33 when I
merge the audit->fsnotify changes, but it shouldn't hurt to go in now.  

Inotify and dnotify both have fixes to stop sending extra extraneous
events.

The fsnotify patch fixes that last race people reported in the inotify
rewrite last cycle and the people seeing complaints in dmesg that
inotify might be leaking memory.  Yeah!  inotify can be stressed by over
100 simultaneous threads on a 64 way machine without problems!


The following changes since commit 2fdc246aaf9a7fa088451ad2a72e9119b5f7f029:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Andreas Gruenbacher (1):
      dnotify: ignore FS_EVENT_ON_CHILD

Eric Paris (2):
      fsnotify: do not set group for a mark before it is on the i_list
      inotify: deprecate the inotify kernel interface

Wei Yongjun (1):
      inotify: fix coalesce duplicate events into a single event in special case

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 fs/notify/dnotify/dnotify.c                |    3 ++-
 fs/notify/inode_mark.c                     |    6 +++---
 fs/notify/notification.c                   |    2 +-
 4 files changed, 14 insertions(+), 5 deletions(-)


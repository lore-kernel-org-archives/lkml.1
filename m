Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZBIV3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZBIV3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZBIV3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:29:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33687 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbZBIV3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:29:43 -0500
Subject: [PATCH -v1 00/11] fsnotify: unified filesystem notification backend
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: sfr@canb.auug.org.au, rlove@rlove.org, malware-list@lists.printk.net,
       hch@infradead.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       john@johnmccutchan.com, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 16:28:52 -0500
Message-Id: <1234214932.3724.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, forgot the cover note. So proceeding is an implementation of
fsnotify, a novel unified filesystem notification backend.  This patch
set implements the backend and converts both dnotify and inotify to this
backend.  This patch set reduced the size of struct inode if one uses
both dnotify and inotify.

I have patches which move the audit functionality which uses inotify to
fsnotify and I have patches which implement fanotify, my new on access
notification and access decisions to this backend, but just to keep the
series small I'm only sending fsnotify, dnotify and inotify changes.

I would love the most careful and scrutinizing eyes on patches 3, 9, 10
which implement the changes to inodes and introduce by far the most
complex locking, refcnt, and object lifetimes.

dnotify changes are in patch 5
inotify changes are in patch 11

 Documentation/filesystems/fsnotify.txt |  192 ++++++++++
 MAINTAINERS                            |    4 
 fs/inode.c                             |   10 
 fs/notify/Kconfig                      |   13 
 fs/notify/Makefile                     |    2 
 fs/notify/dnotify/Kconfig              |    1 
 fs/notify/dnotify/dnotify.c            |  449 +++++++++++++++++++-----
 fs/notify/fsnotify.c                   |   91 +++++
 fs/notify/fsnotify.h                   |   28 +
 fs/notify/group.c                      |  207 +++++++++++
 fs/notify/inode_mark.c                 |  330 ++++++++++++++++++
 fs/notify/inotify/Kconfig              |   20 -
 fs/notify/inotify/Makefile             |    2 
 fs/notify/inotify/inotify.h            |  108 +++++
 fs/notify/inotify/inotify_fsnotify.c   |  176 +++++++++
 fs/notify/inotify/inotify_kernel.c     |  236 +++++++++++++
 fs/notify/inotify/inotify_user.c       |  598 ++++++++-------------------------
 fs/notify/notification.c               |  348 +++++++++++++++++++
 include/linux/dcache.h                 |    3 
 include/linux/dnotify.h                |   29 -
 include/linux/fs.h                     |    6 
 include/linux/fsnotify.h               |  255 ++++++++++----
 include/linux/fsnotify_backend.h       |  265 ++++++++++++++
 23 files changed, 2735 insertions(+), 638 deletions(-)


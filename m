Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYLOQoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYLOQoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYLOQoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:44:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48612 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633AbYLOQoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:44:07 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 0/3] send notification events about exec
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, akpm@linux-foundation.org
Date: Mon, 15 Dec 2008 11:44:03 -0500
Message-ID: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series does two things.  First it pushes inotify and dnotify
down into subdirectores inside fs/notify (help clean up fs.)  It then adds a
new fsnotify hook for exec functions to call into and uses that new hookd to
send notifications to inotify and dnotify.

---

Eric Paris (3):
      fsnotify: use the new open-exec hook for inotify and dnotify
      fsnotify: sys_execve and sys_uselib do not call into fsnotify
      filesystem notification: create fs/notify to contain all fs notification


 fs/Kconfig                       |   39 --
 fs/Makefile                      |    5 
 fs/dnotify.c                     |  194 --------
 fs/exec.c                        |    5 
 fs/inotify.c                     |  913 --------------------------------------
 fs/inotify_user.c                |  778 --------------------------------
 fs/notify/Kconfig                |    2 
 fs/notify/Makefile               |    2 
 fs/notify/dnotify/Kconfig        |   10 
 fs/notify/dnotify/Makefile       |    1 
 fs/notify/dnotify/dnotify.c      |  194 ++++++++
 fs/notify/inotify/Kconfig        |   27 +
 fs/notify/inotify/Makefile       |    2 
 fs/notify/inotify/inotify.c      |  913 ++++++++++++++++++++++++++++++++++++++
 fs/notify/inotify/inotify_user.c |  778 ++++++++++++++++++++++++++++++++
 include/linux/fsnotify.h         |   13 +
 16 files changed, 1949 insertions(+), 1927 deletions(-)
 delete mode 100644 fs/dnotify.c
 delete mode 100644 fs/inotify.c
 delete mode 100644 fs/inotify_user.c
 create mode 100644 fs/notify/Kconfig
 create mode 100644 fs/notify/Makefile
 create mode 100644 fs/notify/dnotify/Kconfig
 create mode 100644 fs/notify/dnotify/Makefile
 create mode 100644 fs/notify/dnotify/dnotify.c
 create mode 100644 fs/notify/inotify/Kconfig
 create mode 100644 fs/notify/inotify/Makefile
 create mode 100644 fs/notify/inotify/inotify.c
 create mode 100644 fs/notify/inotify/inotify_user.c

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbYG1CXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbYG1CXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbYG1CWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:22:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50889 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757966AbYG1CWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:22:37 -0400
Message-ID: <488D2D0F.7030002@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:21:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroup: uninline cgroup_has_css_refs()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not small enough, and has 2 call sites.

 text    data     bss     dec     hex filename
12813    1676    4832   19321    4b79 cgroup.o.orig
12775    1676    4832   19283    4b53 cgroup.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 249a517..13932ab 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2368,7 +2368,7 @@ static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	return cgroup_create(c_parent, dentry, mode | S_IFDIR);
 }
 
-static inline int cgroup_has_css_refs(struct cgroup *cgrp)
+static int cgroup_has_css_refs(struct cgroup *cgrp)
 {
 	/* Check the reference count on each subsystem. Since we
 	 * already established that there are no tasks in the
-- 
1.5.4.rc3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYKUD7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYKUD7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 22:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbYKUD7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 22:59:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbYKUD7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 22:59:18 -0500
Message-ID: <49263214.5080604@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 11:59:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] ns_cgroup: remove unused spinlock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I happened to find the spinlock in struct ns_cgroup is never
used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/ns_cgroup.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/ns_cgroup.c b/kernel/ns_cgroup.c
index 43c2111..78bc3fd 100644
--- a/kernel/ns_cgroup.c
+++ b/kernel/ns_cgroup.c
@@ -13,7 +13,6 @@
 
 struct ns_cgroup {
 	struct cgroup_subsys_state css;
-	spinlock_t lock;
 };
 
 struct cgroup_subsys ns_subsys;
@@ -84,7 +83,6 @@ static struct cgroup_subsys_state *ns_create(struct cgroup_subsys *ss,
 	ns_cgroup = kzalloc(sizeof(*ns_cgroup), GFP_KERNEL);
 	if (!ns_cgroup)
 		return ERR_PTR(-ENOMEM);
-	spin_lock_init(&ns_cgroup->lock);
 	return &ns_cgroup->css;
 }
 
-- 
1.5.4.rc3


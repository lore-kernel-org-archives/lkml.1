Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZCLBr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZCLBr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbZCLBre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:47:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58559 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZCLBrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:47:32 -0400
Message-ID: <49B869B2.1020303@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 09:47:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Paul Menage <menage@google.com>, Thomas Graf <tgraf@suug.ch>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cls_cgroup: remove unneeded cgroup_lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can remove this lock here, since we are in cgroup write handler
and thus the cgrp is guaranteed to be valid, and no lock is needed
when writing a u32 variable.

Signed-off-by: Li Zefan <lizf@cn.fujitsuc.com>
---
 net/sched/cls_cgroup.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 91a3db4..1ab4542 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -62,13 +62,7 @@ static u64 read_classid(struct cgroup *cgrp, struct cftype *cft)
 
 static int write_classid(struct cgroup *cgrp, struct cftype *cft, u64 value)
 {
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
-
 	cgrp_cls_state(cgrp)->classid = (u32) value;
-
-	cgroup_unlock();
-
 	return 0;
 }
 
-- 
1.5.4.rc3


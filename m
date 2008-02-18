Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYBRFxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYBRFxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYBRFvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:51:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64813 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbYBRFvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:51:18 -0500
Message-ID: <47B91C84.4080806@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 13:49:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH 6/7] cgroup: remove duplicate code in find_css_set()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list head res->tasks gets initialized twice in find_css_set().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e8c8e58..71cf961 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -473,7 +473,6 @@ static struct css_set *find_css_set(
 	/* Link this cgroup group into the list */
 	list_add(&res->list, &init_css_set.list);
 	css_set_count++;
-	INIT_LIST_HEAD(&res->tasks);
 	write_unlock(&css_set_lock);
 
 	return res;
-- 
1.5.4.rc3


Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbYDWDGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbYDWDGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 23:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYDWDFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 23:05:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59061 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbYDWDFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 23:05:53 -0400
Message-ID: <480EA744.2050300@cn.fujitsu.com>
Date: Wed, 23 Apr 2008 11:04:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroup: use read lock to guard find_existing_css_set()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function does not modify anything (except the temporary
css template), so it's sufficient to hold read lock.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2727f92..e9eb5da 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -406,11 +406,11 @@ static struct css_set *find_css_set(
 
 	/* First see if we already have a cgroup group that matches
 	 * the desired set */
-	write_lock(&css_set_lock);
+	read_lock(&css_set_lock);
 	res = find_existing_css_set(oldcg, cgrp, template);
 	if (res)
 		get_css_set(res);
-	write_unlock(&css_set_lock);
+	read_unlock(&css_set_lock);
 
 	if (res)
 		return res;
-- 1.5.4.rc3


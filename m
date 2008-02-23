Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYBWXaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYBWXaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbYBWX1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:27:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5175 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbYBWX1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:27:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=spslOzaBSRd7dFgdgzqCmZ1hBbXJj9X2D15LqH/RHcVLFIerTcBhOe05WsFsH9Kue
	dRH9NYdSjr+MKP8jLqPxQ==
Message-Id: <20080223232618.438358000@menage.corp.google.com>
References: <20080223224725.115590000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Sat, 23 Feb 2008 14:47:33 -0800
From: menage@google.com
To: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 08/10] CGroup API files: Drop mem_cgroup_force_empty()
Content-Disposition: inline; filename=drop_mem_cgroup_force_empty.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function isn't needed - a NULL pointer in the cftype read
function will result in the same EINVAL response to userspace.

Signed-off-by: Paul Menage <menage@google.com>

---
 mm/memcontrol.c |   14 --------------
 1 file changed, 14 deletions(-)

Index: cgroup-2.6.25-rc2-mm1/mm/memcontrol.c
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/mm/memcontrol.c
+++ cgroup-2.6.25-rc2-mm1/mm/memcontrol.c
@@ -950,19 +950,6 @@ static ssize_t mem_force_empty_write(str
 	return ret;
 }
 
-/*
- * Note: This should be removed if cgroup supports write-only file.
- */
-
-static ssize_t mem_force_empty_read(struct cgroup *cont,
-				struct cftype *cft,
-				struct file *file, char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
-{
-	return -EINVAL;
-}
-
-
 static const struct mem_cgroup_stat_desc {
 	const char *msg;
 	u64 unit;
@@ -1019,7 +1006,6 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "force_empty",
 		.write = mem_force_empty_write,
-		.read = mem_force_empty_read,
 	},
 	{
 		.name = "stat",

--

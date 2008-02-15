Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbYBOUxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbYBOUxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbYBOUxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:53:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:61774 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYBOUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:53:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=vW6tWkziDbQJxkWRUB/XRqLI1K8IowjPMBwfju9w902b7VRiZ/C/q5AiUK4rNe5E5
	+62VbQW9luxRZoRDLx4RA==
Message-Id: <20080215204821.606063000@menage.corp.google.com>
References: <20080215204418.535025000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Fri, 15 Feb 2008 12:44:24 -0800
From: Paul Menage <menage@google.com>
To: balbir@in.ibm.com, pj@sgi.com, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 6/7] CGroup API: Use descriptions for memory controller API files
Content-Disposition: inline; filename=memcontrol-use-api.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds descriptions to the memory controller API files to
indicate that the usage/limit are in bytes; the names of the control
files can then be simplified to usage/limit.

Also removes the unnecessary mem_force_empty_read() function

Signed-off-by: Paul Menage <menage@google.com>

---
 mm/memcontrol.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

Index: cgroupmap-2.6.24-mm1/mm/memcontrol.c
===================================================================
--- cgroupmap-2.6.24-mm1.orig/mm/memcontrol.c
+++ cgroupmap-2.6.24-mm1/mm/memcontrol.c
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
@@ -1001,15 +988,17 @@ static int mem_control_stat_show(struct 
 
 static struct cftype mem_cgroup_files[] = {
 	{
-		.name = "usage_in_bytes",
+		.name = "usage",
 		.private = RES_USAGE,
 		.read_uint = mem_cgroup_read,
+		.desc = "Memory usage in bytes",
 	},
 	{
-		.name = "limit_in_bytes",
+		.name = "limit",
 		.private = RES_LIMIT,
 		.write = mem_cgroup_write,
 		.read_uint = mem_cgroup_read,
+		.desc = "Memory limit in bytes",
 	},
 	{
 		.name = "failcnt",
@@ -1019,7 +1008,7 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "force_empty",
 		.write = mem_force_empty_write,
-		.read = mem_force_empty_read,
+		.desc = "Write to this file to forget all memory charges"
 	},
 	{
 		.name = "stat",

--

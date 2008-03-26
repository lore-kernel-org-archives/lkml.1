Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbYCZSZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbYCZSZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761728AbYCZSYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:24:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:10349 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761704AbYCZSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Vgx8iyP849idw+u68104YhJdODHR+K6pqc5lwwT7b5mUcFjxakD71KA0QgWeu6fsKZm6MVBK9vRkYJcIqtJfCdcIm1hlfsFVlR11IxnKeaVDA5jAV5pYTgzkSBhnw6hU1a5VloG56fjZDH0wMaOQTwXCLZmlzAm29N76C3LNCCc=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: linux-kernel@vger.kernel.org
Subject: [RFC][-mm] [2/2] Simple stats for memory resource controller
Date: Wed, 26 Mar 2008 23:48:59 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: containers@lists.osdl.org, menage@google.com, balbir@in.ibm.com,
       dhaval@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803262348.59785.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements trivial statistics for the memory resource controller.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>


diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eb681a6..84f3fe5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -45,6 +45,8 @@ enum mem_cgroup_stat_index {
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
+	MEM_CGROUP_STAT_PGIN_COUNT,	/* # of pages paged in */
+	MEM_CGROUP_STAT_PGOUT_COUNT,	/* # of pages paged out */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -196,6 +198,13 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem, int flags,
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
 	else
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
+
+	if (charge)
+		__mem_cgroup_stat_add_safe(stat,
+				MEM_CGROUP_STAT_PGIN_COUNT, 1);
+	else
+		__mem_cgroup_stat_add_safe(stat,
+				MEM_CGROUP_STAT_PGOUT_COUNT, 1);
 }
 
 static struct mem_cgroup_per_zone *
@@ -886,6 +895,8 @@ static const struct mem_cgroup_stat_desc {
 } mem_cgroup_stat_desc[] = {
 	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
 	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
+	[MEM_CGROUP_STAT_PGIN_COUNT] = {"page_in_count", 1, },
+	[MEM_CGROUP_STAT_PGOUT_COUNT] = {"page_out_count", 1, },
 };
 
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,

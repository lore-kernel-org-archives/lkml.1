Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXCFT0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXCFT0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932315AbXCFT0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:26:05 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:46559 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbXCFT0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:26:02 -0500
Subject: [Patch] fix parsing of statistics type-attribute
From: Martin Peschke <mp3@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Wu Fengguang <wfg@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 20:26:00 +0100
Message-Id: <1173209160.5266.17.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Without this fix the the statistics user interface accepted, for example:

	echo name=my_stats type=utilisa > definition

while it should only accept:

	echo name=my_stats type=utilisation > definition


Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 statistic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/lib/statistic.c
===================================================================
--- linux.orig/lib/statistic.c
+++ linux/lib/statistic.c
@@ -506,7 +506,8 @@ static int statistic_parse_match(struct 
 		len = (args[0].to - args[0].from);
 		for (type = 0; type < STAT_NONE; type++) {
 			disc = &statistic_discs[type];
-			if (unlikely(strncmp(disc->name, args[0].from, len)))
+			if (strlen(disc->name) != len ||
+			    strncmp(disc->name, args[0].from, len))
 				continue;
 			return statistic_parse_single(stat, info, def, type);
 		}



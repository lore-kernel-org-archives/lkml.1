Return-Path: <linux-kernel-owner+w=401wt.eu-S932865AbXCFTNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbXCFTNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932881AbXCFTNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:13:19 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:46331 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbXCFTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:13:18 -0500
Subject: [Patch] small lib/parser.c cleanup
From: Martin Peschke <mp3@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Wu Fengguang <wfg@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 20:13:15 +0100
Message-Id: <1173208395.5266.5.camel@dix>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

simplifying code by using available string duplication function

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 parser.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux/lib/parser.c
===================================================================
--- linux.orig/lib/parser.c
+++ linux/lib/parser.c
@@ -126,11 +126,9 @@ static int match_number(substring_t *s, 
 	char *buf;
 	int ret;
 
-	buf = kmalloc(s->to - s->from + 1, GFP_KERNEL);
+	buf = match_strdup(s);
 	if (!buf)
 		return -ENOMEM;
-	memcpy(buf, s->from, s->to - s->from);
-	buf[s->to - s->from] = '\0';
 	*result = simple_strtol(buf, &endp, base);
 	ret = 0;
 	if (endp == buf)
@@ -155,11 +153,9 @@ int match_s64(substring_t *s, s64 *resul
 	char *buf;
 	int ret;
 
-	buf = kmalloc(s->to - s->from + 1, GFP_KERNEL);
+	buf = match_strdup(s);
 	if (!buf)
 		return -ENOMEM;
-	memcpy(buf, s->from, s->to - s->from);
-	buf[s->to - s->from] = '\0';
 	*result = simple_strtoll(buf, &endp, base);
 	ret = 0;
 	if (endp == buf)



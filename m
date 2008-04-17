Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYDQDdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYDQDdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 23:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYDQDd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 23:33:26 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:59511 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYDQDdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 23:33:25 -0400
Message-ID: <4806C501.20300@tiscali.nl>
Date: Thu, 17 Apr 2008 05:33:21 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: hadi@cyberus.ca, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] NET: catch signed nla_len() retval in tcf_simp_init()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'datalen' is unsigned, use 'ret' instead to catch a negative return value.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index fbde461..b78d015 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -114,9 +114,10 @@ static int tcf_simp_init(struct nlattr *nla, struct nlattr *est,
 	if (defdata == NULL)
 		return -EINVAL;
 
-	datalen = nla_len(tb[TCA_DEF_DATA]);
-	if (datalen <= 0)
+	ret = nla_len(tb[TCA_DEF_DATA]);
+	if (ret <= 0)
 		return -EINVAL;
+	datalen = ret;
 
 	pc = tcf_hash_check(parm->index, a, bind, &simp_hash_info);
 	if (!pc) {

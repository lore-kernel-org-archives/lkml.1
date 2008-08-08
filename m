Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYHHP33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYHHP33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYHHP3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:29:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:35753 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYHHP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=bZUHTUNAjoNCpO8qe6Ajux5J17j0G8mQy4RMPle8/KMfAN/56QVRE03J+kdaeqeOoX
         bNg7BF8oElRg6M3sbl+YGh2xM2Sv5qvA0520HZXbpKjHJ7W2cw3p4o9rL/E6wHtLnlp0
         qFMCTJYtbTirphlHQf3p8zGHYJRQpIGwwWTU0=
Message-ID: <b9df5fa10808080829l6275a208u65b3c48dafe6c8e1@mail.gmail.com>
Date: Fri, 8 Aug 2008 21:29:19 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Paul Menage" <menage@google.com>, "Paul Jackson" <pj@sgi.com>
Subject: [PATCH] cgroup.c: Some 'hlist_head' function fixes.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys, the following patch emphasizes on two things:
	1. We can carry out the following function with one variable.
	2. As hash_long returns with unsigned long we need a unsigned long to
handle this.
If anything else, please notice.
Thanks.

Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)

--- linux-2.6.27-rc2.orig/kernel/cgroup.c	2008-08-06 16:23:26.000000000 +0600
+++ linux-2.6.27-rc2/kernel/cgroup.c	2008-08-08 19:06:53.000000000 +0600
@@ -200,17 +200,16 @@ static struct hlist_head css_set_table[C

 static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
 {
-	int i;
-	int index;
-	unsigned long tmp = 0UL;
+	unsigned long tmp = 0UL , i;

 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
 		tmp += (unsigned long)css[i];
 	tmp = (tmp >> 16) ^ tmp;

-	index = hash_long(tmp, CSS_SET_HASH_BITS);
+	i = 0;
+	i = hash_long(tmp, CSS_SET_HASH_BITS);

-	return &css_set_table[index];
+	return &css_set_table[i];
 }

 /* We don't maintain the lists running through each css_set to its

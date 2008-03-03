Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbYCCVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbYCCVYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763329AbYCCVWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:22:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763041AbYCCVWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:22:46 -0500
From: Josef Bacik <jbacik@redhat.com>
To: linux-ext4@vger.kernel.org
Subject: [PATCH] fix mount option parsing for ext3/4
Date: Mon, 3 Mar 2008 16:10:08 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031610.09145.jbacik@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Noticed that the "resize" option won't be noticed as it comes after the NULL 
option, so if you try to mount (or in this case remount) with that option it 
won't be recognized.  Both ext3 and ext4 have this problem.  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>

Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c
+++ linux-2.6/fs/ext3/super.c
@@ -806,8 +806,8 @@ static match_table_t tokens = {
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
-	{Opt_err, NULL},
 	{Opt_resize, "resize"},
+	{Opt_err, NULL},
 };
 
 static ext3_fsblk_t get_sb_block(void **data)
Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c
+++ linux-2.6/fs/ext4/super.c
@@ -944,8 +944,8 @@ static match_table_t tokens = {
 	{Opt_mballoc, "mballoc"},
 	{Opt_nomballoc, "nomballoc"},
 	{Opt_stripe, "stripe=%u"},
-	{Opt_err, NULL},
 	{Opt_resize, "resize"},
+	{Opt_err, NULL},
 };
 
 static ext4_fsblk_t get_sb_block(void **data)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYKUPWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYKUPWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYKUPVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:21:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:22603 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYKUPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:21:51 -0500
Message-ID: <154e089b0811210721i35738ef3yf4f1cd5b340a6cf0@mail.gmail.com>
Date: Fri, 21 Nov 2008 16:21:49 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Cheng Renquan" <crquan@gmail.com>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] md: fix compilation warning: left shift count >= width of type
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings:

drivers/md/md.c:1678: warning: left shift count >= width of type
drivers/md/md.c:1702: warning: left shift count >= width of type

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 include/linux/raid/md_p.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 269e147..9491026 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -194,7 +194,7 @@ static inline __u64 md_event(mdp_super_t *sb) {
 	return (ev<<32)| sb->events_lo;
 }

-#define MD_SUPERBLOCK_1_TIME_SEC_MASK ((1UL<<40) - 1)
+#define MD_SUPERBLOCK_1_TIME_SEC_MASK ((1ULL<<40) - 1)

 /*
  * The version-1 superblock :

Return-Path: <linux-kernel-owner+w=401wt.eu-S932421AbZJHOrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbZJHOrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932402AbZJHOrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:47:03 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:57977 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbZJHOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:47:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gY5uhUSkgHFmuq+o3o4Lu09VU2dxpKlAWbxnASLmuVt2l6KPekc+09VOb57O5NDcLf
         gn3g8puv2rlf3BkwyI5hSDOPUWlWtrGq/ZsRn/cToL6CpVzrlxWVRGx/+cQey0bksyAq
         kkwA7Il9cIcuc/RELy1LxoRxNSiT9EjlRes5A=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH] kernel/time/tick-sched.c: fix warning of printk's argument format
Date: Thu,  8 Oct 2009 22:46:12 +0800
Message-Id: <1255013172-31599-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will fix the following warning:

kernel/time/tick-sched.c: In function 'tick_nohz_stop_sched_tick':
kernel/time/tick-sched.c:261: warning: format '%02x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e0f59a2..26370b0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -257,7 +257,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		static int ratelimit;
 
 		if (ratelimit < 10) {
-			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
+			printk(KERN_ERR "NOHZ: local_softirq_pending %02lx\n",
 			       local_softirq_pending());
 			ratelimit++;
 		}
-- 
1.6.2.1


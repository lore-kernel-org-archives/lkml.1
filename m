Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZFZIQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZFZIQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZFZIQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:16:26 -0400
Received: from mail-pz0-f202.google.com ([209.85.222.202]:58742 "EHLO
	mail-pz0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZFZIQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DgkdBRs5ZC9JBCFMoOHxNcOY4vxXi2QZjWLiJHdth8It4qAEg/dbZ6gAzmiWJzar2M
         NIxzuUxbZdz5f2/mgJkVzwb0A2JKGvZoRg4+uz5cVJuE/oJL8LoKcxrnyjWTtJpte5nJ
         D97eelw7gV5chEpk2KLb2a2w9wO1WXYJX/MF4=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Wu Zhangjin <wuzj@lemote.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -rt] softirq: fix undefined rate_limit in softirq_check_pending_idle
Date: Fri, 26 Jun 2009 15:46:13 +0800
Message-Id: <e1ad7dd41b964ad729595fc97ad8c4b26a119de4.1246002312.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

on !PREEMPT_RT, there is a defined ratelimit in
softirq_check_pending_idel(), but used as rate_limit, so, defining
rate_limit instead of ratelimit will fix it.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 kernel/softirq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 00b4638..38b44c9 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -155,9 +155,9 @@ void softirq_check_pending_idle(void)
  */
 void softirq_check_pending_idle(void)
 {
-	static int ratelimit;
+	static int rate_limit;
 
-	if (ratelimit < 10) {
+	if (rate_limit < 10) {
 		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
 		       local_softirq_pending());
 		rate_limit++;
-- 
1.6.0.4


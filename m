Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655Ab0AaL5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab0AaL5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 06:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347Ab0AaL5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 06:57:04 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:64335 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0AaL5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 06:57:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CJLlzpWIWraWxUrFwiKSOh6tY8AIx+mG5cE/jkBhueCvzGtJ8g6UASb8sVGQFEi3wy
         Hold0BNRjRsAljH3AYxIUWDMfG8DsmYcg2d6eq8F0TvACYIeLolh0I5vD98Kbvc0rufZ
         rMp+17CDeqiorxRHoKjZms5WF8PMUF9dRllTs=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/7] sched: Use for_each_bit
Date: Sun, 31 Jan 2010 20:53:24 +0900
Message-Id: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_cpupri.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 597b330..eeb3506 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -47,9 +47,7 @@ static int convert_prio(int prio)
 }
 
 #define for_each_cpupri_active(array, idx)                    \
-  for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);     \
-       idx < CPUPRI_NR_PRIORITIES;                            \
-       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
+	for_each_bit(idx, array, CPUPRI_NR_PRIORITIES)
 
 /**
  * cpupri_find - find the best (lowest-pri) CPU in the system
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZGGPZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZGGPZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbZGGPZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:25:32 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:39120 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbZGGPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Op2HYGyByDjNMK4CtpBxwFhMuhQK1LuUChZxroC66BL5YEkD/tQ2lirSuslVHqPN4w
         Udn+Gjus0wnuUKUmjePuPwjHlz47GCmk5swgvPFd9ASzVybB1KkrtpIuj9aMp64M2R1h
         WwvlUo3Kh+CP/aw7vrOCnSmDTWM77NDQIBH6g=
MIME-Version: 1.0
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 7 Jul 2009 16:25:08 +0100
Message-ID: <a5d9929e0907070825q41de40eeo5e337a4885615909@mail.gmail.com>
Subject: [PATCH 2/3] Increase lockdep limits: MAX_LOCK_DEPTH
To: LKML <linux-kernel@vger.kernel.org>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to current Linus tree, as of 2.6.31-rc2)

As a result of increasing MAX_STACK_TRACE_ENTRIES on the previous
patch, another limit surfaced as being hit too soon.
This patch increases MAX_LOCK_DEPTH, being hit by false positives, and
turning off the locking correctness validator.

The new value is arbitrary, but I believe the old one was too. Given
the amount of changes happening with regards to the usage of lockdep,
the previous limit is just too low and keeping it that way would
defeat the purpose of lockdep.


Signed-off-by: Joao Correia <joaomiguelcorreia@gmail.com>

---
 include/linux/sched.h |    2 +-
 1 files changes, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0085d75..304231b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1367,7 +1367,7 @@ struct task_struct {
        int softirq_context;
 #endif
 #ifdef CONFIG_LOCKDEP
-# define MAX_LOCK_DEPTH 48UL
+# define MAX_LOCK_DEPTH 96UL
        u64 curr_chain_key;
        int lockdep_depth;
        unsigned int lockdep_recursion;
---

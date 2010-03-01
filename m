Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0CAS4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:56:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:18626 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab0CAS4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:56:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=eeMzNAvRA0r3mgGU4VquJ9Bv7x+9t5eRIncm4KYbNX1TyzFgHnz0yuLH4X0rMdr+KB
         f9n5/HKcDjSsZsgofCAyIiIvQ/PueGrYIm7RMkfyAgd7LtO64IhaL9KgLTCWgqlWws5v
         SjitOOr/dueMbGe7deiITwx8uE2ZvVNgTXG4Q=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 4/5] lib: fix atomic64_inc_not_zero test
Date: Mon,  1 Mar 2010 19:55:48 +0100
Message-Id: <1267469749-11878-5-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic64_inc_not_zero must return 1 if it perfomed the add and 0 otherwise.
The test assumed the opposite convention.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 lib/atomic64_test.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index ee8e6de..f7bb706 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -130,16 +130,16 @@ static __init int test_atomic64(void)
 #endif
 
 	INIT(onestwos);
-	BUG_ON(atomic64_inc_not_zero(&v));
+	BUG_ON(!atomic64_inc_not_zero(&v));
 	r += one;
 	BUG_ON(v.counter != r);
 
 	INIT(0);
-	BUG_ON(!atomic64_inc_not_zero(&v));
+	BUG_ON(atomic64_inc_not_zero(&v));
 	BUG_ON(v.counter != r);
 
 	INIT(-one);
-	BUG_ON(atomic64_inc_not_zero(&v));
+	BUG_ON(!atomic64_inc_not_zero(&v));
 	r += one;
 	BUG_ON(v.counter != r);
 
-- 
1.6.6.1.476.g01ddb


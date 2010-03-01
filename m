Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab0CARaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:30:35 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65202 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0CARac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:30:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=b2Em4S/+kZbcTGeqvGPcMk4UpI8mln/6fl5RvgB7Xrz633qtTe0Vuju8G0k8ZGERxR
         1MPdcbPx9oKDgcJPbk1oGUnyPwsI1A7RFw0fxYSK3+ngsj4ddtEuwDSXRNzJmLpKqQ/6
         Siyu5fSg/4fngmH5vaLU1LJKD4QAoh+h7UmBM=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 1/2] lib: fix atomic64_inc_not_zero test
Date: Mon,  1 Mar 2010 18:30:18 +0100
Message-Id: <1267464619-6784-2-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267464619-6784-1-git-send-email-luca@luca-barbieri.com>
References: <1267464619-6784-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buggy like atomic64_add_unless

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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0CAS4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:56:52 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41232 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab0CASzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dmVot8+u5L33/CA3dhZTfuNXXCWDDzLn8wAKunPPz+BApytLE+lIBb5YaxE4wswQMJ
         q1gE4aGY1foStdDkYrJG2zhnYUrvjbPItjAOFl41A+uZoKh/XF8iDuSDoWIk6Rnl30ua
         WYzglIlAyeuDkdiusAzdn/CU8fgBZDGj1da+k=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 1/5] lib: fix atomic64_add_unless test
Date: Mon,  1 Mar 2010 19:55:45 +0100
Message-Id: <1267469749-11878-2-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic64_add_unless must return 1 if it perfomed the add and 0 otherwise.
The test assumed the opposite convention.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 lib/atomic64_test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 58efdab..ee8e6de 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -104,11 +104,11 @@ static __init int test_atomic64(void)
 	BUG_ON(v.counter != r);
 
 	INIT(v0);
-	BUG_ON(!atomic64_add_unless(&v, one, v0));
+	BUG_ON(atomic64_add_unless(&v, one, v0));
 	BUG_ON(v.counter != r);
 
 	INIT(v0);
-	BUG_ON(atomic64_add_unless(&v, one, v1));
+	BUG_ON(!atomic64_add_unless(&v, one, v1));
 	r += one;
 	BUG_ON(v.counter != r);
 
-- 
1.6.6.1.476.g01ddb


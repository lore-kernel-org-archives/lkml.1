Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab0CARPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:15:48 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:43229 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0CARPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:15:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=O3TxBdHnasbBM7xDu60jwmZ1ylji++c5DhTXrSFqe8y5ISweOXDulVCOd7+rXOlge0
         njHIIZkuZUT1EYHhJiT/Zbg6iOyUQyFzmAwlJndiw0Fx0gbaLsr2mf6EN+Rh/rBUZFmS
         889gtMir4QWurwFCA+p1t+wQvBy1WjGUhORH0=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 1/3] lib: fix atomic64_add_unless test
Date: Mon,  1 Mar 2010 18:14:58 +0100
Message-Id: <1267463700-25524-2-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267463700-25524-1-git-send-email-luca@luca-barbieri.com>
References: <1267463700-25524-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was buggy as it replicated the bug in lib/atomic64.c

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


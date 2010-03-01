Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab0CAT7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:59:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:37705 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab0CAT7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:59:15 -0500
Date: Mon, 1 Mar 2010 19:58:53 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267469749-11878-5-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-5-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] lib: Fix atomic64_inc_not_zero test
Message-ID: <tip-25a304f277ad70166eeae25a4958d2049005c33a@git.kernel.org>
Git-Commit-ID: 25a304f277ad70166eeae25a4958d2049005c33a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:58:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25a304f277ad70166eeae25a4958d2049005c33a
Gitweb:     http://git.kernel.org/tip/25a304f277ad70166eeae25a4958d2049005c33a
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Mon, 1 Mar 2010 19:55:48 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 11:39:02 -0800

lib: Fix atomic64_inc_not_zero test

atomic64_inc_not_zero must return 1 if it perfomed the add and 0 otherwise.
The test assumed the opposite convention.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267469749-11878-5-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 

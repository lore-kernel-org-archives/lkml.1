Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0CAT6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:58:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:40105 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab0CAT6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:58:17 -0500
Date: Mon, 1 Mar 2010 19:58:07 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267469749-11878-2-git-send-email-luca@luca-barbieri.com>
References: <1267469749-11878-2-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] lib: Fix atomic64_add_unless test
Message-ID: <tip-9efbcd590243045111670c171a951923b877b57d@git.kernel.org>
Git-Commit-ID: 9efbcd590243045111670c171a951923b877b57d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:58:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9efbcd590243045111670c171a951923b877b57d
Gitweb:     http://git.kernel.org/tip/9efbcd590243045111670c171a951923b877b57d
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Mon, 1 Mar 2010 19:55:45 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 11:38:46 -0800

lib: Fix atomic64_add_unless test

atomic64_add_unless must return 1 if it perfomed the add and 0 otherwise.
The test assumed the opposite convention.

Reported-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267469749-11878-2-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 

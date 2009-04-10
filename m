Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbZDJUH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbZDJUH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZDJUHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:07:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:50355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZDJUHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:07:01 -0400
Date: Fri, 10 Apr 2009 20:06:36 GMT
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, williams@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, williams@redhat.com, tglx@linutronix.de
In-Reply-To: <20090410165005.14342.16973.stgit@Aeon>
References: <20090410165005.14342.16973.stgit@Aeon>
Subject: [tip:core/futexes] futex: fix futex_wait_setup key handling
Message-ID: <tip-a5a2a0c7fa039c59619bc908b3b1ed24734d442a@git.kernel.org>
Git-Commit-ID: a5a2a0c7fa039c59619bc908b3b1ed24734d442a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 20:06:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5a2a0c7fa039c59619bc908b3b1ed24734d442a
Gitweb:     http://git.kernel.org/tip/a5a2a0c7fa039c59619bc908b3b1ed24734d442a
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Fri, 10 Apr 2009 09:50:05 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 10 Apr 2009 22:04:24 +0200

futex: fix futex_wait_setup key handling

If the get_futex_key() call were to fail, the existing code would
try and put_futex_key() prior to returning.  This patch makes sure
we only put_futex_key() if get_futex_key() succeeded.

Reported-by: Clark Williams <williams@redhat.com>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
LKML-Reference: <20090410165005.14342.16973.stgit@Aeon>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 kernel/futex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 041bf3a..6d2daa4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1668,7 +1668,7 @@ retry:
 	q->key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q->key);
 	if (unlikely(ret != 0))
-		goto out;
+		return ret;
 
 retry_private:
 	*hb = queue_lock(q);

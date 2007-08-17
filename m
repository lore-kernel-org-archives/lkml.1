Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbXHQTez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbXHQTez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXHQTet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:34:49 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51074 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXHQTes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:34:48 -0400
Date: Fri, 17 Aug 2007 23:34:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH,RESEND] documentation: atomic_add_unless() doesn't imply mb() on failure
Message-ID: <20070817193453.GA198@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(the explicit ack/nack from maintainers is wanted).

A "typical" implementation of atomic_add_unless() can return 0 immediately
after the first atomic_read() (before doing cmpxchg). In that case it doesn't
provide any barrier semantics. See include/asm-ia64/atomic.h as an example.

We should either change the implementation, or fix the docs.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

 Documentation/atomic_ops.txt      |    3 ++-
 Documentation/memory-barriers.txt |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/atomic_ops.txt~doc-atomic_add_unless-doesnt-imply-mb-on-failure Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~doc-atomic_add_unless-doesnt-imply-mb-on-failure
+++ a/Documentation/atomic_ops.txt
@@ -137,7 +137,8 @@ If the atomic value v is not equal to u,
 returns non zero. If v is equal to u then it returns zero. This is done as
 an atomic operation.
 
-atomic_add_unless requires explicit memory barriers around the operation.
+atomic_add_unless requires explicit memory barriers around the operation
+unless it fails (returns 0).
 
 atomic_inc_not_zero, equivalent to atomic_add_unless(v, 1, 0)
 
diff -puN Documentation/memory-barriers.txt~doc-atomic_add_unless-doesnt-imply-mb-on-failure Documentation/memory-barriers.txt
--- a/Documentation/memory-barriers.txt~doc-atomic_add_unless-doesnt-imply-mb-on-failure
+++ a/Documentation/memory-barriers.txt
@@ -1492,7 +1492,7 @@ about the state (old or new) implies an 
 	atomic_dec_and_test();
 	atomic_sub_and_test();
 	atomic_add_negative();
-	atomic_add_unless();
+	atomic_add_unless();	/* when succeeds (returns 1) */
 	test_and_set_bit();
 	test_and_clear_bit();
 	test_and_change_bit();
_


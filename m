Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZKFWW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZKFWW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760094AbZKFWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:26 -0500
Received: from kroah.org ([198.145.64.141]:56659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760073AbZKFWWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:25 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:40 2009
Message-Id: <20091106221540.027407931@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [10/99] futex: Check for NULL keys in match_futex
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=futex-check-for-null-keys-in-match_futex.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Darren Hart <dvhltc@us.ibm.com>

commit 2bc872036e1c5948b5b02942810bbdd8dbdb9812 upstream.

If userspace tries to perform a requeue_pi on a non-requeue_pi waiter,
it will find the futex_q->requeue_pi_key to be NULL and OOPS.

Check for NULL in match_futex() instead of doing explicit NULL pointer
checks on all call sites.  While match_futex(NULL, NULL) returning
false is a little odd, it's still correct as we expect valid key
references.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <4AD60687.10306@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -150,7 +150,8 @@ static struct futex_hash_bucket *hash_fu
  */
 static inline int match_futex(union futex_key *key1, union futex_key *key2)
 {
-	return (key1->both.word == key2->both.word
+	return (key1 && key2
+		&& key1->both.word == key2->both.word
 		&& key1->both.ptr == key2->both.ptr
 		&& key1->both.offset == key2->both.offset);
 }



Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXHGVIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXHGVIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935680AbXHGUxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:53:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59452 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935402AbXHGUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:53:18 -0400
Date: Tue, 7 Aug 2007 13:46:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, schwab@suse.de, mingo@elte.hu,
       drepper@redhat.com
Subject: [2.6.22.2 review 42/84] futex: pass nr_wake2 to futex_wake_op
Message-ID: <20070807204644.GR23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="futex-pass-nr_wake2-to-futex_wake_op.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Andreas Schwab <schwab@suse.de>

The fourth argument of sys_futex is ignored when op == FUTEX_WAKE_OP,
but futex_wake_op expects it as its nr_wake2 parameter.

The only user of this operation in glibc is always passing 1, so this
bug had no consequences so far.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2061,8 +2061,10 @@ asmlinkage long sys_futex(u32 __user *ua
 	}
 	/*
 	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
+	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
 	 */
-	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_WAKE_OP)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);

-- 

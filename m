Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbXGGPDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbXGGPDC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 11:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXGGPCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 11:02:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:33691 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXGGPCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 11:02:54 -0400
From: Andreas Schwab <schwab@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Pass nr_wake2 to futex_wake_op
Cc: linux-kernel@vger.kernel.org
X-Yow: Now, my ENTIRE LIFE is flashing before my EYES as I park my DODGE
 DART in your EXXON service area for a COMPLETE LUBRICATION!!
Date: Sat, 07 Jul 2007 17:02:53 +0200
Message-ID: <jeir8wcl42.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The fourth argument of sys_futex is ignored when op == FUTEX_WAKE_OP,
but futex_wake_op expects it as its nr_wake2 parameter.

The only user of this operation in glibc is always passing 1, so this
bug had no consequences so far.

Signed-off-by: Andreas Schwab <schwab@suse.de>

---
 kernel/futex.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.22-rc7.orig/kernel/futex.c	2007-07-02 00:40:44.000000000 +0200
+++ linux-2.6.22-rc7/kernel/futex.c	2007-07-07 15:56:42.000000000 +0200
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
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

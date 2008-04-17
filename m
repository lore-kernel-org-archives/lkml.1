Return-Path: <linux-kernel-owner+w=401wt.eu-S933910AbYDQB2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910AbYDQB2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbYDQBJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:35 -0400
Received: from sous-sol.org ([216.99.217.87]:59008 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758912AbYDQBJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:34 -0400
Message-Id: <20080417010353.692177152@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>
Subject: SPARC64: Fix FPU saving in 64-bit signal handling.
Content-Disposition: inline; filename=sparc64-fix-fpu-saving-in-64-bit-signal-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commit: 7c3cce978e4f933ac13758ec5d2554fc8d0927d2

The calculation of the FPU reg save area pointer
was wrong.

Based upon an OOPS report from Tom Callaway.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/sparc64/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc64/kernel/signal.c
+++ b/arch/sparc64/kernel/signal.c
@@ -354,7 +354,7 @@ static int invalid_frame_pointer(void __
 static inline int
 save_fpu_state(struct pt_regs *regs, __siginfo_fpu_t __user *fpu)
 {
-	unsigned long *fpregs = (unsigned long *)(regs+1);
+	unsigned long *fpregs = current_thread_info()->fpregs;
 	unsigned long fprs;
 	int err = 0;
 	

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbYHRTi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbYHRTi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765002AbYHRTfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:35:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:41530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762440AbYHRTft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:35:49 -0400
Date: Mon, 18 Aug 2008 12:20:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 26/49] sparc64: Do not clobber %g7 in setcontext() trap.
Message-ID: <20080818192014.GA10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-do-not-clobber-g7-in-setcontext-trap.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 0a4949c4414af2eb91414bcd8e2a8ac3706f7dde ]

That's the userland thread register, so we should never try to change
it like this.

Based upon glibc bug nptl/6577 and suggestions by Jakub Jelinek.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/signal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/sparc64/kernel/signal.c
+++ b/arch/sparc64/kernel/signal.c
@@ -2,7 +2,7 @@
  *  arch/sparc64/kernel/signal.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
- *  Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
+ *  Copyright (C) 1995, 2008 David S. Miller (davem@davemloft.net)
  *  Copyright (C) 1996 Miguel de Icaza (miguel@nuclecu.unam.mx)
  *  Copyright (C) 1997 Eddie C. Dost   (ecd@skynet.be)
  *  Copyright (C) 1997,1998 Jakub Jelinek   (jj@sunsite.mff.cuni.cz)
@@ -90,7 +90,9 @@ asmlinkage void sparc64_set_context(stru
 	err |= __get_user(regs->u_regs[UREG_G4], (&(*grp)[MC_G4]));
 	err |= __get_user(regs->u_regs[UREG_G5], (&(*grp)[MC_G5]));
 	err |= __get_user(regs->u_regs[UREG_G6], (&(*grp)[MC_G6]));
-	err |= __get_user(regs->u_regs[UREG_G7], (&(*grp)[MC_G7]));
+
+	/* Skip %g7 as that's the thread register in userspace.  */
+
 	err |= __get_user(regs->u_regs[UREG_I0], (&(*grp)[MC_O0]));
 	err |= __get_user(regs->u_regs[UREG_I1], (&(*grp)[MC_O1]));
 	err |= __get_user(regs->u_regs[UREG_I2], (&(*grp)[MC_O2]));

-- 

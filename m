Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbYLKTWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbYLKTWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYLKTSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:17 -0500
Received: from kroah.org ([198.145.64.141]:55869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756645AbYLKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:04 -0500
Date: Thu, 11 Dec 2008 11:13:50 -0800
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
Subject: [patch 10/83] sparc64: Fix bug in PTRACE_SETFPREGS64 handling.
Message-ID: <20081211191350.GJ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0004-sparc64-Fix-bug-in-PTRACE_SETFPREGS64-handling.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Torek <chris.torek@windriver.com>

[ Upstream commit 5769907ade8dda7002b304c03ef9e4ee5c1e0821 ]

From: Chris Torek <chris.torek@windriver.com>

>The SPARC64 kernel code for PTRACE_SETFPREGS64 appears to be an exact copy
>of that for PTRACE_GETFPREGS64.  This means that gdbserver and native
>64-bit GDB cannot set floating-point registers.

It looks like a simple typo.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc64/kernel/ptrace.c
+++ b/arch/sparc64/kernel/ptrace.c
@@ -1014,7 +1014,7 @@ long arch_ptrace(struct task_struct *chi
 		break;
 
 	case PTRACE_SETFPREGS64:
-		ret = copy_regset_to_user(child, view, REGSET_FP,
+		ret = copy_regset_from_user(child, view, REGSET_FP,
 					  0 * sizeof(u64),
 					  33 * sizeof(u64),
 					  fps);


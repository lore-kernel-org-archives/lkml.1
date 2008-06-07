Return-Path: <linux-kernel-owner+w=401wt.eu-S1764388AbYFGB05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764388AbYFGB05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbYFGBJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:51 -0400
Received: from sous-sol.org ([216.99.217.87]:42576 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759543AbYFGBJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:35 -0400
Message-Id: <20080607010601.650158333@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:30 -0700
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
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/50] x86: user_regset_view table fix for ia32 on 64-bit
Content-Disposition: inline; filename=x86-user_regset_view-table-fix-for-ia32-on-64-bit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Roland McGrath <roland@redhat.com>

commit 1f465f4e475454b8bb590846c50a9d16e8046f3d upstream

The user_regset_view table for the 32-bit regsets on the 64-bit build had
the wrong sizes for the FP regsets.  This bug had no user-visible effect
(just on kernel modules using the user_regset interfaces and the like).
But the fix is trivial and risk-free.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/x86/kernel/ptrace.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1382,6 +1382,9 @@ static const struct user_regset_view use
 #define genregs32_get		genregs_get
 #define genregs32_set		genregs_set
 
+#define user_i387_ia32_struct	user_i387_struct
+#define user32_fxsr_struct	user_fxsr_struct
+
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
@@ -1394,13 +1397,13 @@ static const struct user_regset x86_32_r
 	},
 	[REGSET_FP] = {
 		.core_note_type = NT_PRFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(u32),
+		.n = sizeof(struct user_i387_ia32_struct) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = fpregs_active, .get = fpregs_get, .set = fpregs_set
 	},
 	[REGSET_XFP] = {
 		.core_note_type = NT_PRXFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(u32),
+		.n = sizeof(struct user32_fxsr_struct) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},

-- 

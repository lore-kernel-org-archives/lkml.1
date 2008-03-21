Return-Path: <linux-kernel-owner+w=401wt.eu-S1763287AbYCUXuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763287AbYCUXuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbYCUXp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:59 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60211 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454AbYCUXp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:58 -0400
Message-Id: <20080321224401.569557855@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew G Morgan <morgan@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 34/76] file capabilities: simplify signal check
Content-Disposition: inline; filename=file-capabilities-simplify-signal-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Serge E. Hallyn <serue@us.ibm.com>

Simplify the uid equivalence check in cap_task_kill().  Anyone can kill a
process owned by the same uid.

Without this patch wireshark is reported to fail.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 security/commoncap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -539,7 +539,7 @@ int cap_task_kill(struct task_struct *p,
 	 * allowed.
 	 * We must preserve legacy signal behavior in this case.
 	 */
-	if (p->euid == 0 && p->uid == current->uid)
+	if (p->uid == current->uid)
 		return 0;
 
 	/* sigcont is permitted within same session */

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765027AbZCaXeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765027AbZCaXeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763987AbZCaXVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:34 -0400
Received: from sous-sol.org ([216.99.217.87]:33269 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764028AbZCaXVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:32 -0400
Message-Id: <20090331231744.552474410@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:24 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, xiyou.wangcong@gmail.com,
       Roland McGrath <roland@redhat.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 39/45] x86: ptrace, bts: fix an unreachable statement
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=x86-ptrace-bts-fix-an-unreachable-statement.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: xiyou.wangcong@gmail.com

upstream commit: 5a8ac9d28dae5330c70562c7d7785f5104059c17

Commit c2724775ce57c98b8af9694857b941dc61056516 put a statement
after return, which makes that statement unreachable.

Move that statement before return.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090313075622.GB8933@hack>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/ptrace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -690,9 +690,8 @@ static int ptrace_bts_config(struct task
 		if (!cfg.signal)
 			return -EINVAL;
 
-		return -EOPNOTSUPP;
-
 		child->thread.bts_ovfl_signal = cfg.signal;
+		return -EOPNOTSUPP;
 	}
 
 	if ((cfg.flags & PTRACE_BTS_O_ALLOC) &&


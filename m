Return-Path: <linux-kernel-owner+w=401wt.eu-S933706AbZINULq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbZINULq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933667AbZINULo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:11:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54213 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933678AbZINUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 71/72] Blackfin: update ftrace_push_return_trace() breakage
Date: Mon, 14 Sep 2009 16:08:15 -0400
Message-Id: <1252958896-25150-72-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 71e308a239c updated ftrace_push_return_trace() prototype but didn't
update the Blackfin ftrace code, so things broke.  Since we don't support
the new stuff yet, call it with stub values.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/ftrace.c b/arch/blackfin/kernel/ftrace.c
index 905bfc4..f2c85ac 100644
--- a/arch/blackfin/kernel/ftrace.c
+++ b/arch/blackfin/kernel/ftrace.c
@@ -24,7 +24,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		return;
 
-	if (ftrace_push_return_trace(*parent, self_addr, &trace.depth) == -EBUSY)
+	if (ftrace_push_return_trace(*parent, self_addr, &trace.depth, 0) == -EBUSY)
 		return;
 
 	trace.func = self_addr;
-- 
1.6.4.2


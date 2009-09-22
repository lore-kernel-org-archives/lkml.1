Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZIVTml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZIVTml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZIVTmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:42:38 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZIVTij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=twIkIuf5vnJWYEDwmnfU7dUSGZChvkUBJsxbLSFpWGqslH3ubzoY/A0J2jSMY1Ntib
         CFvzLRMg0ayL/oraT6nzTKrQqbxkZxnvs3eHSr3RWPCiWb6ACT6MxmnQzXL16kjVWiKw
         bttJUyVWbgre+/UdoxCtKX8M6pOe3lam3zWBY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/24] kprobes: Prohibit to probe native_get_debugreg
Date: Tue, 22 Sep 2009 21:38:04 +0200
Message-Id: <1253648302-5771-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Since do_debug() calls get_debugreg(), native_get_debugreg() will be
called from singlestepping. This can cause an int3 infinite loop.

We can't put it in the .text.kprobes section because it is inlined,
then we blacklist its name.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090827172332.8246.34194.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/kprobes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f72e96c..3267d90 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -90,6 +90,7 @@ static spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
  */
 static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"preempt_schedule",},
+	{"native_get_debugreg",},
 	{NULL}    /* Terminator */
 };
 
-- 
1.6.2.3


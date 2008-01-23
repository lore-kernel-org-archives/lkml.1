Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYAWRkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYAWRkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYAWRjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:39:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbYAWRjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=aNRBlThhkOXh1L0tuoEBOkzE+agm81TY0AGNwYYWfiIXwtx3BlMZovKLPblBRJ6F6yq9+qVaQX/u4EyvF1XoW9vYJ6hKEEyKaY19gAjJo9tKYUQwxAw0N22pJsve+fSyLUnDhoLIrZcqYs/+Ae89VNi9AkRpykHLUog1lOScClM=
Date: Wed, 23 Jan 2008 20:38:50 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/6] kernel: use KSYM_NAME_LEN
Message-ID: <20080123173850.GC12877@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use KSYM_NAME_LEN instead of numeric value

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/kernel/kprobes.c
===================================================================
--- linux-2.6.git.orig/kernel/kprobes.c	2008-01-21 23:14:47.000000000 +0300
+++ linux-2.6.git/kernel/kprobes.c	2008-01-23 19:20:53.000000000 +0300
@@ -872,7 +872,7 @@ static int __kprobes show_kprobe_addr(st
 	const char *sym = NULL;
 	unsigned int i = *(loff_t *) v;
 	unsigned long offset = 0;
-	char *modname, namebuf[128];
+	char *modname, namebuf[KSYM_NAME_LEN];
 
 	head = &kprobe_table[i];
 	preempt_disable();
Index: linux-2.6.git/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.git.orig/kernel/lockdep_proc.c	2008-01-21 19:35:32.000000000 +0300
+++ linux-2.6.git/kernel/lockdep_proc.c	2008-01-23 19:23:33.000000000 +0300
@@ -93,7 +93,7 @@ static unsigned long count_backward_deps
 
 static void print_name(struct seq_file *m, struct lock_class *class)
 {
-	char str[128];
+	char str[KSYM_NAME_LEN];
 	const char *name = class->name;
 
 	if (!name) {

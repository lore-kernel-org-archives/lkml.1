Return-Path: <linux-kernel-owner+w=401wt.eu-S1752200AbZIVTio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbZIVTio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZIVTil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:38:41 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZIVTif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dBj62MGoJBJuhdRunl33c+ApSDrxBGbe/Mfaxyr8TgLGBPGy58FjCO7zDyMMz1o9HE
         OtW0tPE8SCbaQLYsWcltjhARhIszNrxj5WWAhESysli0OeLURbuCQDczrXD8aj+Nrla/
         8/oTMPLsXFOlVU0x68YrUoVK5a+2n1pP5wBvY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/24] kprobes: Fix to add __kprobes to notify_die
Date: Tue, 22 Sep 2009 21:38:02 +0200
Message-Id: <1253648302-5771-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add __kprobes to notify_die() because do_int3() calls notify_die()
instead of atomic_notify_call_chain() which is already marked as
__kprobes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090827172318.8246.53702.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/notifier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 61d5aa5..acd24e7 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -558,7 +558,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 
 static ATOMIC_NOTIFIER_HEAD(die_chain);
 
-int notrace notify_die(enum die_val val, const char *str,
+int notrace __kprobes notify_die(enum die_val val, const char *str,
 	       struct pt_regs *regs, long err, int trap, int sig)
 {
 	struct die_args args = {
-- 
1.6.2.3


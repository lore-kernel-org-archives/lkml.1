Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbZKYNb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbZKYNb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbZKYNbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:31:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:49055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934722AbZKYNbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:31:20 -0500
Date: Wed, 25 Nov 2009 13:30:49 GMT
From: tip-bot for Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, shmulik.ladkani@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, shmulik.ladkani@gmail.com, mingo@elte.hu
In-Reply-To: <4b0d2fe4.0ab6660a.6437.3cfc@mx.google.com>
References: <4b0d2fe4.0ab6660a.6437.3cfc@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched.c: Call debug_show_all_locks() when dumping all tasks
Message-ID: <tip-93335a21557e80f6a99bc2812c634e488139043c@git.kernel.org>
Git-Commit-ID: 93335a21557e80f6a99bc2812c634e488139043c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93335a21557e80f6a99bc2812c634e488139043c
Gitweb:     http://git.kernel.org/tip/93335a21557e80f6a99bc2812c634e488139043c
Author:     Shmulik Ladkani <shmulik.ladkani@gmail.com>
AuthorDate: Wed, 25 Nov 2009 15:23:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Nov 2009 14:26:52 +0100

sched.c: Call debug_show_all_locks() when dumping all tasks

In commit v2.6.21-691-g39bc89f ("make SysRq-T show all tasks
again") the interface of show_state_filter() was changed: zero
valued 'state_filter' specifies "dump all tasks" (instead of -1).

However, the condition for calling debug_show_all_locks() ("show
locks if all tasks are dumped") was not updated accordingly.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: peterz@infradead.org
LKML-Reference: <4b0d2fe4.0ab6660a.6437.3cfc@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 010d5e1..a57c6ae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6915,7 +6915,7 @@ void show_state_filter(unsigned long state_filter)
 	/*
 	 * Only show locks if all tasks are dumped:
 	 */
-	if (state_filter == -1)
+	if (!state_filter)
 		debug_show_all_locks();
 }
 

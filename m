Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbYAGWX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbYAGWX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYAGWXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:23:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbYAGWXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:23:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] acct: real_parent ppid
X-Zippy-Says: My face is new, my license is expired, and I'm under a doctor's care!!!!
Message-Id: <20080107222334.E058B26F9A5@magilla.localdomain>
Date: Mon,  7 Jan 2008 14:23:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ac_ppid field reported in process accounting records
should match what getppid() would have returned to that
process, regardless of whether a debugger is attached.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 kernel/acct.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index cf19547..521dfa5 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -482,7 +482,7 @@ static void do_acct_process(struct file *file)
 #endif
 #if ACCT_VERSION==3
 	ac.ac_pid = current->tgid;
-	ac.ac_ppid = current->parent->tgid;
+	ac.ac_ppid = current->real_parent->tgid;
 #endif
 
 	spin_lock_irq(&current->sighand->siglock);

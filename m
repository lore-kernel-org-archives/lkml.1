Return-Path: <linux-kernel-owner+w=401wt.eu-S1752720AbYJUNqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbYJUNqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJUNp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:45:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:55069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYJUNp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:45:56 -0400
Date: Tue, 21 Oct 2008 06:46:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] procfs: use WARN() rather than printk+backtrace
Message-ID: <20081021064612.4578920c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 20cba7e9bd227f3fb2e8042403af33be03dc31cf Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 13 Sep 2008 19:51:30 -0700
Subject: [PATCH] procfs: use WARN() rather than printk+backtrace

Use WARN() rather than a printk() + backtrace();
this gives a more standard format message as well as complete
information (including line numbers etc) that will be collected
by kerneloops.org

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/proc/generic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 7821589..60a359b 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -547,9 +547,8 @@ static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp
 
 	for (tmp = dir->subdir; tmp; tmp = tmp->next)
 		if (strcmp(tmp->name, dp->name) == 0) {
-			printk(KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
+			WARN(1, KERN_WARNING "proc_dir_entry '%s/%s' already registered\n",
 				dir->name, dp->name);
-			dump_stack();
 			break;
 		}
 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

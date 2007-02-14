Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbXBNAPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbXBNAPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbXBNAPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:15:48 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:60230 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbXBNAPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:15:47 -0500
Date: Tue, 13 Feb 2007 16:11:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@osdl.org>
Subject: [PATCH] tty: use NULL for ptrs
Message-Id: <20070213161132.3fb744b7.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning in tty_io:
drivers/char/tty_io.c:1536:34: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20-git9.orig/drivers/char/tty_io.c
+++ linux-2.6.20-git9/drivers/char/tty_io.c
@@ -1533,7 +1533,7 @@ void disassociate_ctty(int on_exit)
 
 	spin_lock_irq(&current->sighand->siglock);
 	tty_pgrp = current->signal->tty_old_pgrp;
-	current->signal->tty_old_pgrp = 0;
+	current->signal->tty_old_pgrp = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 	put_pid(tty_pgrp);
 

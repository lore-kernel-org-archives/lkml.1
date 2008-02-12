Return-Path: <linux-kernel-owner+w=401wt.eu-S1764834AbYBLS7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764834AbYBLS7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763422AbYBLS5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:57:46 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33025 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762647AbYBLS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:57:44 -0500
Date: Tue, 12 Feb 2008 13:55:28 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Johann Felix Soden <johfel@users.sourceforge.net>
Subject: [PATCH 3/4] UML - Fix helper_wait calls in watchdog
Message-ID: <20080212185528.GA2074@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

In 1aa351a308d2c3ddb92b6cc45083fc54271d0010 the arguments of helper_wait() were
changed. The adaptation of harddog_user.c was forgotten, so this errors occur:

/arch/um/drivers/harddog_user.c: In function 'start_watchdog':
/arch/um/drivers/harddog_user.c:82: error: too many arguments to function 'helper_wait'
/arch/um/drivers/harddog_user.c:89: error: too many arguments to function 'helper_wait'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/harddog_user.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22/arch/um/drivers/harddog_user.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/harddog_user.c	2008-01-17 12:50:20.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/harddog_user.c	2008-02-11 18:46:05.000000000 -0500
@@ -79,14 +79,14 @@ int start_watchdog(int *in_fd_ret, int *
 	n = read(in_fds[0], &c, sizeof(c));
 	if (n == 0) {
 		printk("harddog_open - EOF on watchdog pipe\n");
-		helper_wait(pid, 1, NULL);
+		helper_wait(pid);
 		err = -EIO;
 		goto out_close_out;
 	}
 	else if (n < 0) {
 		printk("harddog_open - read of watchdog pipe failed, "
 		       "err = %d\n", errno);
-		helper_wait(pid, 1, NULL);
+		helper_wait(pid);
 		err = n;
 		goto out_close_out;
 	}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763956AbYBLS6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763956AbYBLS6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763359AbYBLS5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:57:45 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33024 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762567AbYBLS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:57:44 -0500
Date: Tue, 12 Feb 2008 13:55:27 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Johann Felix Soden <johfel@users.sourceforge.net>,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 1/4] UML - Fix initrd printk
Message-ID: <20080212185527.GA2084@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

If the initrd file has zero-length, the error message should contain
the filepath.

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/initrd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: linux-2.6-git/arch/um/kernel/initrd.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/initrd.c	2008-02-12 12:44:44.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/initrd.c	2008-02-12 13:19:11.000000000 -0500
@@ -32,7 +32,7 @@ static int __init read_initrd(void)
 	 * ask for no memory.
 	 */
 	if (size == 0) {
-		printk(KERN_ERR "\"%\" is a zero-size initrd\n");
+		printk(KERN_ERR "\"%s\" is a zero-size initrd\n", initrd);
 		return 0;
 	}
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764666AbYDYSEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764666AbYDYSEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762725AbYDYR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:31 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53141 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764046AbYDYR5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:22 -0400
Date: Fri, 25 Apr 2008 13:56:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH 15/19] UML - use __SPIN_LOCK_UNLOCKED
Message-ID: <20080425175615.GA11200@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Use newer, non-deprecated __SPIN_LOCK_UNLOCKED macro.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/line.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.22/arch/um/include/line.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/line.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/arch/um/include/line.h	2008-03-17 13:42:36.000000000 -0400
@@ -58,11 +58,11 @@ struct line {
 };
 
 #define LINE_INIT(str, d) \
-	{ .count_lock =	SPIN_LOCK_UNLOCKED, \
+	{ .count_lock =	__SPIN_LOCK_UNLOCKED((str).count_lock), \
 	  .init_str =	str,	\
 	  .init_pri =	INIT_STATIC, \
 	  .valid =	1, \
-	  .lock =	SPIN_LOCK_UNLOCKED, \
+	  .lock =	__SPIN_LOCK_UNLOCKED((str).lock), \
 	  .driver =	d }
 
 extern void line_close(struct tty_struct *tty, struct file * filp);

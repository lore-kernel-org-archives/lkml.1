Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbXGRHdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbXGRHdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXGRHcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:32:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbXGRHcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:32:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/5] Freezer: Prevent new tasks from inheriting TIF_FREEZE set
Date: Wed, 18 Jul 2007 09:33:31 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
References: <200707180929.31511.rjw@sisk.pl>
In-Reply-To: <200707180929.31511.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180933.32080.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Tasks should go to the refrigerator only if explicitly requested to do that by
the freezer and not as a result of inheriting the TIF_FREEZE flag set from the
parent.  Make it happen.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22-rc6-mm1/kernel/fork.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/fork.c	2007-07-11 20:48:04.000000000 +0200
+++ linux-2.6.22-rc6-mm1/kernel/fork.c	2007-07-11 20:50:42.000000000 +0200
@@ -932,6 +932,7 @@ static inline void copy_flags(unsigned l
 	if (!(clone_flags & CLONE_PTRACE))
 		p->ptrace = 0;
 	p->flags = new_flags;
+	clear_freeze_flag(p);
 }
 
 asmlinkage long sys_set_tid_address(int __user *tidptr)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYHTT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYHTT0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYHTT0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:26:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48234 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbYHTT0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:26:06 -0400
Subject: [RFC v2][PATCH 2/9] Remove CAP_SYS_ADMIN for checkpoint/restart
To: arnd@arndb.de
Cc: orenl@cs.columbia.edu, jeremy@goop.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 Aug 2008 12:25:59 -0700
References: <20080820192557.98788FAB@nimitz>
In-Reply-To: <20080820192557.98788FAB@nimitz>
Message-Id: <20080820192559.32C52EA3@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need to do this so that we think about the security concerns
as we add each and every bit of c/r functionality.  There's
nothing that we need privileges for, yet.  Let's keep it that
way as long as possible.

---

 oren-cr.git-dave/checkpoint/sys.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN checkpoint/sys.c~0003-Remove-CAP_SYS_ADMIN-for-checkpoint-restart checkpoint/sys.c
--- oren-cr.git/checkpoint/sys.c~0003-Remove-CAP_SYS_ADMIN-for-checkpoint-restart	2008-08-20 12:12:49.000000000 -0700
+++ oren-cr.git-dave/checkpoint/sys.c	2008-08-20 12:12:49.000000000 -0700
@@ -169,9 +169,6 @@ asmlinkage long sys_checkpoint(pid_t pid
 	int fput_needed;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
@@ -207,9 +204,6 @@ asmlinkage long sys_restart(int crid, in
 	int fput_needed;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
_

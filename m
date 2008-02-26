Return-Path: <linux-kernel-owner+w=401wt.eu-S1764819AbYBZVVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764819AbYBZVVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYBZVVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:21:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYBZVVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:21:08 -0500
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] elfcore-compat fix uid/gid types
X-Shopping-List: (1) Arrogant chasers
   (2) Polyandrous proclamation bacon
   (3) Elliptical collisions
   (4) Ardent pollution inhibitions
   (5) Judicious quaint prescription condiments
Message-Id: <20080226212058.6161426F9A4@magilla.localdomain>
Date: Tue, 26 Feb 2008 13:20:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I overlooked the difference between __kernel_uid_t and uid_t when defining
struct compat_elf_prpsinfo.  The result is a regression in 32-bit core
dumps on x86_64, where the NT_PRPSINFO note has the wrong size and layout.
This patch fixes it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/elfcore-compat.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/elfcore-compat.h b/include/linux/elfcore-compat.h
index 532d13a..0a90e1c 100644
--- a/include/linux/elfcore-compat.h
+++ b/include/linux/elfcore-compat.h
@@ -45,8 +45,8 @@ struct compat_elf_prpsinfo
 	char				pr_zomb;
 	char				pr_nice;
 	compat_ulong_t			pr_flag;
-	compat_uid_t			pr_uid;
-	compat_gid_t			pr_gid;
+	__compat_uid_t			pr_uid;
+	__compat_gid_t			pr_gid;
 	compat_pid_t			pr_pid, pr_ppid, pr_pgrp, pr_sid;
 	char				pr_fname[16];
 	char				pr_psargs[ELF_PRARGSZ];

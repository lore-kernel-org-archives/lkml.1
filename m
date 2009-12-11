Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZLKPhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZLKPhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbZLKPhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:37:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:57511 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbZLKPg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:36:58 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Roel Kluin <roel.kluin@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/9] kgdb,x86: remove redundant test
Date: Fri, 11 Dec 2009 09:36:09 -0600
Message-Id: <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:30.0925 (UTC) FILETIME=[B627F7D0:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

The for loop starts with a breakno of 0, and ends when it's 4. so
this test is always true.

CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 20a5b36..f93d015 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -220,8 +220,7 @@ static void kgdb_correct_hw_break(void)
 			dr7 |= ((breakinfo[breakno].len << 2) |
 				 breakinfo[breakno].type) <<
 			       ((breakno << 2) + 16);
-			if (breakno >= 0 && breakno <= 3)
-				set_debugreg(breakinfo[breakno].addr, breakno);
+			set_debugreg(breakinfo[breakno].addr, breakno);
 
 		} else {
 			if ((dr7 & breakbit) && !breakinfo[breakno].enabled) {
-- 
1.6.4.rc1


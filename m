Return-Path: <linux-kernel-owner+w=401wt.eu-S1763085AbZFKL6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763085AbZFKL6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZFKL56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:57:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:35099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZFKL55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:57:57 -0400
Date: Thu, 11 Jun 2009 11:57:35 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, tglx@linutronix.de
In-Reply-To: <20090611102927.GE12431@alberich.amd.com>
References: <20090611102927.GE12431@alberich.amd.com>
Subject: [tip:branch?] x86: memtest: add proper typecast for pointer comparison
Message-ID: <tip-47e64f3c8430d0410c8e83f3e503532491c863c3@git.kernel.org>
Git-Commit-ID: 47e64f3c8430d0410c8e83f3e503532491c863c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Jun 2009 11:57:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47e64f3c8430d0410c8e83f3e503532491c863c3
Gitweb:     http://git.kernel.org/tip/47e64f3c8430d0410c8e83f3e503532491c863c3
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 11 Jun 2009 12:29:27 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 11 Jun 2009 13:53:02 +0200

x86: memtest: add proper typecast for pointer comparison

Commit c9690998ef48ffefeccb91c70a7739eebdea57f9
(x86: memtest: remove 64-bit division) introduced following compile warning:

 arch/x86/mm/memtest.c: In function 'memtest':
 arch/x86/mm/memtest.c:56: warning: comparison of distinct pointer types lacks a cast
 arch/x86/mm/memtest.c:58: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20090611102927.GE12431@alberich.amd.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/x86/mm/memtest.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index c0bedcd..1a8b48f 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -53,9 +53,9 @@ static void __init memtest(u64 pattern, u64 start_phys, u64 size)
 	start_bad = 0;
 	last_bad = 0;
 
-	for (p = start; p < end; p++)
+	for (p = start; (void *) p < end; p++)
 		*p = pattern;
-	for (p = start; p < end; p++, start_phys_aligned += incr) {
+	for (p = start; (void *) p < end; p++, start_phys_aligned += incr) {
 		if (*p == pattern)
 			continue;
 		if (start_phys_aligned == last_bad + incr) {

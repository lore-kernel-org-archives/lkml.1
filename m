Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZCFO2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZCFO2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZCFO2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:28:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:42114 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZCFO2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:28:24 -0500
Date: Fri, 6 Mar 2009 14:27:35 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236265466.31324.9.camel@penberg-laptop>
References: <1236265466.31324.9.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: fix uninitialized variable in init_memory_mapping()
Message-ID: <tip-c77a3b59c624454c501cbfa1a3611d5a00bf9532@git.kernel.org>
Git-Commit-ID: c77a3b59c624454c501cbfa1a3611d5a00bf9532
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 14:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c77a3b59c624454c501cbfa1a3611d5a00bf9532
Gitweb:     http://git.kernel.org/tip/c77a3b59c624454c501cbfa1a3611d5a00bf9532
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 17:04:26 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 15:25:52 +0100

x86: fix uninitialized variable in init_memory_mapping()

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236265466.31324.9.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6d63e3d..15219e0 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -134,8 +134,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 {
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
+	unsigned long ret = 0;
 	unsigned long pos;
-	unsigned long ret;
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;

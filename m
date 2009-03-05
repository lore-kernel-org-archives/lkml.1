Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZCENkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZCENkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZCENiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:38:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:49959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbZCENiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:38:16 -0500
Date: Thu, 5 Mar 2009 13:37:42 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-9-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-9-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: add table start and end sanity checks to 32-bit init_memory_mapping()
Message-ID: <tip-d58e854e36ddf241ebc243e4122c5ab087bf38df@git.kernel.org>
Git-Commit-ID: d58e854e36ddf241ebc243e4122c5ab087bf38df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:37:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d58e854e36ddf241ebc243e4122c5ab087bf38df
Gitweb:     http://git.kernel.org/tip/d58e854e36ddf241ebc243e4122c5ab087bf38df
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:55:00 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:14 +0100

x86: add table start and end sanity checks to 32-bit init_memory_mapping()

Impact: cleanup

This patch adds a sanity check to the 32-bit version of
init_memory_mapping() to reduce the diff to the 64-bit version.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-9-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 00c1d85..0a3707f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1060,7 +1060,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
-	if (!after_bootmem)
+	if (!after_bootmem && table_end > table_start)
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZCENjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZCENjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZCENhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:37:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:49909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbZCENhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:37:47 -0500
Date: Thu, 5 Mar 2009 13:37:16 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-6-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-6-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: remove unnecessary save_mr() sanity check
Message-ID: <tip-96083ca11bc85265c7ef9e791a57e3514d8f605a@git.kernel.org>
Git-Commit-ID: 96083ca11bc85265c7ef9e791a57e3514d8f605a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:37:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96083ca11bc85265c7ef9e791a57e3514d8f605a
Gitweb:     http://git.kernel.org/tip/96083ca11bc85265c7ef9e791a57e3514d8f605a
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:54:57 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:13 +0100

x86: remove unnecessary save_mr() sanity check

Impact: cleanup

The save_mr() function already checks that start_pfn is less than
end_pfn so we can remove the unnecessary check which reduces the
diff between the 32-bit and the 64-bit versions of init_memory_mapping().

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-6-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index eb98cb9..559715b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1008,8 +1008,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	/* tail is not big page (2M) alignment */
 	start_pfn = pos>>PAGE_SHIFT;
 	end_pfn = end>>PAGE_SHIFT;
-	if (start_pfn < end_pfn)
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
 	/* try to merge same page size and continuous */
 	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {

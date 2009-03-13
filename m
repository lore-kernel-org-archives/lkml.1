Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZCMCfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZCMCfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbZCMCeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:34:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:39538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549AbZCMCeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:34:36 -0400
Date: Fri, 13 Mar 2009 02:33:55 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B910B6.76E4.0078.0@novell.com>
References: <49B910B6.76E4.0078.0@novell.com>
Subject: [tip:x86/mm] x86: move save_mr() into .meminit.text
Message-ID: <tip-dc9dd5cc854cde110d2421f3a11fec7597e059c1@git.kernel.org>
Git-Commit-ID: dc9dd5cc854cde110d2421f3a11fec7597e059c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:33:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc9dd5cc854cde110d2421f3a11fec7597e059c1
Gitweb:     http://git.kernel.org/tip/dc9dd5cc854cde110d2421f3a11fec7597e059c1
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 12:40:06 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:37:18 +0100

x86: move save_mr() into .meminit.text

Impact: cleanup, save memory

The function is only being called from boot or memory hotplug paths.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B910B6.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 15219e0..fd3da1d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -94,9 +94,9 @@ struct map_range {
 #define NR_RANGE_MR 5
 #endif
 
-static int save_mr(struct map_range *mr, int nr_range,
-		   unsigned long start_pfn, unsigned long end_pfn,
-		   unsigned long page_size_mask)
+static int __meminit save_mr(struct map_range *mr, int nr_range,
+			     unsigned long start_pfn, unsigned long end_pfn,
+			     unsigned long page_size_mask)
 {
 	if (start_pfn < end_pfn) {
 		if (nr_range >= NR_RANGE_MR)

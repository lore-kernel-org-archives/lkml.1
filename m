Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZEHJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZEHJJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZEHJJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:09:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:53256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZEHJJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:09:03 -0400
Date: Fri, 8 May 2009 09:07:25 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, jeremy.fitzhardinge@citrix.com,
       jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       xen-devel@lists.xensource.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy.fitzhardinge@citrix.com,
       jeremy@goop.org, tglx@linutronix.de, xen-devel@lists.xensource.com,
       mingo@elte.hu
In-Reply-To: <4A032EF1.6070708@goop.org>
References: <4A032EF1.6070708@goop.org>
Subject: [tip:x86/xen] xen: reserve Xen start_info rather than e820 reserving
Message-ID: <tip-6b2e8523df148c15ea5abf13075026fb8bdb3f86@git.kernel.org>
Git-Commit-ID: 6b2e8523df148c15ea5abf13075026fb8bdb3f86
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 09:07:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b2e8523df148c15ea5abf13075026fb8bdb3f86
Gitweb:     http://git.kernel.org/tip/6b2e8523df148c15ea5abf13075026fb8bdb3f86
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Thu, 7 May 2009 11:56:49 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 May 2009 10:51:03 +0200

xen: reserve Xen start_info rather than e820 reserving

Use reserve_early rather than e820 reservations for Xen start info and mfn->pfn
table, so that the memory use is a bit more self-documenting.

[ Impact: cleanup ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Xen-devel <xen-devel@lists.xensource.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4A032EF1.6070708@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/xen/setup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 15c6c68..ad0047f 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -61,9 +61,9 @@ char * __init xen_memory_setup(void)
 	 *  - xen_start_info
 	 * See comment above "struct start_info" in <xen/interface/xen.h>
 	 */
-	e820_add_region(__pa(xen_start_info->mfn_list),
-			xen_start_info->pt_base - xen_start_info->mfn_list,
-			E820_RESERVED);
+	reserve_early(__pa(xen_start_info->mfn_list),
+		      __pa(xen_start_info->pt_base),
+			"XEN START INFO");
 
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZCEPFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZCEPFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZCEPFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:05:00 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58014 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZCEPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:04:59 -0500
Subject: [PATCH 1/2] x86: rename do_not_nx to disable_nx in mm/init_64.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Mar 2009 17:04:57 +0200
Message-Id: <1236265497.31324.11.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As a preparational step for unifying noexec handling on 32-bit and 64-bit,
rename the do_not_nx variable to disable_nx on 64-bit.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 7dd7ce4..bb50ce8 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -85,7 +85,7 @@ early_param("gbpages", parse_direct_gbpages_on);
 pteval_t __supported_pte_mask __read_mostly = ~_PAGE_IOMAP;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
-static int do_not_nx __cpuinitdata;
+static int disable_nx __cpuinitdata;
 
 /*
  * noexec=on|off
@@ -100,9 +100,9 @@ static int __init nonx_setup(char *str)
 		return -EINVAL;
 	if (!strncmp(str, "on", 2)) {
 		__supported_pte_mask |= _PAGE_NX;
-		do_not_nx = 0;
+		disable_nx = 0;
 	} else if (!strncmp(str, "off", 3)) {
-		do_not_nx = 1;
+		disable_nx = 1;
 		__supported_pte_mask &= ~_PAGE_NX;
 	}
 	return 0;
@@ -114,7 +114,7 @@ void __cpuinit check_efer(void)
 	unsigned long efer;
 
 	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || do_not_nx)
+	if (!(efer & EFER_NX) || disable_nx)
 		__supported_pte_mask &= ~_PAGE_NX;
 }
 
-- 
1.5.4.3




Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYGBBFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYGBBFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760490AbYGBBCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:02:38 -0400
Received: from gw.goop.org ([64.81.55.164]:58692 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbYGBBBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:01:53 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 8] x86_64: create global mappings in head_64.S
X-Mercurial-Node: 353bdb9d31cbee91deea55aa0bfe4fe07c0a1361
Message-Id: <353bdb9d31cbee91deea.1214955990@localhost>
In-Reply-To: <patchbomb.1214955989@localhost>
Date: Tue, 01 Jul 2008 16:46:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating the initial set of pagetables in head_64.S, create them
global.  This matches the mappings created later in the kernel boot;
this means we can reuse these pagetables without causing an
inconsistency.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -374,7 +374,7 @@
 	/* Since I easily can, map the first 1G.
 	 * Don't set NX because code runs from these pages.
 	 */
-	PMDS(0, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)
+	PMDS(0, __PAGE_KERNEL_LARGE_EXEC | _PAGE_GLOBAL, PTRS_PER_PMD)
 
 NEXT_PAGE(level2_kernel_pgt)
 	/*



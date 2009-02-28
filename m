Return-Path: <linux-kernel-owner+w=401wt.eu-S1762543AbZB1CG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762543AbZB1CG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761136AbZB1B7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:44 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59182
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757723AbZB1B7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:34 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] xen mtrr: Use generic_validate_add_page()
Date: Fri, 27 Feb 2009 17:59:23 -0800
Message-Id: <1235786365-17744-18-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

The hypervisor already performs the same validation, but
better to do it early before getting to the range combining
code.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/xen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index 7a25f88..f226044 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -16,7 +16,7 @@ static struct mtrr_ops xen_mtrr_ops = {
 //	.set               = xen_set_mtrr,
 //	.get               = xen_get_mtrr,
 	.get_free_region   = generic_get_free_region,
-//	.validate_add_page = xen_validate_add_page,
+	.validate_add_page = generic_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
 	.use_intel_if	   = 0,
 	.num_var_ranges	   = xen_num_var_ranges,
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbZCMRIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbZCMRIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759895AbZCMRBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:32 -0400
Received: from gw.goop.org ([64.81.55.164]:57423 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759722AbZCMRBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:31 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 21/27] xen mtrr: Use generic_validate_add_page()
Date: Fri, 13 Mar 2009 10:00:06 -0700
Message-Id: <1236963612-14287-22-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
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
index e03532c..622d075 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -22,7 +22,7 @@ static struct mtrr_ops xen_mtrr_ops = {
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


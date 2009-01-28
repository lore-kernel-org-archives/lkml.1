Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZA1Woe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZA1Woe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZA1Wmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:42:50 -0500
Received: from gw.goop.org ([64.81.55.164]:52579 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753133AbZA1Wmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:42:49 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 7] x86: fix paravirt clobber in entry_64.S
X-Mercurial-Node: 138b9e1650b385d5ac9d3abde66babeebdf61c4d
Message-Id: <138b9e1650b385d5ac9d.1233182103@abulafia.goop.org>
In-Reply-To: <patchbomb.1233182100@abulafia.goop.org>
References: <patchbomb.1233182100@abulafia.goop.org>
Date: Wed, 28 Jan 2009 14:35:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clobber is trying to say that anything except RDI is available for
clobbering, but actually clobbers everything.  This hasn't mattered
because the clobbers were basically ignored, but subsequent patches
will rely on them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1147,7 +1147,7 @@
 	CFI_STARTPROC
 	pushf
 	CFI_ADJUST_CFA_OFFSET 8
-	DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
+	DISABLE_INTERRUPTS(CLBR_ANY & ~CLBR_RDI)
 	SWAPGS
 gs_change:
 	movl %edi,%gs



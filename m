Return-Path: <linux-kernel-owner+w=401wt.eu-S1423496AbXD3Pwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423496AbXD3Pwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423493AbXD3Pwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:52:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40729 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423494AbXD3Pw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:52:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 03/12] i386 head.S: Always run the full set of paging state
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 30 Apr 2007 09:51:13 -0600
In-Reply-To: <m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 30 Apr 2007 09:49:31 -0600")
Message-ID: <m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I am preparing to convert the boot time page table to the kernels
native format.  To achieve that I need to enable PAE. Enabling PSE
and the no execute bit would not hurt.  So this patch modifies
the boot cpu path to execute all of the kernels enable code
if and only if we have the proper bits set in mmu_cr4_features.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/kernel/head.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index aa9e28e..248d44c 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -181,6 +181,8 @@ ENTRY(startup_32_smp)
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
+#endif /* CONFIG_SMP */
+3:
 
 /*
  *	New page tables may be in 4Mbyte page mode and may
@@ -227,8 +229,6 @@ ENTRY(startup_32_smp)
 	wrmsr
 
 6:
-#endif /* CONFIG_SMP */
-3:
 
 /*
  * Enable paging
-- 
1.5.1.1.181.g2de0


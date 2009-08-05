Return-Path: <linux-kernel-owner+w=401wt.eu-S934113AbZHEJ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbZHEJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933178AbZHEJ6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:58:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:56116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934076AbZHEJ6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:58:22 -0400
Date: Wed, 5 Aug 2009 09:57:58 GMT
From: tip-bot for Alok Kataria <akataria@vmware.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akataria@vmware.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akataria@vmware.com, mingo@elte.hu
In-Reply-To: <1249425262.18955.40.camel@ank32.eng.vmware.com>
References: <1249425262.18955.40.camel@ank32.eng.vmware.com>
Subject: [tip:x86/urgent] x86: Fix VMI && stack protector
Message-ID: <tip-7d5b005652bc5ae3e1e0efc53fd0e25a643ec506@git.kernel.org>
Git-Commit-ID: 7d5b005652bc5ae3e1e0efc53fd0e25a643ec506
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 09:57:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d5b005652bc5ae3e1e0efc53fd0e25a643ec506
Gitweb:     http://git.kernel.org/tip/7d5b005652bc5ae3e1e0efc53fd0e25a643ec506
Author:     Alok Kataria <akataria@vmware.com>
AuthorDate: Tue, 4 Aug 2009 15:34:22 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Aug 2009 10:20:29 +0200

x86: Fix VMI && stack protector

With CONFIG_STACK_PROTECTOR turned on, VMI doesn't boot with
more than one processor. The problem is with the gs value not
being initialized correctly when registering the secondary
processor for VMI's case.

The patch below initializes the gs value for the AP to
__KERNEL_STACK_CANARY. Without this the secondary processor
keeps on taking a GP on every gs access.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc: <stable@kernel.org> # for v2.6.30.x
LKML-Reference: <1249425262.18955.40.camel@ank32.eng.vmware.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmi_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index b263423..95a7289 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -441,7 +441,7 @@ vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 	ap.ds = __USER_DS;
 	ap.es = __USER_DS;
 	ap.fs = __KERNEL_PERCPU;
-	ap.gs = 0;
+	ap.gs = __KERNEL_STACK_CANARY;
 
 	ap.eflags = 0;
 

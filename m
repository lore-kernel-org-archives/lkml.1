Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZGAOzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZGAOzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZGAOzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:55:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:35522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZGAOzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:55:07 -0400
Date: Wed, 1 Jul 2009 14:54:35 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246458194.6940.20.camel@hpdv5.satnam>
References: <1246458194.6940.20.camel@hpdv5.satnam>
Subject: [tip:x86/urgent] x86: Mark device_nb as static and fix NULL noise
Message-ID: <tip-b25ae679f613ed04aaf6ccbfdb9122fce668e4bb@git.kernel.org>
Git-Commit-ID: b25ae679f613ed04aaf6ccbfdb9122fce668e4bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 14:54:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b25ae679f613ed04aaf6ccbfdb9122fce668e4bb
Gitweb:     http://git.kernel.org/tip/b25ae679f613ed04aaf6ccbfdb9122fce668e4bb
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 1 Jul 2009 19:53:14 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 16:52:53 +0200

x86: Mark device_nb as static and fix NULL noise

This sparse warning:

  arch/x86/kernel/amd_iommu.c:1195:23: warning: symbol 'device_nb' was not declared. Should it be static?

triggers because device_nb is global but is only used in a
single .c file. change device_nb to static to fix that - this
also addresses the sparse warning.

This sparse warning:

  arch/x86/kernel/amd_iommu.c:1766:10: warning: Using plain integer as NULL pointer

triggers because plain integer 0 is used in place of a NULL
pointer. change 0 to NULL to fix that - this also address the
sparse warning.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <1246458194.6940.20.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/amd_iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9372f04..6c99f50 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1192,7 +1192,7 @@ out:
 	return 0;
 }
 
-struct notifier_block device_nb = {
+static struct notifier_block device_nb = {
 	.notifier_call = device_change_notifier,
 };
 
@@ -1763,7 +1763,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
-		return 0;
+		return NULL;
 
 	paddr = virt_to_phys(virt_addr);
 

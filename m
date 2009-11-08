Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZKHNIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZKHNIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZKHNIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:08:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:59207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbZKHNI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:08:28 -0500
Date: Sun, 8 Nov 2009 13:07:40 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       athena@fftw.org, fujita.tomonori@lab.ntt.co.jp, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, athena@fftw.org, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AE5B52A.4050408@kernel.org>
References: <4AE5B52A.4050408@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: Fix iommu=nodac parameter handling
Message-ID: <tip-2ae8bb75db1f3de422eb5898f2a063c46c36dba8@git.kernel.org>
Git-Commit-ID: 2ae8bb75db1f3de422eb5898f2a063c46c36dba8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ae8bb75db1f3de422eb5898f2a063c46c36dba8
Gitweb:     http://git.kernel.org/tip/2ae8bb75db1f3de422eb5898f2a063c46c36dba8
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Mon, 26 Oct 2009 15:41:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 13:19:05 +0100

x86: Fix iommu=nodac parameter handling

iommu=nodac should forbid dac instead of enabling it. Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Matteo Frigo <athena@fftw.org>
Cc: <stable@kernel.org> # .32.x and older
LKML-Reference: <4AE5B52A.4050408@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index ce2fb91..839d49a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -216,7 +216,7 @@ static __init int iommu_setup(char *p)
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
-			forbid_dac = -1;
+			forbid_dac = 1;
 		if (!strncmp(p, "usedac", 6)) {
 			forbid_dac = -1;
 			return 1;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZKJNnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZKJNnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZKJNnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:43:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:58290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbZKJNnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:43:13 -0500
Date: Tue, 10 Nov 2009 13:42:33 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257849980-22640-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: Add iommu_init to x86_init_ops, fix build
Message-ID: <tip-b4941a9a606f0131559cc040b64e8437ac7b32c5@git.kernel.org>
Git-Commit-ID: b4941a9a606f0131559cc040b64e8437ac7b32c5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4941a9a606f0131559cc040b64e8437ac7b32c5
Gitweb:     http://git.kernel.org/tip/b4941a9a606f0131559cc040b64e8437ac7b32c5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 10 Nov 2009 14:37:58 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 14:37:58 +0100

x86: Add iommu_init to x86_init_ops, fix build

Most of the time x86_init.h is included in pci-dma.c - but not always,
leading to this rare build failure:

arch/x86/kernel/pci-dma.c:296: error: 'x86_init' undeclared (first use in this function)

So include asm/x86_init.h explicitly.

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org
Cc: dwmw2@infradead.org
Cc: joerg.roedel@amd.com
Cc: muli@il.ibm.com
LKML-Reference: <1257849980-22640-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 63eebee..f79870e 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -11,6 +11,7 @@
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
+#include <asm/x86_init.h>
 
 static int forbid_dac __read_mostly;
 

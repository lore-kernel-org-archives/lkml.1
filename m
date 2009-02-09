Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZBIKd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZBIKd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZBIKdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:33:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbZBIKd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:33:29 -0500
Date: Mon, 9 Feb 2009 11:33:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: early_printk.c - fix pgtable.h unification fallout
Message-ID: <20090209103322.GL20467@elte.hu>
References: <498CCFB5.3000706@goop.org> <20090209102211.GJ20467@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090209102211.GJ20467@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Pulled into tip/x86/headers, thanks Jeremy!
> 
> I'll keep watching out for any build fallout.

One small fixlet is below.

	Ingo

---------->
>From 726c0d95b6bd06cb83efd36a76ccf03fa9a770f0 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 9 Feb 2009 11:32:17 +0100
Subject: [PATCH] x86: early_printk.c - fix pgtable.h unification fallout
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

 arch/x86/kernel/early_printk.c: In function ‘early_dbgp_init’:
 arch/x86/kernel/early_printk.c:827: error: ‘PAGE_KERNEL_NOCACHE’ undeclared (first use in this function)
 arch/x86/kernel/early_printk.c:827: error: (Each undeclared identifier is reported only once
 arch/x86/kernel/early_printk.c:827: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/early_printk.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 6a36dd2..639ad98 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -14,6 +14,7 @@
 #include <xen/hvc-console.h>
 #include <asm/pci-direct.h>
 #include <asm/fixmap.h>
+#include <asm/pgtable.h>
 #include <linux/usb/ehci_def.h>
 
 /* Simple VGA output */

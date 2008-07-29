Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbYG2IKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbYG2IKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYG2IKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:10:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43807 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbYG2IKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:10:37 -0400
Date: Tue, 29 Jul 2008 10:10:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86, microcode support: fix build error
Message-ID: <20080729081019.GA14838@elte.hu>
References: <20080728164411.490752571@amd.com> <20080728180141.GB2937@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080728180141.GB2937@elte.hu>
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


>From 45b1e23eca1c53fa79a611a2bc8c93697ede6c97 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 29 Jul 2008 09:42:17 +0200
Subject: [PATCH] x86, microcode support: fix build error
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix:

  arch/x86/kernel/microcode.c:412: error: static declaration of ‘microcode_init’ follows non-static declaration
  include/asm/microcode.h:1: error: previous declaration of ‘microcode_init’ was here
  arch/x86/kernel/microcode.c:454: error: static declaration of ‘microcode_exit’ follows non-static declaration
  include/asm/microcode.h:2: error: previous declaration of ‘microcode_exit’ was here

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 1e42e79..9a88184 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -415,7 +415,7 @@ static struct notifier_block __refdata mc_cpu_notifier = {
 	.notifier_call = mc_cpu_callback,
 };
 
-static int microcode_init(void *opaque, struct module *module)
+int microcode_init(void *opaque, struct module *module)
 {
 	struct microcode_ops *ops = (struct microcode_ops *)opaque;
 	int error;
@@ -457,7 +457,7 @@ static int microcode_init(void *opaque, struct module *module)
 }
 EXPORT_SYMBOL_GPL(microcode_init);
 
-static void __exit microcode_exit (void)
+void __exit microcode_exit (void)
 {
 	microcode_dev_exit();
 

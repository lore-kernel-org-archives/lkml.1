Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYG2ILS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYG2ILS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYG2IK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:10:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45125 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbYG2IKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:10:54 -0400
Date: Tue, 29 Jul 2008 10:10:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 00/11] x86: AMD microcode patch loading support v2
Message-ID: <20080729081036.GB14838@elte.hu>
References: <20080728164411.490752571@amd.com> <20080728180141.GB2937@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


>From 224e946b81166d732f3e9b414cb69612072fb500 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 29 Jul 2008 09:52:55 +0200
Subject: [PATCH] x86, microcode: fix symbol exports

fix tons of build errors:

 arch/x86/kernel/built-in.o: In function `microcode_fini_cpu':
 microcode_intel.c:(.text+0x11598): undefined reference to `microcode_mutex'
 microcode_intel.c:(.text+0x115a4): undefined reference to `ucode_cpu_info'
 microcode_intel.c:(.text+0x115ae): undefined reference to `ucode_cpu_info'
 microcode_intel.c:(.text+0x115bc): undefined reference to `microcode_mutex'
 [...]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/microcode.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 9a88184..758b958 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -104,16 +104,16 @@ MODULE_LICENSE("GPL");
 struct microcode_ops *microcode_ops;
 
 /* no concurrent ->write()s are allowed on /dev/cpu/microcode */
-static DEFINE_MUTEX(microcode_mutex);
+DEFINE_MUTEX(microcode_mutex);
 EXPORT_SYMBOL_GPL(microcode_mutex);
 
-static struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
+struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
-static void __user *user_buffer;	/* user area microcode data buffer */
+void __user *user_buffer;		/* user area microcode data buffer */
 EXPORT_SYMBOL_GPL(user_buffer);
-static unsigned int user_buffer_size;	/* it's size */
+unsigned int user_buffer_size;		/* it's size */
 EXPORT_SYMBOL_GPL(user_buffer_size);
 
 static int do_microcode_update (void)
@@ -230,7 +230,7 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 #endif
 
 /* fake device for request_firmware */
-static struct platform_device *microcode_pdev;
+struct platform_device *microcode_pdev;
 EXPORT_SYMBOL_GPL(microcode_pdev);
 
 static void microcode_init_cpu(int cpu, int resume)

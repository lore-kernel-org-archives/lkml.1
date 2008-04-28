Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbYD1Ivn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbYD1Ivn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932372AbYD1Iv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:51:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59779 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369AbYD1Iv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:51:27 -0400
Date: Mon, 28 Apr 2008 10:50:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sergio Luis <sergio@uece.br>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ak@suse.de, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] build fix for smp
Message-ID: <20080428085044.GB16963@elte.hu>
References: <12059466674071-git-send-email-gcosta@redhat.com> <20080319195217.GA20762@elte.hu> <ce0170d90804280052y130c3fa2pbf3f97147f03b159@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce0170d90804280052y130c3fa2pbf3f97147f03b159@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Sergio Luis <sergio@uece.br> wrote:

> Hello, what's the final fix for this issue? 2.6.25-git11 is still 
> broken, just gave me

> arch/x86/kernel/built-in.o: In function `native_smp_send_stop':
> smp.c:(.text+0xc751): undefined reference to `reboot_force'
> make: *** [.tmp_vmlinux1] Error 1

> for a randconfig. Same reported at http://lkml.org/lkml/2008/4/27/39

btw., that's a VISWS config - that wont boot on any PC. The patch below 
should fix this.

	Ingo

--------------------------->
Subject: x86 VISWS: build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Apr 28 10:46:58 CEST 2008

the 'reboot_force' flag is a notion that non-PC subarchitectures do
not have.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/proto.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/include/asm-x86/proto.h
===================================================================
--- linux.orig/include/asm-x86/proto.h
+++ linux/include/asm-x86/proto.h
@@ -20,7 +20,11 @@ extern void syscall32_cpu_init(void);
 
 extern void check_efer(void);
 
+#ifdef X86_BIOS_REBOOT
 extern int reboot_force;
+#else
+static const int reboot_force = 0;
+#endif
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 

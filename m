Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYKTPFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYKTPFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbYKTOzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:55:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40004 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758295AbYKTOzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:55:41 -0500
Date: Thu, 20 Nov 2008 15:55:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Deal with the warning from dmi_low_memory_corruption()
	being unused
Message-ID: <20081120145511.GB13550@elte.hu>
References: <20081120124411.17087.11596.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081120124411.17087.11596.stgit@warthog.procyon.org.uk>
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


* David Howells <dhowells@redhat.com> wrote:

> Deal with the warning from dmi_low_memory_corruption() being unused 
> when CONFIG_X86_RESERVE_LOW_64K is not set:
> 
> arch/x86/kernel/setup.c:742: warning: 'dmi_low_memory_corruption' defined but not used
> 
> This was introduced by fc38151947477596aa27df6c4306ad6008dc6711.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/x86/kernel/setup.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

thx - already fixed via the patch below.

	Ingo

------------>
>From faad95db248fffe94b691a9c8f9cd0193584633a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 17 Oct 2008 12:00:38 +0200
Subject: [PATCH] fix warning in arch/x86/kernel/setup.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix this warning:

  arch/x86/kernel/setup.c:736: warning: ‘dmi_low_memory_corruption’ defined but not used

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0fa6790..c35ec3f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -738,6 +738,7 @@ void start_periodic_check_for_corruption(void)
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -749,6 +750,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {


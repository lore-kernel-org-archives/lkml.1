Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbYFMSfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbYFMSfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYFMSew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:34:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47864 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbYFMSev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:34:51 -0400
Date: Fri, 13 Jun 2008 20:34:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: improved smpboot integration
Message-ID: <20080613183433.GA16119@elte.hu>
References: <200806131507.m5DF73Q7005595@pobox-2.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806131507.m5DF73Q7005595@pobox-2.corp.redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Ingo, please pull the latest master git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-integration.git master
> 
> into your tip/master tree

thanks. I'm still testing it - found one problem so far, see the fix 
below.

btw., it makes sense to test-pull your own URIs to check it's all 
correct - the correct URI above is:

   git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master

	Ingo

--------------->
commit 25acfcc76e4ca3120d5ac36be17ff2c3319421b0
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jun 13 20:31:54 2008 +0200

    x86: fix sleep.c build error
    
    fix:
    
    arch/x86/kernel/acpi/sleep.c: In function ‘acpi_save_state_mem':
    arch/x86/kernel/acpi/sleep.c:75: error: ‘stack_start' undeclared (first use in this function)
    arch/x86/kernel/acpi/sleep.c:75: error: (Each undeclared identifier is reported
    only once
    arch/x86/kernel/acpi/sleep.c:75: error: for each function it appears in.)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 0103af2..cd1edab 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -72,7 +72,9 @@ int acpi_save_state_mem(void)
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 	header->trampoline_segment = setup_trampoline() >> 4;
+#ifdef CONFIG_SMP
 	stack_start.sp = temp_stack + 4096;
+#endif
 	initial_code = (unsigned long)wakeup_long64;
 	saved_magic = 0x123456789abcdef0;
 #endif /* CONFIG_64BIT */

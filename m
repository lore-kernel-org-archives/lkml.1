Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbYF3Gcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbYF3Gcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYF3GcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:32:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54794 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbYF3GcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:32:23 -0400
Date: Mon, 30 Jun 2008 08:31:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 25/39] merge common parts of uaccess.
Message-ID: <20080630063155.GA2915@elte.hu>
References: <1214602486-17080-18-git-send-email-gcosta@redhat.com> <1214602486-17080-19-git-send-email-gcosta@redhat.com> <1214602486-17080-20-git-send-email-gcosta@redhat.com> <1214602486-17080-21-git-send-email-gcosta@redhat.com> <1214602486-17080-22-git-send-email-gcosta@redhat.com> <1214602486-17080-23-git-send-email-gcosta@redhat.com> <1214602486-17080-24-git-send-email-gcosta@redhat.com> <1214602486-17080-25-git-send-email-gcosta@redhat.com> <1214602486-17080-26-git-send-email-gcosta@redhat.com> <20080630063030.GA31336@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630063030.GA31336@elte.hu>
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

> * Glauber Costa <gcosta@redhat.com> wrote:
> 
> > common parts of uaccess_32.h and uaccess_64.h
> > are put in uaccess.h.
> 
> -tip testing found that it causes this build failure:
> 
>   fs/binfmt_aout.c: Assembler messages:
>   fs/binfmt_aout.c:152: Error: suffix or operands invalid for `cmp'
> 
> with:
> 
>   http://redhat.com/~mingo/misc/config-Mon_Jun_30_08_17_42_CEST_2008.bad

there was another merge fallout as well, when i merged it into 
tip/master - see below.

	Ingo

------------->
commit d0a1b893fd764ae722cef905bf282c52b768feb1
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jun 30 08:05:44 2008 +0200

    - fix merge fallout between x86/unify-lib and tracing/nmisafe
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 32c5ffd..19c7210 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -765,7 +765,7 @@ retint_signal:
 	/* Returning to kernel space from exception. */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retexc_kernel)
-	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
+	testl $HARDNMI_MASK, TI_preempt_count(%rcx)
 	jz retint_kernel		/* Not nested over NMI ? */
 	testw $X86_EFLAGS_TF,EFLAGS-ARGOFFSET(%rsp)	/* trap flag? */
 	jnz retint_kernel		/*
@@ -946,7 +946,7 @@ paranoid_restore_no_nmi\trace:
 	jmp irq_return
 paranoid_restore\trace:
 	GET_THREAD_INFO(%rcx)
-	testl $HARDNMI_MASK,threadinfo_preempt_count(%rcx)
+	testl $HARDNMI_MASK, TI_preempt_count(%rcx)
 	jz paranoid_restore_no_nmi\trace	/* Nested over NMI ? */
 	testw $X86_EFLAGS_TF,EFLAGS-0(%rsp)	/* trap flag? */
 	jnz paranoid_restore_no_nmi\trace

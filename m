Return-Path: <linux-kernel-owner+w=401wt.eu-S1751207AbZHSMQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbZHSMQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZHSMQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:16:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbZHSMQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:16:03 -0400
Date: Wed, 19 Aug 2009 14:15:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org
Subject: [patch] Re: Next Aug 19: s390 build failure
	(arch/s390/kernel/built-in)
Message-ID: <20090819121556.GA24041@elte.hu>
References: <20090819190233.86e78493.sfr@canb.auug.org.au> <4A8BDE59.2010400@in.ibm.com> <20090819114646.GB32317@elte.hu> <4A8BE82D.4000407@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8BE82D.4000407@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sachin Sant <sachinp@in.ibm.com> wrote:

> Ingo Molnar wrote:
>> Could you please send the .config that triggers this?
>>
>>   
> .config Attached.

thanks - does the patch below fix the bug for you?

	Ingo

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 05f57cd..c5e87d8 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -51,6 +51,9 @@
 #include "compat_ptrace.h"
 #endif
 
+DEFINE_TRACE(syscall_enter);
+DEFINE_TRACE(syscall_exit);
+
 enum s390_regset {
 	REGSET_GENERAL,
 	REGSET_FP,

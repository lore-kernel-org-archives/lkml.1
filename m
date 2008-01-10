Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbYAJMlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbYAJMlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYAJMky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:40:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39391 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbYAJMkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:40:53 -0500
Date: Thu, 10 Jan 2008 13:40:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove ifdef from step.c
Message-ID: <20080110124041.GA15156@elte.hu>
References: <1199949482.19760.9.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199949482.19760.9.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> @@ -148,11 +148,7 @@ static void write_debugctlmsr(struct task_struct *child, unsigned long val)
>  	if (child != current)
>  		return;
>  
> -#ifdef CONFIG_X86_64
> -	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
> -#else
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, val, 0);
> -#endif

doesnt this break 64-bit? 'val' is 64-bit, but wrmsr truncates it to 
32-bit? [while wrmsrl() kept the full 64 bits]

	Ingo

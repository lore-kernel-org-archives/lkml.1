Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbYJXLuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbYJXLuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYJXLu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:50:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44143 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbYJXLuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:50:25 -0400
Date: Fri, 24 Oct 2008 13:50:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] ftrace : Fix section mismatch warning.
Message-ID: <20081024115005.GA5214@elte.hu>
References: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com> <20081020162756.GA31201@elte.hu> <20081022070312.GA24749@elte.hu> <b9df5fa10810240409u311bb337x1ff9815431088685@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10810240409u311bb337x1ff9815431088685@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0144]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> Does the following solves the problem?
> Thanks.
> 
> --- linux-2.6-orig/arch/x86/kernel/ftrace.c	2008-10-24 16:35:48.000000000 +0600
> +++ linux-2.6/arch/x86/kernel/ftrace.c	2008-10-24 16:40:09.000000000 +0600
> @@ -129,7 +129,7 @@ int __init ftrace_dyn_arch_init(void *da
>  	asm volatile (
>  		"jmp ftrace_test_jmp\n"
>  		/* This code needs to stay around */
> -		".section .text, \"ax\"\n"
> +		".section .text.init, \"ax\"\n"

how about the "This code needs to stay around" comment?

	Ingo

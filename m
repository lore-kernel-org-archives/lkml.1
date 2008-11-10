Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYKJHp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYKJHp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYKJHpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:45:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYKJHpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:45:49 -0500
Date: Mon, 10 Nov 2008 08:45:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC-PATCH] x86: really use __builtin_memcmp on x86_32
Message-ID: <20081110074536.GB2093@elte.hu>
References: <1226297544.5478.26.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226297544.5478.26.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Impact: prevent generic code from overriding __builtin_memcmp
> 
> lib/string.c was using a generic implementation of memcmp
> because __HAVE_ARCH_MEMCMP was not defined and it was then doing
> #undef memcmp and defining a generic version.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  arch/x86/include/asm/string_32.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

> +#define __HAVE_ARCH_MEMCMP
>  #define memcmp __builtin_memcmp
>  
>  #define __HAVE_ARCH_MEMCHR

on a quick look, since x86 sets __HAVE_ARCH_STRSTR, nothing in 
lib/string.c would actually use this generic (and slower) memcmp 
implementation, correct? So there should be no impact to object code, 
it's a cleanup - right?

	Ingo

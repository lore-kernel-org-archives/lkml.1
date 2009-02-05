Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbZBEOxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbZBEOxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbZBEOwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:52:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41767 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZBEOwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:52:50 -0500
Date: Thu, 5 Feb 2009 15:52:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Floris Kraak <randakar@gmail.com>, Arjan van de Ven <arjan@infradead.org>
Cc: Roland Dreier <rdreier@cisco.com>, Robert Hancock <hancockrwd@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH]: Cleanup: Remove gcc format string warnings when
	compiling with -Wformat-security (was: Re: [PATCH] Kbuild: Disable
	the -Wformat-security gcc flag)
Message-ID: <20090205145226.GA23903@elte.hu>
References: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
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


* Floris Kraak <randakar@gmail.com> wrote:

> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -112,7 +112,7 @@ print_context_stack(struct thread_info *tinfo,
>  static void
>  print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
>  {
> -	printk(data);
> +	printk("%s", data);
>  	print_symbol(msg, symbol);
>  	printk("\n");

Arjan, the code above seems to be dead and never called. These methods:

static const struct stacktrace_ops print_trace_ops = {
        .warning = print_trace_warning,
        .warning_symbol = print_trace_warning_symbol,

are not used anywhere that i can see. Could you have a look at this please?

	Ingo

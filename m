Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbZBKMXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbZBKMXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZBKMWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:22:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbZBKMWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:22:42 -0500
Date: Wed, 11 Feb 2009 13:22:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] ring_buffer: pahole struct ring_buffer
Message-ID: <20090211122236.GC16535@elte.hu>
References: <20090209190406.GA11005@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209190406.GA11005@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Hi,
> 
> While fixing some bugs in pahole (built-in.o files were not being
> processed due to relocation problems) I found out about these packable
> structures:
> 
> $ pahole --packable kernel/trace/ring_buffer.o  | grep ring
> ring_buffer	72	64	8
> ring_buffer_per_cpu	112	104	8

>  ring_buffer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 53ba3a6..27ef3bf 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -273,8 +273,8 @@ struct ring_buffer {
>  	unsigned			pages;
>  	unsigned			flags;
>  	int				cpus;
> -	cpumask_var_t			cpumask;
>  	atomic_t			record_disabled;
> +	cpumask_var_t			cpumask;

Applied to tip:tracing/ring-buffer, thanks Arnaldo!

Is there anything packable in core kernel structures like task struct?

	Ingo

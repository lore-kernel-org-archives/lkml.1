Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZFTQZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZFTQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 12:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZFTQZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 12:25:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50145 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZFTQZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 12:25:15 -0400
Date: Sat, 20 Jun 2009 18:25:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] function-graph: disable when both x86_32 and
	optimize for size are configured
Message-ID: <20090620162513.GD32377@elte.hu>
References: <20090618224409.916725341@goodmis.org> <20090618225248.476090968@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618225248.476090968@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 4a13e5a..1eac852 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -121,6 +121,7 @@ config FUNCTION_GRAPH_TRACER
>  	bool "Kernel Function Graph Tracer"
>  	depends on HAVE_FUNCTION_GRAPH_TRACER
>  	depends on FUNCTION_TRACER
> +	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
>  	default y

Hm, nice fix, but this is a quite nasty constraint - distros like to 
enable CC_OPTIMIZE_FOR_SIZE as it neatly trims the kernel's size by 
about 30%.

Just in case you have not checked yet: is there no way to turn off 
the specific gcc optimization that causes this? Or is it -Os itself 
that does this optimization?

	Ingo

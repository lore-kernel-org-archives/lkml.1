Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbZECIdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbZECIdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 04:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZECIdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 04:33:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40663 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbZECIdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 04:33:41 -0400
Date: Sun, 3 May 2009 10:33:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, jistone@redhat.com
Subject: Re: [PATCH] export softirq_to_name symbol
Message-ID: <20090503083328.GC27707@elte.hu>
References: <20090501193022.GB3111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501193022.GB3111@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> hi,
> 
> In response to a user request:
> 
> Export 'softirq_to_name' so that modules using the softirq 
> tracepoints can resolve the # to a name.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  kernel/softirq.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index b76064b..1841ab7 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -60,6 +60,7 @@ char *softirq_to_name[NR_SOFTIRQS] = {
>  	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
>  	"TASKLET", "SCHED", "HRTIMER",	"RCU"
>  };
> +EXPORT_SYMBOL_GPL(softirq_to_name);

Hm, that very much looks like as if someone was writing kernel 
tracing code without the intention to submitting it upstream. Not 
having exported that symbol is thus a subtle "dont do that please" 
warning sign ;-)

	Ingo

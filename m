Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZBQKe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZBQKe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 05:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbZBQKeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 05:34:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49261 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbZBQKeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 05:34:17 -0500
Date: Tue, 17 Feb 2009 11:34:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 04/15] ftrace: break up ftrace_match_records into
	smaller components
Message-ID: <20090217103401.GA6602@elte.hu>
References: <20090217051227.957864159@goodmis.org> <20090217051405.772028305@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217051405.772028305@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> +static void ftrace_match_records(char *buff, int len, int enable)
> +{
> +	char *search;
> +	struct ftrace_page *pg;
> +	struct dyn_ftrace *rec;
> +	int type;
> +	unsigned long flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;
> +	unsigned search_len;
> +	int not;

Small style nit, the above looks better as:

> +	unsigned int search_len;
> +	struct ftrace_page *pg;
> +	struct dyn_ftrace *rec;
> +	unsigned long flag;
> +	char *search;
> +	int type;
> +	int not;
> +
> +	flag = enable ? FTRACE_FL_FILTER : FTRACE_FL_NOTRACE;

and this is what we do in other places of the tracing code.

(Also note the change of 'unsigned search_len' to 'unsigned int 
search_len'.)

	Ingo

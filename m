Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbZBDTrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbZBDTrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZBDTqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:46:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbZBDTqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:46:53 -0500
Date: Wed, 4 Feb 2009 20:46:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH tip 1/1] trace: judicious error checking of trace_seq
	results
Message-ID: <20090204194635.GC22608@elte.hu>
References: <20090203222041.GE3440@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203222041.GE3440@ghostprotocols.net>
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

> Impact: bugfix/cleanup
> 
> Some callsites were returning either TRACE_ITER_PARTIAL_LINE if the
> trace_seq routines (trace_seq_printf, etc) returned 0 meaning its buffer
> was full, or zero otherwise.
> 
> But...
> 
> /* Return values for print_line callback */
> enum print_line_t {
>         TRACE_TYPE_PARTIAL_LINE = 0,    /* Retry after flushing the seq */
>         TRACE_TYPE_HANDLED      = 1,
>         TRACE_TYPE_UNHANDLED    = 2     /* Relay to other output functions */
> };
> 
> In other cases the return value was not being relayed at all.
> 
> Most of the time it didn't hurt because the page wasn't get filled, but
> for correctness sake, handle the return values everywhere.

applied to tip:tracing/ftrace, thanks Arnaldo!

	Ingo

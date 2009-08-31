Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZHaI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZHaI7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZHaI7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:59:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZHaI7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:59:18 -0400
Date: Mon, 31 Aug 2009 10:59:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Defer pred allocation
Message-ID: <20090831085908.GA656@elte.hu>
References: <4A9B8EA5.6020700@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9B8EA5.6020700@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> init_preds() allocates about 5392 bytes of memory (on x86_32) for
> a TRACE_EVENT. With my config, at system boot total memory occupied
> is:
> 
> 	5392 * (642 + 15) == 3459KB
> 
> 642 == cat available_events | wc -l
> 15 == number of dirs in events/ftrace
> 
> That's quite a lot, so we'd better defer memory allocation util
> it's needed, that's when filter is used.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Applied, thanks!

> tracing/kprobe needs rebase after this patch..

You mean with many probes registered it has a lot of memory 
footprint? Instead of a rebase a merge of tracing/core into 
tracing/kprobes would be less intrusive.

	Ingo

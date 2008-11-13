Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbYKMIlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbYKMIlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYKMIlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:41:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYKMIlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:41:10 -0500
Date: Thu, 13 Nov 2008 09:40:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/1] ftrace: do not update max buffer with no users
Message-ID: <20081113084040.GD25479@elte.hu>
References: <20081113043449.751885305@goodmis.org> <20081113043751.796120007@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113043751.796120007@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Impact: only use max latency buffer when a user is configured
> 
> Pekka reported a bug with the resizing of the buffers when only the 
> MMIO tracer was configured. The issue was, to save memory, the max 
> latency trace buffer was only initialized if a tracer that uses it 
> is configured in.
> 
> What happened was that the max latency buffer was never initialized 
> when only the MMIO tracer was configurued. The MMIO tracer does not 
> use the max tracer, which kept it from being initialized. But the 
> resize code still tried to resize the max latency buffers, but 
> because they were never allocated, the resize code was passed a NULL 
> pointer.
> 
> This patch checks if the max tracer is NULL before resizing it. It 
> also hides the modification functions of the max tracer behind the 
> TRACER_MAX_TRACE config.
> 
> Reported-by: Pekka Paalanen <pq@iki.fi>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |  171 ++++++++++++++++++++++++++------------------------
>  1 files changed, 88 insertions(+), 83 deletions(-)

This is _way_ too much churn for .28, we need a much simpler solution.

	Ingo

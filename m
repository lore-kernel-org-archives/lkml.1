Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbYKPHeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbYKPHeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYKPHeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:34:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47419 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYKPHeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:34:06 -0500
Date: Sun, 16 Nov 2008 08:33:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: walimis <walimisdev@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] ftrace: fix wrong pos computing when read buffer
	has been fulfilled.
Message-ID: <20081116073354.GF19646@elte.hu>
References: <1226733546-23190-1-git-send-email-walimisdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226733546-23190-1-git-send-email-walimisdev@gmail.com>
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


* walimis <walimisdev@gmail.com> wrote:

> hi Steven,
> 
> Could you help me to review this patch?
> 
> Thanks.
> 
> Impact: make output of available_filter_functions complete
> 
> phenomenon:
> 
> The first value of dyn_ftrace_total_info is not equal with
> `cat available_filter_functions | wc -l`, but they should be equal.
> 
> root cause:
> 
> When printing functions with seq_printf in t_show, if the read 
> buffer is just overflowed by current function record, then this 
> function won't be printed to user space through read buffer, it will 
> just be dropped. So we can't see this function printing. So, every 
> time the last function to fill the read buffer, if overflowed, will 
> be dropped. This also applies to set_ftrace_filter if 
> set_ftrace_filter has more bytes than read buffer.
> 
> fix:
> 
> Through checking return value of seq_printf, if less than 0, we know 
> this function doesn't be printed. Then we decrease position to force 
> this function to be printed next time, in next read buffer.
> 
> another little fix is to show correct allocating pages count.
> 
> Signed-off-by: walimis <walimisdev@gmail.com>
> ---
>  kernel/trace/ftrace.c |   26 +++++++++++++++-----------
>  1 files changed, 15 insertions(+), 11 deletions(-)

looks sane - applied to tip/tracing/urgent. Steve, any objections?

	Ingo

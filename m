Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZDBLdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZDBLdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZDBLcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:32:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbZDBLcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:32:50 -0400
Date: Thu, 2 Apr 2009 13:32:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] perf_counter: per event wakeups
Message-ID: <20090402113234.GE10828@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.323309784@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402091319.323309784@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> By request, provide a way to request a wakeup every 'n' events instead
> of every page of output.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/perf_counter.h |    3 ++-
>  kernel/perf_counter.c        |   10 +++++++++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/include/linux/perf_counter.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_counter.h
> +++ linux-2.6/include/linux/perf_counter.h
> @@ -146,7 +146,7 @@ struct perf_counter_hw_event {
>  				__reserved_1   : 52;
>  
>  	__u32			extra_config_len;
> -	__u32			__reserved_4;
> +	__u32			wakeup_events;	/* wakeup every n events */

[ Sidenote: i think we need more reserved bits :-) Expand the ABI
  while it's still easy ;-) ]

I have a design observation here:

i think 'wakeup' is a user-space notification type. Another type of 
notication can be 'signal', or 'none'.

Perhaps your current scheme makes the most sense: to treat them as 
separate attributes, and allow signal delivery and wakeups at once. 
(if user-space so wishes)

Agreed?

	Ingo

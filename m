Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbYAJICT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbYAJICT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYAJICM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:02:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50640 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbYAJICL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:02:11 -0500
Date: Thu, 10 Jan 2008 09:01:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: tglx@linutronix.de, hpa@zytor.com, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: move out tick_nohz_stop_sched_tick() call from
	the loop
Message-ID: <20080110080146.GB19470@elte.hu>
References: <47859486.30609@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47859486.30609@ct.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> @@ -170,14 +170,13 @@ void cpu_idle(void)
>  	current_thread_info()->status |= TS_POLLING;
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> +		tick_nohz_stop_sched_tick();
>  		while (!need_resched()) {
>  			void (*idle)(void);
>  
>  			if (__get_cpu_var(cpu_idle_state))
>  				__get_cpu_var(cpu_idle_state) = 0;
>  
> -			tick_nohz_stop_sched_tick();
> -

thanks, applied.

	Ingo

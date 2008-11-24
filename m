Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYKXPeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYKXPeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYKXPdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:33:52 -0500
Received: from www.tglx.de ([62.245.132.106]:51910 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbYKXPdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:33:51 -0500
Date: Mon, 24 Nov 2008 16:32:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Petr Tesarik <ptesarik@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Fix clock_gettime with CLOCK_PROCESS_CPUTIME_ID
In-Reply-To: <1227537991.20064.6.camel@nathan.suse.cz>
Message-ID: <alpine.LFD.2.00.0811241625050.3301@localhost.localdomain>
References: <1227537991.20064.6.camel@nathan.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Petr Tesarik wrote:

> Since CLOCK_PROCESS_CPUTIME_ID is in fact translated to -6, the switch
> statement in cpu_clock_sample_group() must first mask off the irrelevant
> bits, similar to cpu_clock_sample().
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

Good catch. Applied.

Thanks,

	tglx

> --
>  posix-cpu-timers.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -311,7 +311,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
>  	struct task_cputime cputime;
>  
>  	thread_group_cputime(p, &cputime);
> -	switch (which_clock) {
> +	switch (CPUCLOCK_WHICH(which_clock)) {
>  	default:
>  		return -EINVAL;
>  	case CPUCLOCK_PROF:
> 
> 

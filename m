Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZBZSJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZBZSJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZBZSJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:09:33 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48562 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZBZSJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:09:32 -0500
Subject: Re: [tip:timers/ntp] time: apply NTP frequency/tick changes
 immediately, fix
From: John Stultz <johnstul@us.ibm.com>
To: hpa@zytor.com, mingo@redhat.com, williams@redhat.com, tglx@linutronix.de,
       mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <tip-a66a97da747f7a119f45626c9d8170f8cac61b37@kernel.org>
References: <tip-a66a97da747f7a119f45626c9d8170f8cac61b37@kernel.org>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 10:08:05 -0800
Message-Id: <1235671685.3793.31.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 17:57 +0000, John Stultz wrote:
> Author:     John Stultz <johnstul@us.ibm.com>
> AuthorDate: Thu, 26 Feb 2009 09:46:14 -0800
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 26 Feb 2009 18:55:36 +0100
> 
> time: apply NTP frequency/tick changes immediately, fix

Sorry, the commit name isn't quite right there. I should have added the
patch name explicitly. This patch was a fix to the following patch in
-tip:

time: ntp: fix bug in ntp_update_offset() & do_adjtimex()


thanks
-john



> The time_status conditional was accidentally placed right after we clear
> the checked time_status bits, which causes us to take the conditional
> every time through. This fixes it by moving the conditional to before we
> clear the time_status bits.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> Cc: Clark Williams <williams@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/time/ntp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index c74eb7d..7fc6437 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -365,8 +365,6 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
>  		time_state = TIME_OK;
>  		time_status = STA_UNSYNC;
>  	}
> -	/* only set allowed bits */
> -	time_status &= STA_RONLY;
> 
>  	/*
>  	 * If we turn on PLL adjustments then reset the
> @@ -375,6 +373,8 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
>  	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
>  		time_reftime = xtime.tv_sec;
> 
> +	/* only set allowed bits */
> +	time_status &= STA_RONLY;
>  	time_status |= txc->status & ~STA_RONLY;
> 
>  	switch (time_state) {


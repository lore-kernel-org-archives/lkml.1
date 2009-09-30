Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZI3VUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZI3VUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZI3VUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:20:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZI3VUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:20:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] CPUidle: always return with interrupts enabled
Date: Wed, 30 Sep 2009 23:21:33 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <1254332153-23493-1-git-send-email-khilman@deeprootsystems.com>
In-Reply-To: <1254332153-23493-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909302321.33088.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009, Kevin Hilman wrote:
> In the case where cpuidle_idle_call() returns before changing state
> due to a need_resched(), it was returning with IRQs disabled.
> 
> This patch ensures IRQs are (re)enabled before returning.

Venki, any comments on this?

> Reported-by: Hemanth V <hemanthv@ti.com>
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> ---
>  drivers/cpuidle/cpuidle.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index ad41f19..12fdd39 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -76,8 +76,11 @@ static void cpuidle_idle_call(void)
>  #endif
>  	/* ask the governor for the next state */
>  	next_state = cpuidle_curr_governor->select(dev);
> -	if (need_resched())
> +	if (need_resched()) {
> +		local_irq_enable();
>  		return;
> +	}
> +
>  	target_state = &dev->states[next_state];
>  
>  	/* enter the state and update stats */

Best,
Rafael

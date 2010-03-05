Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0CEUSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 15:18:00 -0500
Received: from www.tglx.de ([62.245.132.106]:33202 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0CEUR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 15:17:59 -0500
Date: Fri, 5 Mar 2010 21:16:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] genirq: spurious irq detection for threaded irqs
In-Reply-To: <1267802291-5197-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1003052102580.2014@localhost.localdomain>
References: <alpine.LFD.2.00.1003042323090.2014@localhost.localdomain> <1267802291-5197-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1855234459-1267820214=:2014"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1855234459-1267820214=:2014
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 5 Mar 2010, Uwe Kleine-König wrote:

> For threaded irqs the top half returns IRQ_WAKE_THREAD.  Don't treat
> that value like IRQ_HANDLED for the spurious check.  Instead check the
> return value of the threaded handler to be able to detect stuck irqs
> that only have threaded handlers and no top half that can detect the
> problem.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> Hello,
> 
> changed since v1:
> 
>  - use note_interrupt for the threaded handler's return value, getting rid of
>    note_threaded_interrupt.  The only downside is that a threaded handler
>    returning IRQ_WAKE_THREAD remains uncatched now.

Well that's easy to fix.
 
> +			if (!noirqdebug)
> +				note_interrupt(action->irq, desc, action_ret);

  				note_interrupt(action->irq, desc,
  					       action_ret & ~IRQ_WAKE_THREAD);
Thanks,

	tglx
--8323328-1855234459-1267820214=:2014--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZG0UPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZG0UPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZG0UPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:15:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZG0UPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:15:43 -0400
Subject: Re: [PATCH] softlockup: fix problem with long kernel pauses from
 kgdb
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>
In-Reply-To: <4A6E0825.3020604@windriver.com>
References: <4A6E0825.3020604@windriver.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 22:18:13 +0200
Message-Id: <1248725893.6987.2055.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 15:03 -0500, Jason Wessel wrote:
> 
> The fix is to simply invoke sched_clock_tick() to update "cpu sched
> clock" on exit from kgdb_handle_exception.

Is that a regular IRQ context, or is that NMI context?

> Signed-off-by: Dongdong Deng <Dongdong.Deng@windriver.com>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: peterz@infradead.org
> ---
>  kernel/softlockup.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -118,6 +118,9 @@ void softlockup_tick(void)
>         }
>  
>         if (touch_timestamp == 0) {
> +               /* If the time stamp was touched externally make sure the
> +                * scheduler tick is up to date as well */
> +               sched_clock_tick();
>                 __touch_softlockup_watchdog();
>                 return;
>         }
> 

Aside from the funny comment style (please fix) the fix does look
sensible.

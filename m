Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0BWQ35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 11:29:57 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:18162 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752373Ab0BWQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 11:29:56 -0500
Message-ID: <4B840154.1010501@draigBrady.com>
Date: Tue, 23 Feb 2010 16:24:52 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: linux-kernel@vger.kernel.org, wim@iguana.be, seth.heasley@intel.com
Subject: Re: [PATCH] iTCO_wdt: Don't stop on shutdown with nowayout
References: <20100223164019.60a6de1a@marrow.netinsight.se>
In-Reply-To: <20100223164019.60a6de1a@marrow.netinsight.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/10 15:40, Simon Kagstrom wrote:
> Currently, the watchdog is turned off when the system shuts down or the
> module is unloaded. If nowayout has been selected, this makes no sense
> and fails to restart the system if it hangs during reboot, so make it
> conditional.
>
> Signed-off-by: Simon Kagstrom<simon.kagstrom@netinsight.net>
> ---
> We have a system which has such a hang, and therefore want the watchdog
> to be on until the bitter end.
>
>   drivers/watchdog/iTCO_wdt.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
> index 4bdb7f1..927df26 100644
> --- a/drivers/watchdog/iTCO_wdt.c
> +++ b/drivers/watchdog/iTCO_wdt.c
> @@ -839,7 +839,8 @@ static int __devexit iTCO_wdt_remove(struct platform_device *dev)
>
>   static void iTCO_wdt_shutdown(struct platform_device *dev)
>   {
> -	iTCO_wdt_stop();
> +	if (!nowayout)
> +		iTCO_wdt_stop();
>   }
>
>   #define iTCO_wdt_suspend NULL

I see the issue, however what happens if you're
rebooting into a system that doesn't then renable the watchdog.
I've seen systems where the hardware watchdog is not reset
during the reboot process, in which case you'll get a
reboot while running the other system.

If you had a readonly system, then perhaps you
can just  WDIOC_SETTIMEOUT the hardware watchdog timeout to 1s
and wait for it to reboot the system?

cheers,
Pádraig.

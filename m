Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYG2NnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYG2NnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYG2NnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:43:09 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:3580 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbYG2NnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Bw9gJ8+7RREi4+MkykN9AOQpXbUyywa06wspO5bBdNKSFawhrpF4BlN8+CpXdZM1f4
         avKCkBuDbQAEr+oWqrZEBF8JSH195hJiwOKzXU3w9Ny5wzBjw7Q1AlGHepxO9XaYO6RT
         hfMBn7ornQDprHdmmqLcBwMW9k2M9BxV2WhbU=
Message-ID: <dd18b0c30807290643o3552ddb8s31fc323df8d02adc@mail.gmail.com>
Date: Tue, 29 Jul 2008 06:43:06 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: Komuro <komurojun-mbn@nifty.com>
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080729215315.5a505fe7.komurojun-mbn@nifty.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
	 <20080729215315.5a505fe7.komurojun-mbn@nifty.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 5:53 AM, Komuro <komurojun-mbn@nifty.com> wrote:
> Hi,
>
> Please try to comment out the "WARN_ON_ONCE"
> at net/sched/sched_generic.c.
>
>
> --- linux-2.6.27-rc1/net/sched/sch_generic.c.orig       2008-07-29 21:45:36.000000000 +0900
> +++ linux-2.6.27-rc1/net/sched/sch_generic.c    2008-07-29 21:45:54.000000000 +0900
> @@ -216,7 +216,6 @@ static void dev_watchdog(unsigned long a
>                                printk(KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit timed out\n",
>                                       dev->name, netdev_drivername(dev, drivername, 64));
>                                dev->tx_timeout(dev);
> -                               WARN_ON_ONCE(1);
>                        }
>                        if (!mod_timer(&dev->watchdog_timer,
>                                       round_jiffies(jiffies +
>
>
>
>>I should'nt be posting this, due to
>>having  tainted modules(madwifi), but
>>I figured I might as well:(below)
>>
>>[ 5000.986044] NETDEV WATCHDOG: wifi0: transmit timed out
>>[ 5000.991959] ------------[ cut here ]------------
>>[ 5000.991964] WARNING: at net/sched/sch_generic.c:222 dev_watchdog+0x95/0xe7()
>
> Best Regards
> Komuro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Cool thanks for the patch.
I'll plug it in and see if I get this message again.

-- 
Justin P. Mattock

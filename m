Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYKVVxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYKVVxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 16:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYKVVww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 16:52:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:43241 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYKVVwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 16:52:51 -0500
Subject: Re: [PATCH 13/32] rackmeter section fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1L3wOC-0006T5-Ji@ZenIV.linux.org.uk>
References: <E1L3wOC-0006T5-Ji@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 08:52:00 +1100
Message-Id: <1227390720.7185.276.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 17:35 +0000, Al Viro wrote:
> * rackmeter_remove() reference needs devexit_p
> * rackmeter_setup() is calls devinit and is called only from devinit
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

>  drivers/macintosh/rack-meter.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
> --- a/drivers/macintosh/rack-meter.c
> +++ b/drivers/macintosh/rack-meter.c
> @@ -288,7 +288,7 @@ static void __devexit rackmeter_stop_cpu_sniffer(struct rackmeter *rm)
>  	cancel_rearming_delayed_work(&rm->cpu[1].sniffer);
>  }
>  
> -static int rackmeter_setup(struct rackmeter *rm)
> +static int __devinit rackmeter_setup(struct rackmeter *rm)
>  {
>  	pr_debug("rackmeter: setting up i2s..\n");
>  	rackmeter_setup_i2s(rm);
> @@ -582,12 +582,12 @@ static struct of_device_id rackmeter_match[] = {
>  	{ }
>  };
>  
> -static struct macio_driver rackmeter_drv = {
> +static struct macio_driver rackmeter_driver = {
>  	.name = "rackmeter",
>  	.owner = THIS_MODULE,
>  	.match_table = rackmeter_match,
>  	.probe = rackmeter_probe,
> -	.remove = rackmeter_remove,
> +	.remove = __devexit_p(rackmeter_remove),
>  	.shutdown = rackmeter_shutdown,
>  };
>  
> @@ -596,14 +596,14 @@ static int __init rackmeter_init(void)
>  {
>  	pr_debug("rackmeter_init()\n");
>  
> -	return macio_register_driver(&rackmeter_drv);
> +	return macio_register_driver(&rackmeter_driver);
>  }
>  
>  static void __exit rackmeter_exit(void)
>  {
>  	pr_debug("rackmeter_exit()\n");
>  
> -	macio_unregister_driver(&rackmeter_drv);
> +	macio_unregister_driver(&rackmeter_driver);
>  }
>  
>  module_init(rackmeter_init);
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZGVRhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZGVRhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZGVRhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:37:37 -0400
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:43214 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752192AbZGVRhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:37:37 -0400
X-Yahoo-Newman-Id: 511395.45421.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aXYmftpsdPiVlBXW9MNcthVtBRTaQkZp0HqjXcTo7XBVQgBDvlNi32sDX/5yFeycnc8d/ZALBgly66PJfHwUrcjmVhIXDalQBImcpatFbwkzRR2d8an33RSytYQJlQ1XmXCWVjqSEGkhNHkreTOx4WnypXtiVC4Y+wFt9ncNClE=  ;
X-YMail-OSG: pyFy3KMVM1mR.ZDmwZhAXT7sUh0KcteqZ7_wsHJDmLSpYTMKf1GITaoOrgC096yWMiD8NdRUSbyI2NQSCOZjsjX_8unI3EVvQ1zw9qXfK39HB8qCRJXnduJQ5ZT_OSb0mHq0Z0Hh.eVwR2.q11LadmeXN41SwbaCkR7W525t_hacvkMturE_a_z.VST02X0jSKNtNt4aJDNPz74WZER9WVADYxz24RcxzPeWLa2ssksm1kLgtovJbx8CRsjPiYCXyOCztA50MNViCl5eBpEFlRvXyreKHFtC8yA_kcmkixHTSNk-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] register at91_ether using platform_driver_probe
Date: Wed, 22 Jul 2009 10:37:36 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       netdev@vger.kernel.org,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <200907111527.46441.david-b@pacbell.net> <1248207099-14583-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1248207099-14583-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907221037.36541.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Uwe Kleine-König wrote:
> at91ether_probe lives in .init.text, so using platform_driver_register
> to register it is wrong because binding a device after the init memory
> is discarded (e.g. via sysfs) results in an oops.
> 
> As requested by David Brownell platform_driver_probe is used instead of
> moving the probe function to .devinit.text as proposed initially.
> This saves some memory, but devices registered after the driver is
> probed are not bound (probably there are none) and binding via sysfs
> isn't possible.

Right, these devices do not hotplug.

> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

.... and thanks for doing it this way.  :)

> Cc: netdev@vger.kernel.org
> Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> Cc: Marc Pignat <marc.pignat@hevs.ch>
> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: Roel Kluin <12o3l@tiscali.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/net/arm/at91_ether.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
> index 2e7419a..5041d10 100644
> --- a/drivers/net/arm/at91_ether.c
> +++ b/drivers/net/arm/at91_ether.c
> @@ -1228,7 +1228,6 @@ static int at91ether_resume(struct platform_device *pdev)
>  #endif
>  
>  static struct platform_driver at91ether_driver = {
> -	.probe		= at91ether_probe,
>  	.remove		= __devexit_p(at91ether_remove),
>  	.suspend	= at91ether_suspend,
>  	.resume		= at91ether_resume,
> @@ -1240,7 +1239,7 @@ static struct platform_driver at91ether_driver = {
>  
>  static int __init at91ether_init(void)
>  {
> -	return platform_driver_register(&at91ether_driver);
> +	return platform_driver_probe(&at91ether_driver, at91ether_probe);
>  }
>  
>  static void __exit at91ether_exit(void)
> -- 
> tg: (4b0a840..) t/platsection/at91ether_driver (depends on: linus/master)
> 
> 




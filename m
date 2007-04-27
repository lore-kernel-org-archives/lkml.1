Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbXD0DNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbXD0DNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 23:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbXD0DNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 23:13:50 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:27535 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755212AbXD0DNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 23:13:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JIDLEF0jjLnWtBVdJ+OBdUxfhkSJ1HKFVB3QmX/ius0h7smigvWBlLat+jCVqqQL9QPtRAdJkrqZmWRJ44sD8ea/4GJyVVFu6gAp1u/gZXMYAQok1AoW0iZnFY/m49PUPKEOvMgX328uKDT3WacxYmH+B2hvK7P1q9/T+vwU8n0=  ;
X-YMail-OSG: Mz6nQf0VM1n3lyjs6aHNrqTZiBSbFAxQLMjaWCqzsniHPTU5.ecW32tfDPlp_iKWv55LeNOrpw--
From: David Brownell <david-b@pacbell.net>
To: Marko Vrh <mvrh@freeshells.ch>
Subject: Re: [PATCH] rtc-cmos: make it load on PNPBIOS systems
Date: Thu, 26 Apr 2007 20:13:44 -0700
User-Agent: KMail/1.9.6
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
References: <Pine.NEB.4.64.0704270011030.11494@freeshells.ch>
In-Reply-To: <Pine.NEB.4.64.0704270011030.11494@freeshells.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262013.44906.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007, Marko Vrh wrote:
> Replace CONFIG_PNPACPI with CONFIG_PNP, so it loads on
> ACPI-less PNPBIOS systems.
> 
> Signed-off-by: Marko Vrh <mvrh@freeshells.ch>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> 
> ----
> 
> diff -urNp linux-2.6.21/drivers/rtc/rtc-cmos.c linux-2.6.21.new/drivers/rtc/rtc-cmos.c
> --- linux-2.6.21/drivers/rtc/rtc-cmos.c	2007-04-26 05:08:32.000000000 +0200
> +++ linux-2.6.21.new/drivers/rtc/rtc-cmos.c	2007-04-26 23:58:36.000000000 +0200
> @@ -379,12 +379,12 @@ static irqreturn_t cmos_interrupt(int ir
>   		return IRQ_NONE;
>   }
> 
> -#ifdef	CONFIG_PNPACPI
> -#define	is_pnpacpi()	1
> +#ifdef	CONFIG_PNP
> +#define	is_pnp()	1
>   #define	INITSECTION
> 
>   #else
> -#define	is_pnpacpi()	0
> +#define	is_pnp()	0
>   #define	INITSECTION	__init
>   #endif
> 
> @@ -427,7 +427,7 @@ cmos_do_probe(struct device *dev, struct
>   	 * REVISIT for non-x86 systems we may need to handle io memory
>   	 * resources: ioremap them, and request_mem_region().
>   	 */
> -	if (is_pnpacpi()) {
> +	if (is_pnp()) {
>   		retval = request_resource(&ioport_resource, ports);
>   		if (retval < 0) {
>   			dev_dbg(dev, "i/o registers already in use\n");
> @@ -520,7 +520,7 @@ static void __exit cmos_do_remove(struct
> 
>   	cmos_do_shutdown();
> 
> -	if (is_pnpacpi())
> +	if (is_pnp())
>   		release_resource(cmos->iomem);
>   	rename_region(cmos->iomem, NULL);
> 
> @@ -613,7 +613,7 @@ static int cmos_resume(struct device *de
>    * the device node will always be created as a PNPACPI device.
>    */
> 
> -#ifdef	CONFIG_PNPACPI
> +#ifdef	CONFIG_PNP
> 
>   #include <linux/pnp.h>
> 
> @@ -684,11 +684,11 @@ static void __exit cmos_exit(void)
>   }
>   module_exit(cmos_exit);
> 
> -#else	/* no PNPACPI */
> +#else	/* no PNP */
> 
>   /*----------------------------------------------------------------*/
> 
> -/* Platform setup should have set up an RTC device, when PNPACPI is
> +/* Platform setup should have set up an RTC device, when PNP is
>    * unavailable ... this could happen even on (older) PCs.
>    */
> 
> @@ -734,7 +734,7 @@ static void __exit cmos_exit(void)
>   module_exit(cmos_exit);
> 
> 
> -#endif	/* !PNPACPI */
> +#endif	/* !PNP */
> 
>   MODULE_AUTHOR("David Brownell");
>   MODULE_DESCRIPTION("Driver for PC-style 'CMOS' RTCs");
> 



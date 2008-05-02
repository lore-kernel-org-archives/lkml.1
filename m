Return-Path: <linux-kernel-owner+w=401wt.eu-S1765071AbYEBOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765071AbYEBOiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbYEBOiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:38:14 -0400
Received: from www.tglx.de ([62.245.132.106]:36717 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088AbYEBOiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:38:13 -0400
Date: Fri, 2 May 2008 16:36:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: Fix permissions for available_clocksource
In-Reply-To: <20080502104940.GA4426@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.10.0805021635030.6003@apollo.tec.linutronix.de>
References: <20080502104940.GA4426@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> File permissions for
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> are 600 which allows write access. But this is in fact a read only
> file. So change permissions to 400.

Indeed. The question is whether we should make this 444. There is no
harm, when users can read the info. Same applies for the
current_clocksource entry, making it 644 should be fine.
 
Thanks,
	tglx

> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  kernel/time/clocksource.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/clocksource.c
> +++ linux-2.6/kernel/time/clocksource.c
> @@ -474,7 +474,7 @@ sysfs_show_available_clocksources(struct
>  static SYSDEV_ATTR(current_clocksource, 0600, sysfs_show_current_clocksources,
>  		   sysfs_override_clocksource);
>  
> -static SYSDEV_ATTR(available_clocksource, 0600,
> +static SYSDEV_ATTR(available_clocksource, 0400,
>  		   sysfs_show_available_clocksources, NULL);
>  
>  static struct sysdev_class clocksource_sysclass = {
> 

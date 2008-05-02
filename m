Return-Path: <linux-kernel-owner+w=401wt.eu-S935804AbYEBScQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935804AbYEBScQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763984AbYEBScA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:32:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57697 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763916AbYEBSb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:31:59 -0400
Subject: Re: [PATCH] clocksource: Fix permissions for available_clocksource
From: john stultz <johnstul@us.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080502104940.GA4426@osiris.boeblingen.de.ibm.com>
References: <20080502104940.GA4426@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 11:31:53 -0700
Message-Id: <1209753113.6176.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 12:49 +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> File permissions for
> /sys/devices/system/clocksource/clocksource0/available_clocksource
> are 600 which allows write access. But this is in fact a read only
> file. So change permissions to 400.
> 
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Ah, good catch. 

Acked-by: John Stultz <johnstul@us.ibm.com>


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


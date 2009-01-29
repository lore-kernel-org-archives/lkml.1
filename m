Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZA2NUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZA2NUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbZA2NUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:20:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44617 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZA2NU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:20:29 -0500
Date: Thu, 29 Jan 2009 14:04:35 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Frans Pop <elendil@planet.nl>,
       tj@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Message-ID: <20090129130435.GB1425@ucw.cz>
References: <20081104062734.GA4420@havoc.gtf.org> <49739371.5030107@garzik.org> <200901192053.50831.rjw@sisk.pl> <200901192054.55536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901192054.55536.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-19 20:54:54, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce boolean function system_entering_hibernation() returning
> 'true' during the last phase of hibernation, in which devices are
> being put into low power states and the sleep state (for example,
> ACPI S4) is finally entered.

...this paragraph...

> Index: linux-2.6/kernel/power/disk.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/disk.c
> +++ linux-2.6/kernel/power/disk.c
> @@ -71,6 +71,14 @@ void hibernation_set_ops(struct platform
>  	mutex_unlock(&pm_mutex);
>  }

....should go somewhere here. Because the name does not imply it is
for last phases, only...

> +static bool entering_platform_hibernation;
> +
> +bool system_entering_hibernation(void)
> +{
> +	return entering_platform_hibernation;
> +}
> +EXPORT_SYMBOL(system_entering_hibernation);
> +
>  #ifdef CONFIG_PM_DEBUG
>  static void hibernation_debug_sleep(void)
>  {
> @@ -411,6 +419,7 @@ int hibernation_platform_enter(void)
>  	if (error)
>  		goto Close;
>  
> +	entering_platform_hibernation = true;
>  	suspend_console();

Why entering _platform_ hibernation? It will not be set for echo
shutdown > disk case?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

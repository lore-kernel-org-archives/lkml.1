Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbXK3WP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbXK3WP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXK3WPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:15:16 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4839 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753066AbXK3WPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:15:15 -0500
Date: Fri, 30 Nov 2007 23:15:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/1] HWMON: coretemp, suspend fix
Message-ID: <20071130231512.1111d558@hyperion.delvare>
In-Reply-To: <661416096128474967.slaby@pripojeni.net>
References: <661416096128474967.slaby@pripojeni.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 30 Nov 2007 15:12:46 +0100, Jiri Slaby wrote:
> Ok, I don't see it merged in the latest -mm (mmotm). Could you, Mark, Rafael,
> sign off this version of the patch (Mark's + Rafael's fix)?
> 
> --
> 
> From: Mark M. Hoffman <mhoffman@lightlink.com>
> 
> coretemp, suspend fix
> 
> It's not permitted to unregister device/cpu if frozen and going to sleep.
> It causes deadlock on systems, where coretemp hwmon is loaded. Do it only
> in non-freezed states instead.
> 
> Cc: Rafael J. Wysocki <rjw@sisk.pl> (frozen fix)
> Cc: Mark M. Hoffman <mhoffman@lightlink.com>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
> commit 4f0e19b172ed18fb29e8006c4470fd37aa245a7a
> tree bec1cc4f7a499efe94c5f9d2d208db325914f28e
> parent 877dcc2ef6c7c17a64155cf201886c49622250e9
> author Jiri Slaby <jirislaby@gmail.com> Tue, 27 Nov 2007 20:19:47 +0100
> committer Jiri Slaby <ku@bellona.localdomain> Thu, 29 Nov 2007 23:41:11 +0100
> 
>  drivers/hwmon/coretemp.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 5c82ec7..ce7457d 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -338,11 +338,13 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
>  	switch (action) {
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
> +	case CPU_DOWN_FAILED:
>  		coretemp_device_add(cpu);
> +	case CPU_DOWN_FAILED_FROZEN:
>  		break;
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> +	case CPU_DOWN_PREPARE:
>  		coretemp_device_remove(cpu);
> +	case CPU_DOWN_PREPARE_FROZEN:
>  		break;
>  	}
>  	return NOTIFY_OK;

Should this change go to the stable tree(s) as well?

-- 
Jean Delvare

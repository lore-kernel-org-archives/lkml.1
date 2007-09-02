Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbXIBPmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbXIBPmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbXIBPmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:42:09 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:30172 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbXIBPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:42:08 -0400
Date: Sun, 2 Sep 2007 11:41:52 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Rudolf Marek <r.marek@assembler.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon coretemp: Remove bogus __cpuinitdata etc cleanup
Message-ID: <20070902154152.GC19101@jupiter.solarsys.private>
References: <alpine.LFD.0.999.0708230910120.2049@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708230910120.2049@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam:

* Satyam Sharma <satyam@infradead.org> [2007-08-23 09:14:25 +0530]:
> 
> The CPU hotplug notifier_block coretemp_cpu_notifier is already defined
> inside an #ifdef HOTPLUG_CPU, therefore marking it as __cpuinitdata is
> quite a pointless thing to do.
> 
> Also, remove duplicate prototype of function coretemp_update_device()
> at the top of this file (another one already exists barely 10 lines
> above this one :-)
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>

Applied to hwmon-2.6.git/testing, thanks.

> [ Rudolf, Mark, would it be acceptable to you to remove all the open
>   #ifdef HOTPLUG_CPU from this file and replace them with __cpuinit{data}
>   instead? That could increase size of modular builds, but would remain
>   consistent with rest of kernel, and make the file #ifdef-clean ... ]

I am not automatically repulsed by #ifdefs as some are, and in this case the
usage is pretty clear and easy to read (not to mention useful).

I would prefer to leave it.

>  drivers/hwmon/coretemp.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 7c17952..f7b0ef4 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -58,8 +58,6 @@ struct coretemp_data {
>  	u8 alarm;
>  };
>  
> -static struct coretemp_data *coretemp_update_device(struct device *dev);
> -
>  /*
>   * Sysfs stuff
>   */
> @@ -350,7 +348,7 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
>  	return NOTIFY_OK;
>  }
>  
> -static struct notifier_block __cpuinitdata coretemp_cpu_notifier = {
> +static struct notifier_block coretemp_cpu_notifier = {
>  	.notifier_call = coretemp_cpu_callback,
>  };
>  #endif				/* !CONFIG_HOTPLUG_CPU */

-- 
Mark M. Hoffman
mhoffman@lightlink.com


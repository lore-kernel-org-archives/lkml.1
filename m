Return-Path: <linux-kernel-owner+w=401wt.eu-S2992603AbXCGVQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992603AbXCGVQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992647AbXCGVQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:16:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58485 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992642AbXCGVQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:16:33 -0500
Date: Wed, 7 Mar 2007 13:16:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform
 suspend
Message-Id: <20070307131618.308d46e6.akpm@linux-foundation.org>
In-Reply-To: <200703072044.12021.rjw@sisk.pl>
References: <200703072044.12021.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 20:44:11 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Prevent the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
> from triggering by disabling nonboot CPUs before we finally enter the platform
> suspend.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/disk.c |    1 +
>  kernel/power/user.c |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc2-mm2/kernel/power/disk.c
> ===================================================================
> --- linux-2.6.21-rc2-mm2.orig/kernel/power/disk.c
> +++ linux-2.6.21-rc2-mm2/kernel/power/disk.c
> @@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
>  	switch(mode) {
>  	case PM_DISK_PLATFORM:
>  		if (pm_ops && pm_ops->enter) {
> +			disable_nonboot_cpus();
>  			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
>  			pm_ops->enter(PM_SUSPEND_DISK);
>  			break;
> Index: linux-2.6.21-rc2-mm2/kernel/power/user.c
> ===================================================================
> --- linux-2.6.21-rc2-mm2.orig/kernel/power/user.c
> +++ linux-2.6.21-rc2-mm2/kernel/power/user.c
> @@ -398,9 +398,9 @@ static int snapshot_ioctl(struct inode *
>  
>  		case PMOPS_ENTER:
>  			if (data->platform_suspend) {
> +				disable_nonboot_cpus();
>  				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
>  				error = pm_ops->enter(PM_SUSPEND_DISK);
> -				error = 0;
>  			}
>  			break;

Is this considered 2.6.21 material?  If so why?

Thanks.

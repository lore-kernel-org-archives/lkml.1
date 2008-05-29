Return-Path: <linux-kernel-owner+w=401wt.eu-S1752425AbYE2Fcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbYE2Fcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 01:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750705AbYE2Fcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 01:32:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbYE2Fcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 01:32:32 -0400
Date: Wed, 28 May 2008 22:32:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
Subject: Re: RESEND: [PATCH 2/3] ACPI: Send switch event on dock events
Message-Id: <20080528223225.51cf8298.akpm@linux-foundation.org>
In-Reply-To: <20080528132152.GB32646@srcf.ucam.org>
References: <20080528130621.GA32646@srcf.ucam.org>
	<20080528132152.GB32646@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 14:33:49 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Send a switch event on docking for consistency with docks that don't 
> present as a separate device.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index fa44fb9..a67e74c 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -25,6 +25,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/input.h>
>  #include <linux/types.h>
>  #include <linux/notifier.h>
>  #include <linux/platform_device.h>
> @@ -65,6 +66,7 @@ struct dock_station {
>  	struct mutex hp_lock;
>  	struct list_head dependent_devices;
>  	struct list_head hotplug_devices;
> +	struct input_dev *dock_input;
>  };
>  
>  struct dock_dependent_device {
> @@ -345,10 +347,13 @@ static void dock_event(struct dock_station *ds, u32 event, int num)
>  	char event_string[13];
>  	char *envp[] = { event_string, NULL };
>  
> -	if (num == UNDOCK_EVENT)
> +	if (num == UNDOCK_EVENT) {
> +		input_report_switch(dock_station->dock_input, SW_DOCK, 0);

Is CONFIG_ACPI_DOCK=y, CONFIG_INPUT=n possible?  I think so..

Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbYBTQbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbYBTQbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbYBTQNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:13:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46530 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932302AbYBTQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:13:40 -0500
Date: Wed, 20 Feb 2008 11:13:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] PM: Remove unbalanced mutex_unlock() from dpm_resume()
In-Reply-To: <200802200201.42543.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0802201112010.4828-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008, Rafael J. Wysocki wrote:

> Hi Greg,
> 
> Please consider taking the following fix for 2.6.25.

Don't just consider it!  :-)  It's a real bug fix.

> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove an unnecessary unlocking of dpm_list_mtx in the error path
> in drivers/base/power/main.c:dpm_suspend() .
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -479,7 +479,6 @@ static int dpm_suspend(pm_message_t stat
>  			mutex_lock(&dpm_list_mtx);
>  			if (list_empty(&dev->power.entry))
>  				list_add(&dev->power.entry, &dpm_locked);
> -			mutex_unlock(&dpm_list_mtx);
>  			break;
>  		}
>  		mutex_lock(&dpm_list_mtx);

Acked-by: Alan Stern <stern@rowland.harvard.edu>


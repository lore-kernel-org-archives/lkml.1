Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZHRHFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZHRHFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZHRHFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:05:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:6490 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbZHRHFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,401,1246863600"; 
   d="scan'208";a="439926136"
Subject: Re: [RFC][PATCH 7/7] PM: Asynchronous suspend and resume of i8042
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
In-Reply-To: <200908170221.34885.rjw@sisk.pl>
References: <200908122218.13975.rjw@sisk.pl>
	 <200908170215.21173.rjw@sisk.pl>  <200908170221.34885.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8
Date: Tue, 18 Aug 2009 15:03:30 +0800
Message-Id: <1250579010.5351.69.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 08:21 +0800, Rafael J. Wysocki wrote:
> Set async_suspend for i8042.
> 
it's the psmouse reset that takes the 0.4 seconds during suspend.
﻿so we should call device_enable_async_suspend for the psmouse serio
device in psmouse-base.c

Or invoking device_enable_async_suspend for every serio device in
serio.c, as the keyboard also takes about 0.2s to suspend.

thanks,
rui
> ---
>  drivers/input/serio/i8042.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/input/serio/i8042.c
> ===================================================================
> --- linux-2.6.orig/drivers/input/serio/i8042.c
> +++ linux-2.6/drivers/input/serio/i8042.c
> @@ -1289,6 +1289,8 @@ static int __init i8042_init(void)
>  	if (err)
>  		goto err_free_device;
>  
> +	device_enable_async_suspend(&i8042_platform_device->dev, true);
> +
>  	panic_blink = i8042_panic_blink;
>  
>  	return 0;


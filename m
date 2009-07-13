Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZGMBgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZGMBgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 21:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZGMBgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 21:36:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:47223 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZGMBgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 21:36:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,387,1243839600"; 
   d="scan'208";a="429644519"
Subject: Re: [PATCH 1/2] acpi: don't free non-existant backlight in acpi
	video module
From: Zhang Rui <rui.zhang@intel.com>
To: "keithp@keithp.com" <keithp@keithp.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1247381251-27031-1-git-send-email-keithp@keithp.com>
References: <1247381251-27031-1-git-send-email-keithp@keithp.com>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 09:37:34 +0800
Message-Id: <1247449054.15520.195.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-12 at 14:47 +0800, keithp@keithp.com wrote:
> From: Keith Packard <keithp@keithp.com>
> 
> acpi_video_put_one_device was attempting to remove sysfs entries and
> unregister a backlight device without first checking that said backlight
> device structure had been created.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Acked-by: Zhang Rui <rui.zhang@intel.com>

> ---
>  drivers/acpi/video.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 8851315..60ea984 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -2004,8 +2004,11 @@ static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
>  	status = acpi_remove_notify_handler(device->dev->handle,
>  					    ACPI_DEVICE_NOTIFY,
>  					    acpi_video_device_notify);
> -	sysfs_remove_link(&device->backlight->dev.kobj, "device");
> -	backlight_device_unregister(device->backlight);
> +	if (device->backlight) {
> +		sysfs_remove_link(&device->backlight->dev.kobj, "device");
> +		backlight_device_unregister(device->backlight);
> +		device->backlight = NULL;
> +	}
>  	if (device->cdev) {
>  		sysfs_remove_link(&device->dev->dev.kobj,
>  				  "thermal_cooling");


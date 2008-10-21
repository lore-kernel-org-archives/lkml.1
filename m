Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbYJUIic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbYJUIic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYJUIiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:38:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37725 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYJUIiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:38:23 -0400
Date: Tue, 21 Oct 2008 10:38:22 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Yan Burman <burman.yan@gmail.com>,
       Pau Oliva Fora <pau@eslack.org>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
Message-ID: <20081021083822.GG15782@atrey.karlin.mff.cuni.cz>
References: <48FA3368.1040605@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FA3368.1040605@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Here is a submission for 2.6.28 of a driver for the ST LIS3LV02Dx
> accelerometer, a device found in various laptops (HP in particular) and
> embedded devices. It's the fourth iteration of what used to be called
> MDPS. I've now made the driver very simple, hoping to make it
> unobjectionable for acceptance :-)

Andrew, can you merge this one? It is simple enough, got some testing,
and can't really break anything...

Eric:

> +static int lis3lv02d_add(struct acpi_device *device)
> +{
> +	u8 val;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	adev.device = device;
> +	strcpy(acpi_device_name(device), DRIVER_NAME);
> +	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
> +	acpi_driver_data(device) = &adev;

This one needs to be device->acpi_driver_data = , check -next.

> +/* For the HP MDPS aka 3D Driveguard */
> +static struct acpi_driver lis3lv02d_driver = {
> +	.name  = DRIVER_NAME,
> +	.class = ACPI_MDPS_CLASS,
> +	.ids   = lis3lv02d_device_ids,
> +	.ops = {
> +		.add     = lis3lv02d_add,
> +		.remove  = lis3lv02d_remove,
> +#ifdef CONFIG_PM
> +		.suspend = lis3lv02d_suspend,
> +		.resume  = lis3lv02d_resume
> +#endif
> +	}
> +};

This one is more nicely done by #defining _suspend/_resume to NULL,
IIRC.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

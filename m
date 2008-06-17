Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYFQSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYFQSF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbYFQSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:05:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2325 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755229AbYFQSFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:05:44 -0400
Date: Tue, 17 Jun 2008 17:59:54 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rui.zhang@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean up thermal API
Message-ID: <20080617155954.GB4891@ucw.cz>
References: <20080611100647.GA20013@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611100647.GA20013@srcf.ucam.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-06-11 11:06:47, Matthew Garrett wrote:
> The thermal layer passes temperatures around as strings. This is fine 
> for sysfs, but makes it hard to use them for other purposes in-kernel. 
> Change them to longs and do the string conversion in the sysfs-specific 
> code.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 504385b..28b3782 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -886,7 +886,8 @@ static void acpi_thermal_check(void *data)
>  /* sys I/F for generic thermal sysfs support */
>  #define KELVIN_TO_MILLICELSIUS(t) (t * 100 - 273200)
>  
> -static int thermal_get_temp(struct thermal_zone_device *thermal, char *buf)
> +static int thermal_get_temp(struct thermal_zone_device *thermal, 
> +			    unsigned long *temp)

Hmm, ulong is really wrong:

1) temperature in celsius can easily go below zero.

2) it can hardly go above 2000000C, so int should be enough.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

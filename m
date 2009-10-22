Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbZJVH1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbZJVH1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 03:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZJVH1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 03:27:51 -0400
Received: from poutre.nerim.net ([62.4.16.124]:61938 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbZJVH1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 03:27:50 -0400
Date: Thu, 22 Oct 2009 09:27:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: djwong@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] acpi_power_meter: Don't leak ACPI error
 codes  to userspace
Message-ID: <20091022092753.1b4b9706@hyperion.delvare>
In-Reply-To: <20091022010137.GB21723@tux1.beaverton.ibm.com>
References: <20091022010137.GB21723@tux1.beaverton.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 18:01:37 -0700, Darrick J. Wong wrote:
> acpi-power-meter: Don't leak ACPI error codes to userspace
> 
> If the ACPI methods return an error code, we must return -EINVAL to userspace
> to flag the error.  Right now we pass the (positive) number right through,
> which causes echo to keep writing bogus values.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
> 
>  drivers/acpi/power_meter.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/acpi/power_meter.c b/drivers/acpi/power_meter.c
> index e6bfd77..2ef7030 100644
> --- a/drivers/acpi/power_meter.c
> +++ b/drivers/acpi/power_meter.c
> @@ -294,7 +294,11 @@ static int set_acpi_trip(struct acpi_power_meter_resource *resource)
>  		return -EINVAL;
>  	}
>  
> -	return data;
> +	/* _PTP returns 0 on success, nonzero otherwise */
> +	if (data)
> +		return -EINVAL;
> +
> +	return 0;
>  }
>  
>  static ssize_t set_trip(struct device *dev, struct device_attribute *devattr,

-- 
Jean Delvare

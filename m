Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbZEGArs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbZEGArs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbZEGArd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:47:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:63354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759482AbZEGArb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,305,1239001200"; 
   d="scan'208";a="688153321"
Subject: Re: [PATCH 2.6.30-rc4] thermal: fix off-by-1 error in trip point
	trigger condition
From: Zhang Rui <rui.zhang@intel.com>
To: Vladimir Zajac <eightgraph@gmail.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200905061934.21821.eightgraph@gmail.com>
References: <200905061934.21821.eightgraph@gmail.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 08:48:00 +0800
Message-Id: <1241657280.15284.107.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 01:34 +0800, Vladimir Zajac wrote:
> This patch fixes a regression caused by commit
> b1569e99c795bf83b4ddf41c4f1c42761ab7f75e
> "ACPI: move thermal trip handling to generic thermal layer"
> which accidentally changed trip point trigger condition to
>   temp > trip_temp
> 
> This patch changes the trigger condition back to
>   temp >= trip_temp
> 
> Signed-off-by: Vladimir Zajac <eightgraph@gmail.com>

Acked-by: Zhang Rui <rui.zhang@intel.com>
> ---
> 
>  thermal_sys.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.30-rc4/drivers/thermal/thermal_sys.c	2009-04-30 23:52:59.000000000 +0200
> +++ linux-2.6.30-rc4-p1/drivers/thermal/thermal_sys.c	2009-05-04 19:58:30.000000000 +0200
> @@ -961,7 +961,7 @@ void thermal_zone_device_update(struct t
>  
>  		switch (trip_type) {
>  		case THERMAL_TRIP_CRITICAL:
> -			if (temp > trip_temp) {
> +			if (temp >= trip_temp) {
>  				if (tz->ops->notify)
>  					ret = tz->ops->notify(tz, count,
>  							      trip_type);
> @@ -974,7 +974,7 @@ void thermal_zone_device_update(struct t
>  			}
>  			break;
>  		case THERMAL_TRIP_HOT:
> -			if (temp > trip_temp)
> +			if (temp >= trip_temp)
>  				if (tz->ops->notify)
>  					tz->ops->notify(tz, count, trip_type);
>  			break;
> @@ -986,14 +986,14 @@ void thermal_zone_device_update(struct t
>  
>  				cdev = instance->cdev;
>  
> -				if (temp > trip_temp)
> +				if (temp >= trip_temp)
>  					cdev->ops->set_cur_state(cdev, 1);
>  				else
>  					cdev->ops->set_cur_state(cdev, 0);
>  			}
>  			break;
>  		case THERMAL_TRIP_PASSIVE:
> -			if (temp > trip_temp || tz->passive)
> +			if (temp >= trip_temp || tz->passive)
>  				thermal_zone_device_passive(tz, temp,
>  							    trip_temp, count);
>  			break;


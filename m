Return-Path: <linux-kernel-owner+w=401wt.eu-S1761553AbYBTAZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553AbYBTAZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYBTAYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:24:54 -0500
Received: from qb-out-0506.google.com ([72.14.204.230]:26806 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbYBTAYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:24:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HSdZYVrG4pASWIRpO4uDqlvDDqMgEzW3Yg/ggCMXgrKBWzkxL9kXKAL5C0pyeXxqmWy2gsDhrHgvebH03WxhKJEjGjo6N/ks3gA4uz0BhDarm6EUtxC9Lxsf7uZcZPzBxg4xqm2esU4q+LzUwgBFtsl1oHRbZftiFOfwGGnDT+A=
Subject: Re: [2.6 patch] drivers/thermal/thermal.c: fix a check-after-use
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Thomas Sujith <sujith.thomas@intel.com>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080220001404.GW31955@cs181133002.pp.htv.fi>
References: <20080220001404.GW31955@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 16:25:02 -0800
Message-Id: <1203467102.23194.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-20 at 02:14 +0200, Adrian Bunk wrote:
> This patch fixes a check-after-use spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 570462ca4441d8d63dfd46efe6e5b2b1c251a611 diff --git a/drivers/thermal/thermal.c b/drivers/thermal/thermal.c
> index e782b3e..958654b 100644
> --- a/drivers/thermal/thermal.c
> +++ b/drivers/thermal/thermal.c
> @@ -308,10 +308,10 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  	struct thermal_cooling_device_instance *pos;
>  	int result;
>  
> -	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
> +	if (!tz || !cdev)
>  		return -EINVAL;
>  
> -	if (!tz || !cdev)
> +	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
>  		return -EINVAL;
>  

How about:
	if (!tz || !cdev || trip >= tz->trips ||
	    (trip < 0 && trip != THERMAL_TRIPS_NONE))
		return -EINVAL;

Cheers,

Harvey


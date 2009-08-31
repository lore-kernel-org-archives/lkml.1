Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZHaIUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZHaIUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZHaIUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:20:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:65379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbZHaIUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:20:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,304,1249282800"; 
   d="scan'208";a="444154127"
Subject: Re: [PATCH 2/6] thermal: sysfs-api.txt - document passive
	attribute for thermal zones
From: Zhang Rui <rui.zhang@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas, Sujith" <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1251303445-25317-3-git-send-email-elendil@planet.nl>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl>
	 <1251303445-25317-3-git-send-email-elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 16:18:11 +0800
Message-Id: <1251706691.3483.169.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 00:17 +0800, Frans Pop wrote:
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Sujith Thomas <sujith.thomas@intel.com>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
> index 895337f..2a036eb 100644
> --- a/Documentation/thermal/sysfs-api.txt
> +++ b/Documentation/thermal/sysfs-api.txt
> @@ -3,7 +3,7 @@ Generic Thermal Sysfs driver How To
>  
>  Written by Sujith Thomas <sujith.thomas@intel.com>, Zhang Rui <rui.zhang@intel.com>
>  
> -Updated: 2 January 2008
> +Updated: 21 August 2009
>  
>  Copyright (c)  2008 Intel Corporation
>  
> @@ -199,6 +199,15 @@ cdev[0-*]_trip_point
>  	point.
>  	RO, Optional
>  
> +passive
> +	Attribute is only present for zones which do not have a passive
> +	cooling policy (_PSV) defined in ACPI.

We should not involve any platform specific stuff in this documentation.
how about "Attribute is only present for zones in which the passive
cooling policy is not supported by native thermal driver"

>  Default is zero and can be
> +	set to a temperature (in millidegrees) to enable a passive trip
> +	point for the zone. Activation is done by polling with an interval
> +	of 1 second.
> +	Unit: millidegrees Celsius
> +	RW, Optional
> +
>  *****************************
>  * Cooling device attributes *
>  *****************************
> @@ -230,8 +239,9 @@ thermal_zone_device (thermal_zone1) with 4 trip points in all.
>  It has one processor and one fan, which are both registered as
>  thermal_cooling_device.
>  
> -If the processor is listed in _PSL method, and the fan is listed in _AL0
> -method, the sys I/F structure will be built like this:
> +If the processor is listed in _PSL method, the fan is listed in _AL0
> +method, and the zone has a _PSV method, the sys I/F structure will be
> +built like this:
>  
For an ACPI thermal zone, supporting passive cooling means that both
_PSL and _PSV are available.
so I don't think we need to change this. :)

thanks,
rui
>  /sys/class/thermal:
>  


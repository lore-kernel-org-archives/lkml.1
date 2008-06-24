Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYFXCSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYFXCSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYFXCSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:18:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54419 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYFXCSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:18:00 -0400
Date: Mon, 23 Jun 2008 20:17:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2
 userspace
In-reply-to: <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hans de Goede <j.w.r.degoede@hhs.nl>, Zhang Rui <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org, Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <48605935.5070407@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no>
 <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark M. Hoffman wrote:
> Linus, Rene, et al:
> 
> * Rene Herman <rene.herman@keyaccess.nl> [2008-06-23 17:06:14 +0200]:
>> drivers/thermal/thermal_sys.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
>> index 6098787..c21e03c 100644
>> --- a/drivers/thermal/thermal_sys.c
>> +++ b/drivers/thermal/thermal_sys.c
>> @@ -357,7 +357,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>>
>> 	INIT_LIST_HEAD(&hwmon->tz_list);
>> 	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
>> -	hwmon->device = hwmon_device_register(NULL);
>> +	hwmon->device = hwmon_device_register(&tz->device);
>> 	if (IS_ERR(hwmon->device)) {
>> 		result = PTR_ERR(hwmon->device);
>> 		goto free_mem;
> 
> NACK.
> 
> 1) The bug is in libsensors (2.10), not the kernel.

This doesn't matter. Breaking userspace in such a fashion is severely 
frowned upon unless essentially unavoidable, even if it is just 
triggering a bug.

> 
> - but more importantly -
> 
> 2) This patch is broken.

You didn't indicate what was wrong with the patch.

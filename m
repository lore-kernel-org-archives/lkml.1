Return-Path: <linux-kernel-owner+w=401wt.eu-S1031843AbXHMR0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031843AbXHMR0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032524AbXHMRVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:21:51 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14670 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032473AbXHMRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:21:48 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Message-ID: <46C092EB.1070501@amd.com>
Date: Mon, 13 Aug 2007 19:20:43 +0200
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: "Marcel Holtmann" <marcel@holtmann.org>
cc: linux-kernel@vger.kernel.org, "Jean Delvare" <khali@linux-fr.org>,
       "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Firmware class name collision
References: <46C05896.4050509@amd.com>
 <1187025047.6698.219.camel@violet>
In-Reply-To: <1187025047.6698.219.camel@violet>
X-OriginalArrivalTime: 13 Aug 2007 17:20:42.0346 (UTC)
 FILETIME=[46C1DCA0:01C7DDCE]
X-WSS-ID: 6ADE4C931A44542452-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

Marcel Holtmann wrote:
> Hi Markus,
>
>   
>> following patch fixes the i2c name collision with i2c-dev.
>>
>> http://mcentral.de/wiki/index.php/Bugtracker#i2c_core_problem
>>
>> This issue has been experienced with em28xx and saa7133 based devices.
>> I discussed that problem with Jean Delvare a while ago and he proposed 
>> to add a prefix to the class name.
>>
>> http://mcentral.de/~mrec/patches/firmware_class_name_collision.diff
>>
>> Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
>>
>> index b24efd4..bfc54a1 100644
>> --- a/drivers/base/firmware_class.c
>> +++ b/drivers/base/firmware_class.c
>> @@ -297,8 +297,7 @@ firmware_class_timeout(u_long data)
>>  
>>  static inline void fw_setup_device_id(struct device *f_dev, struct 
>> device *dev)
>>  {
>> -       /* XXX warning we should watch out for name collisions */
>> -       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
>> +       snprintf(f_dev->bus_id, BUS_ID_SIZE, "fw-%s", dev->bus_id);
>>  }
>>     
>
> I would prefer if we use "firmware-%s" since the "fw" might collide with
> the new Firewire stack. Please change that and I agree.
>
>   

firmware-%s sounds more informative and cannot be mistaken with firewire 
yes.

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>

http://mcentral.de/~mrec/patches/firmware_class_name_collision_2.diff

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index b24efd4..bfc54a1 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -297,8 +297,7 @@ firmware_class_timeout(u_long data)

 static inline void fw_setup_device_id(struct device *f_dev, struct 
device *dev)
 {
-       /* XXX warning we should watch out for name collisions */
-       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
+       snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s", dev->bus_id);
 }

 static int fw_register_device(struct device **dev_p, const char *fw_name,

> Acked-by: Marcel Holtmann <marcel@holtmann.org>
>
> Regards
>
> Marcel
>
>
>
>
>   




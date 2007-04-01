Return-Path: <linux-kernel-owner+w=401wt.eu-S1750894AbXDAXT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750894AbXDAXT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 19:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXDAXT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 19:19:27 -0400
Received: from gw.goop.org ([64.81.55.164]:55914 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbXDAXT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 19:19:26 -0400
Message-ID: <46103DF2.30001@goop.org>
Date: Sun, 01 Apr 2007 16:19:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Alexey Starikovskiy <aystarik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
References: <460E0158.7090705@goop.org> <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com> <460F511E.2090102@goop.org>
In-Reply-To: <460F511E.2090102@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Alexey Starikovskiy wrote:
>   
>> Could you try to unload or disable hardware sensors and check if it
>> helps?
>> CONFIG_I2C=m
>> CONFIG_I2C_ALGOBIT=m
>> CONFIG_I2C_ALGOPCA=m
>> CONFIG_I2C_I810=m
>> CONFIG_I2C_PIIX4=m
>> CONFIG_SENSORS_DS1337=m
>> CONFIG_SENSORS_DS1374=m
>> CONFIG_SENSORS_EEPROM=m
>> CONFIG_SENSORS_PCF8574=m
>> CONFIG_SENSORS_PCA9539=m
>> CONFIG_SENSORS_PCF8591=m
>> CONFIG_SENSORS_MAX6875=m
>>     
>
> That seems to have helped.  If I watch
> /proc/acpi/thermal_zone/THM?/temperature, it seems stable even under
> load.   I didn't try watching the thermal_zones when these options were
> enabled, but I presume the temperature was not controlled for it to hit
> 128 degC.

Hm, perhaps I was too optimistic.  I have lm_sensors disabled, and all
i2c options unconfigured in my kernel, but it still has temperature
control problems.  Perhaps the ambient temperature was lower when I
reported success.

When I do a big compile, the temperature reported in
/proc/acpi/thermal_zone/THM0/temperature rapidly approaches 100C, and
when it goes over 100 it triggers the critical shutdown.  When it shuts
down, it (mis-?)reports the temperature as 128C.

This seems to be real, and not a kernel artifact.  If I reboot the same
kernel immediately, it boots up to the message "ACPI: Core revision
20070126" and then hangs.  If I boot Windows immediately afterwards, it
reboots a short way into the boot process.

I've noticed one behavioral change with this kernel.  On the older
kernels, the CPU frequency would sometimes drop to lowest speed,
apparently because of an ACPI thermal limiting event.  This kernel
doesn't seem to drop speed.  I seem to remember Ingo had a patch to
ignore the ACPI thermal limits in cpufreq; did that get merged?

    J

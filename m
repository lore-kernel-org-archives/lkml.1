Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYC1GGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYC1GGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 02:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYC1GF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 02:05:58 -0400
Received: from rtr.ca ([76.10.145.34]:4752 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbYC1GF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 02:05:57 -0400
Message-ID: <47EC8AC3.7080002@rtr.ca>
Date: Fri, 28 Mar 2008 02:05:55 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
References: <20080327160700.GB828@suse.de>	<Pine.LNX.4.64.0803280126550.5541@jikos.suse.cz>	<47EC50A3.5070304@rtr.ca> <20080327.201202.163153963.davem@davemloft.net> <47EC8646.3050405@rtr.ca> <47EC8793.2040508@rtr.ca>
In-Reply-To: <47EC8793.2040508@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>>
>> When I rebuilt with all debug stuff on, the kernel was worse than
>> before, and just gave the "black screen of nothing" on resume,
>> with a hung system.
>>
>> At least before the system didn't hang.
>>
>> Now I've just booted with a differently configured kernel,
>> with only about half of the debug flags turned on.
>> This one resumes from suspend, and *with* working USB too.
>>
>> Ugh. Gotta love it when the bug is so subtle that turning on
>> the debug flags makes it (1) get worse, and/or (2) get cured.
>>
>> Here's the abbreviated diff between broken (no USB on resume, no hang),
>> and working (good USB, no hang) .config files.
> ..
>> -CONFIG_RTC_CLASS=y
>> +# CONFIG_RTC_CLASS is not set
> 
> Mmm.. also had the RTC conflict resolved in that one.
> Time to try another kernel with just the RTC change now.
..

Okay, that might be it.  I've booted and am running without debug flags again.
The difference between "bad" .config and "good" .config was this (below).

Could somebody please fix the RTC mess in kconfig now ?

--- dot_config.nousb	2008-03-27 22:43:50.000000000 -0400
+++ dot_config.best	2008-03-28 01:50:40.000000000 -0400
-# CONFIG_RTC is not set
-CONFIG_GEN_RTC=y
-CONFIG_GEN_RTC_X=y
+CONFIG_RTC=y
+CONFIG_SND_RTCTIMER=m
+CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
-CONFIG_RTC_LIB=y
-CONFIG_RTC_CLASS=y
-
-#
-# Conflicting RTC option has been selected, check GEN_RTC and RTC
-#
-CONFIG_RTC_HCTOSYS=y
-CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
-# CONFIG_RTC_DEBUG is not set
-
-#
-# RTC interfaces
-#
-CONFIG_RTC_INTF_SYSFS=y
-CONFIG_RTC_INTF_PROC=y
-CONFIG_RTC_INTF_DEV=y
-# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
-CONFIG_RTC_DRV_TEST=m
-
-#
-# I2C RTC drivers
-#
-CONFIG_RTC_DRV_DS1307=m
-CONFIG_RTC_DRV_DS1374=m
-CONFIG_RTC_DRV_DS1672=m
-CONFIG_RTC_DRV_MAX6900=m
-CONFIG_RTC_DRV_RS5C372=m
-CONFIG_RTC_DRV_ISL1208=m
-CONFIG_RTC_DRV_X1205=m
-CONFIG_RTC_DRV_PCF8563=m
-CONFIG_RTC_DRV_PCF8583=m
-# CONFIG_RTC_DRV_M41T80 is not set
-# CONFIG_RTC_DRV_S35390A is not set
-
-#
-# SPI RTC drivers
-#
-
-#
-# Platform RTC drivers
-#
-CONFIG_RTC_DRV_CMOS=y
-CONFIG_RTC_DRV_DS1511=m
-CONFIG_RTC_DRV_DS1553=m
-CONFIG_RTC_DRV_DS1742=m
-# CONFIG_RTC_DRV_STK17TA8 is not set
-CONFIG_RTC_DRV_M48T86=m
-# CONFIG_RTC_DRV_M48T59 is not set
-CONFIG_RTC_DRV_V3020=m
-
-#
-# on-CPU RTC drivers
-#
+# CONFIG_RTC_CLASS is not set

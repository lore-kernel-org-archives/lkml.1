Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0BBMQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:16:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:61149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab0BBMQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:16:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=wea+uS9sERh4jKWfC5QxAprAeN8YUraHhqT4OdfwAzwhkbTZMdO4M2gn1L51uBp/je
         hhcavRqQ9/QlpxS+NOcpNJ/svKOYHvUMCGYE2+jvMuCCFYazM6Qu2qdbhc99gFRfkbRd
         WztYVzesQr8pVS/wM8H89H17/F1prEOhyLuxo=
Date: Tue, 2 Feb 2010 15:15:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: Bob Rodgers <Robert_Rodgers@dell.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Michael E Brown <Michael_E_Brown@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>
Subject: Re: [RFC] Dell activity led WMI driver
Message-ID: <20100202121504.GA22188@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Bob Rodgers <Robert_Rodgers@dell.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Michael E Brown <Michael_E_Brown@dell.com>,
	Matt Domsch <Matt_Domsch@dell.com>,
	Mario Limonciello <Mario_Limonciello@dell.com>,
	Louis Davis <Louis_Davis@dell.com>,
	Jim Dailey <Jim_Dailey@dell.com>
References: <4B675954.6000406@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B675954.6000406@dell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 04:44:36PM -0600, Bob Rodgers wrote:
> My team has created a simple driver to control the Activity LED on Dell  
> laptops intended for the Education market. The Activity LED is visible  
> externally in the lid so Teachers can observe it from their desks. This  
> driver works on the shipping Latitude 2100 series platforms as well as  
> others to be released in the future. The driver follows the existing LED  
> class driver API (leds-class.txt), so it will easily allow anybody to  
> write an application to control the LED. Attached is dell_led.c
>
> This has been internally reviewed, and we are ready for outside review  
> and feedback. My colleagues have identified the dell-wmi module as a  
> suitable container in lieu of a stand-alone module specifically for this  
> driver, which makes sense, but we welcome advice. We are submitting it  
> as a stand-alone module for now because that is how we developed and  
> tested it. We would like this to be included upstream after it has been  
> reviewed.
>
> We look forward to your feedback. Thanks in advance.
>
> Regards,
> Bob Rodgers
> Engineering Lead, Dell LED Control Project
> Direct Tel: (512) 725-0665
> Direct FAX: (512) 283-8994
>

> /*
>  * dell_led.c - Dell LED Driver
>  *
>  * Copyright (C) 2010 Dell Inc.
>  * Louis Davis <louis_davis@dell.com>
>  * Jim Dailey <jim_dailey@dell.com>
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as
>  * published by the Free Software Foundation.
>  *
>  */
> 
> #include <linux/platform_device.h>
> #include <linux/acpi.h>
> #include <linux/leds.h>
> 
> MODULE_AUTHOR("Louis Davis/Jim Dailey");
> MODULE_DESCRIPTION("Dell LED Control Driver");
> MODULE_LICENSE("GPL");
> 
> #define DELL_LED_BIOS_GUID "F6E4FE6E-909D-47cb-8BAB-C9F6F2F8D396"
> MODULE_ALIAS("wmi:" DELL_LED_BIOS_GUID);
> 
> // Error Result Codes:
> #define INVALID_DEVICE_ID		250
> #define INVALID_PARAMETER		251
> #define INVALID_BUFFER			252
> #define INTERFACE_ERROR			253
> #define UNSUPPORTED_COMMAND		254
> #define UNSPECIFIED_ERROR		255
> 
> // Devide ID
> #define DEVICE_ID_PANEL_BACK	1
> 
> // LED Commands
> #define CMD_LED_ON		16
> #define CMD_LED_OFF		17
> #define CMD_LED_BLINK	18
> 
> struct bios_args {
> 	unsigned char Length;
> 	unsigned char ResultCode;
> 	unsigned char DeviceId;
> 	unsigned char Command;
> 	unsigned char OnTime;
> 	unsigned char OffTime;
> 	unsigned char Reserved[122];
> };
> 
> static int dell_led_perform_fn(u8 Length, u8 ResultCode, u8 DeviceId, u8 Command, u8 OnTime, u8 OffTime)
> {
> 	struct bios_args bios_return;

It would be better to not put the bios_return struct on the stack.  Make it a 
pointer and use kmalloc().

It's a pity the Makefile bits weren't included.

regards,
dan carpenter


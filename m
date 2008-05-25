Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYEYSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYEYSM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYEYSMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:12:47 -0400
Received: from senator.holtmann.net ([87.106.208.187]:38849 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYEYSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:12:46 -0400
Cc: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>,
       Michael Buesch <mb@bu3sch.de>
Message-Id: <3B90BEFD-148C-47DF-9437-500109907976@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1211722835.17151.24.camel@johannes.berg>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:12:41 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org> <20080523164108.GA31545@uranus.ravnborg.org> <1211640377.540.14.camel@pmac.infradead.org> <20080524152214.GA12582@uranus.ravnborg.org> <1211642706.31212.85.camel@shinybook.infradead.org> <1211643245.31212.88.camel@shinybook.infradead.org> <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org> <1211707837.17151.14.camel@johannes.berg> <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org> <1211716784.17151.19.camel@johannes.berg> <54EDAF0A-907B-46D0-925E-56ADDA37E106@holtmann.org> <1211722835.17151.24.camel@johannes.berg>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

>> Look at the device nodes. The kernel has mouse0 for example and udev
>> will translate this into /dev/input/mouse0. Nobody expects the kernel
>> to use input/mouse0 and actually you even can't do that at all since
>> the device model forbids "/" as bus id. Same applies for the firmware
>> filenames.
>
> No, it doesn't.

please enlighten me how you can use "/" within bus ids.

>> Also at some point we might change the actual implementation of
>> request_firmware() to allow running multiple request_firmware() at  
>> the
>> same time to improve the init time of devices (if that makes sense).
>> In that case the filename would become a kobject and then the
>> directory separator would become illegal.
>
> There's no need to think of it that way. Look at a uevent now:
>
> UEVENT[1211722721.323011] add      /devices/pci0001:10/0001:10:12.0/ 
> ssb0:0/firmware/ssb0:0 (firmware)
> ACTION=add
> DEVPATH=/devices/pci0001:10/0001:10:12.0/ssb0:0/firmware/ssb0:0
> SUBSYSTEM=firmware
> FIRMWARE=b43/b0g0bsinitvals5.fw
> TIMEOUT=60
> SEQNUM=1376
>
>
> The "firmware key" is contained in the FIRMWARE environment  
> variable. If
> you want to allow loading multiple firmwares at the same time, you
> wouldn't have to make the key part of the device name, you would only
> have to add a unique ID to the firmware device name, say

So you actually do know how request_firmware() actually works right  
now? You need to change the firmware_class implementation and API to  
give it an extra parameter to allow any kind if simultaneous loading  
within one driver. Having the FIRMWARE as environment variable is  
actually suboptimal. You want to have the FIRMWARE environment  
variable as bus_id for the firmware struct device object.

Regards

Marcel


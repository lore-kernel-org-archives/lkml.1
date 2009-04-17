Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbZDQRnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbZDQRnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762204AbZDQRna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:43:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762222AbZDQRn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:43:29 -0400
Message-ID: <49E8BFBC.8010006@vlnb.net>
Date: Fri, 17 Apr 2009 21:43:24 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and implementation.
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com> <49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com> <ac3eb2510904170724l654b00b4k79156138f9fd926d@mail.gmail.com> <49E8A551.7050307@linux.vnet.ibm.com>
In-Reply-To: <49E8A551.7050307@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19YJgwu8SHfU2VwBnNYu4TkPykq1Ea9VBjHgiP
 ME0mdyjFWetFZhUojU+yvFR/4RCS+VljHqD3Tw7AytfrprTVKB
 LYIyv+0apw2ewLKqOVzsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Debonzi, on 04/17/2009 07:50 PM wrote:
> Hi Kay,
> 
> Thanks for the inputs.
> 
> Do you mean that uses struct device is the right way to do it instead of 
> kobjects or it is just a option to get things on right places into sysfs?
> 
> I don't know this struct closely but my first impression looking to the 
> source code is that it is tied with hardware and has some complexity we 
> probably don't need. What do you think?

I agree, looks like using struct device instead of struct kobject should 
additionally complicate the code a lot for not clear gain.

> Regards,
> Daniel Debonzi
> 
> 
> Kay Sievers wrote:
>> On Fri, Apr 17, 2009 at 15:25, Daniel Debonzi
>> <debonzi@linux.vnet.ibm.com> wrote:
>>> Vladislav Bolkhovitin wrote:
>>>>> Based on all I read this last days, I believe we are not allowed to
>>>>> include the directory scsi_tgt on /sys root. I think it has to be in a
>>>>> existent directory reserved for this sort of application. I just didn't
>>>>> figured out which one it would be.
>> Right, there will be no new out-of-/sys/devices/ top-level device dir,
>> unless you convince everybody to have a scsifs, which would be in
>> /sys/kernel/scsi/, and which would not use the driver core device
>> stuff at all. :)
>>
>>>> /sys/class? It already has scsi_device, scsi_disk, scsi_generic and
>>>> scsi_host.
>> If it's a bus or a class, it does not matter. What you need to include
>> is a "struct device" (and not a kobject) if you want them to show up
>> in the common directories.
>>
>>> I don't think so because all the directories on /sys/class have symlinks to
>>> the files somewhere else. However I noticed that many of them on my system
>>> are on /sys/device/virtual
>> All "struct device" devices appear in /sys/devices/, that's the single
>> place the hierarchy is expressed. The classification, meaning the
>> "collection of devices of the same subsystem" happens in /sys/bus/
>> /sys/class/, therefore they are only flat lists of links. Virtual are
>> devices which have no parent assigned. The driver core prepends
>> virtual to them, when they are registered.
>>
>> Kay
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


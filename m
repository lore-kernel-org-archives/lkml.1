Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbZDQPvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbZDQPvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZDQPuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:50:50 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:42665 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZDQPut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:50:49 -0400
Message-ID: <49E8A551.7050307@linux.vnet.ibm.com>
Date: Fri, 17 Apr 2009 12:50:41 -0300
From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Scst-devel] Discussion about SCST sysfs layout and implementation.
References: <49E7307A.8000205@vlnb.net> <49E77795.7080204@linux.vnet.ibm.com> <49E85F1C.7040106@vlnb.net> <49E8832F.6070302@linux.vnet.ibm.com> <ac3eb2510904170724l654b00b4k79156138f9fd926d@mail.gmail.com>
In-Reply-To: <ac3eb2510904170724l654b00b4k79156138f9fd926d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

Thanks for the inputs.

Do you mean that uses struct device is the right way to do it instead of 
kobjects or it is just a option to get things on right places into sysfs?

I don't know this struct closely but my first impression looking to the 
source code is that it is tied with hardware and has some complexity we 
probably don't need. What do you think?

Regards,
Daniel Debonzi


Kay Sievers wrote:
> On Fri, Apr 17, 2009 at 15:25, Daniel Debonzi
> <debonzi@linux.vnet.ibm.com> wrote:
>> Vladislav Bolkhovitin wrote:
> 
>>>> Based on all I read this last days, I believe we are not allowed to
>>>> include the directory scsi_tgt on /sys root. I think it has to be in a
>>>> existent directory reserved for this sort of application. I just didn't
>>>> figured out which one it would be.
> 
> Right, there will be no new out-of-/sys/devices/ top-level device dir,
> unless you convince everybody to have a scsifs, which would be in
> /sys/kernel/scsi/, and which would not use the driver core device
> stuff at all. :)
> 
>>> /sys/class? It already has scsi_device, scsi_disk, scsi_generic and
>>> scsi_host.
> 
> If it's a bus or a class, it does not matter. What you need to include
> is a "struct device" (and not a kobject) if you want them to show up
> in the common directories.
> 
>> I don't think so because all the directories on /sys/class have symlinks to
>> the files somewhere else. However I noticed that many of them on my system
>> are on /sys/device/virtual
> 
> All "struct device" devices appear in /sys/devices/, that's the single
> place the hierarchy is expressed. The classification, meaning the
> "collection of devices of the same subsystem" happens in /sys/bus/
> /sys/class/, therefore they are only flat lists of links. Virtual are
> devices which have no parent assigned. The driver core prepends
> virtual to them, when they are registered.
> 
> Kay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbXK0RGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbXK0RGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbXK0RGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:06:23 -0500
Received: from www17.your-server.de ([213.133.104.17]:51753 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbXK0RGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:06:22 -0500
Message-ID: <474C4E7A.8050609@m3y3r.de>
Date: Tue, 27 Nov 2007 18:06:02 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071118)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dm-devel@redhat.com, Greg KH <greg@kroah.com>
Subject: Re: Device mapper regression 2.6.23 vs. v2.6.23-6597-gcfa76f0
References: <471BA729.6050206@m3y3r.de>	 <20071029001832.05c0a372.akpm@linux-foundation.org>	 <1193659166.2773.12.camel@lov.site>  <472B5855.8080303@m3y3r.de> <1194023520.8053.5.camel@lov.site>
In-Reply-To: <1194023520.8053.5.camel@lov.site>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers schrieb:
> On Fri, 2007-11-02 at 18:03 +0100, Thomas Meyer wrote:
>   
>> Kay Sievers schrieb:
>>     
>>> On Mon, 2007-10-29 at 00:18 -0700, Andrew Morton wrote:
>>>   
>>>       
>>>> On Sun, 21 Oct 2007 21:23:21 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:
>>>>     
>>>>         
>>>>> I have an external hard drive with an encrypted partition. I am using
>>>>> kde so all i had to do under 2.6.23 was
>>>>>   "cryptsetup luksOpen /dev/sdb2 crypt-extern"
>>>>>
>>>>> then udev/hal/kde (?)automatically created an desktop icon. i could
>>>>> click this icon to mount and open the drive.
>>>>>
>>>>> when i do the luksOpen command with v2.6.23-6597-gcfa76f0 this icon is
>>>>> not created anymore.
>>>>>
>>>>> a few commits were made in drivers/md, so it seems something broke.
>>>>>
>>>>> config extract:
>>>>>
>>>>> CONFIG_MD=y
>>>>> # CONFIG_BLK_DEV_MD is not set
>>>>> CONFIG_BLK_DEV_DM=y
>>>>> # CONFIG_DM_DEBUG is not set
>>>>> CONFIG_DM_CRYPT=y
>>>>> CONFIG_DM_SNAPSHOT=m
>>>>> CONFIG_DM_MIRROR=m
>>>>> CONFIG_DM_ZERO=m
>>>>> # CONFIG_DM_MULTIPATH is not set
>>>>> CONFIG_DM_DELAY=m
>>>>> CONFIG_DM_UEVENT=y
>>>>> # CONFIG_FUSION is not set
>>>>>
>>>>> any ideas?
>>>>>
>>>>>       
>>>>>           
>>>> Could be DM breakage, could be udev/sysfs breakage.  Is it still happening
>>>> in current mainline?
>>>>     
>>>>         
>>> There are no obvious changes, which I would expect to cause a breakage
>>> in this area. 
>>>
>>>       
>>>> And how come I'm seeing unresponded-to-for-a-week regression
>>>> reports on lkml?
>>>>     
>>>>         
>>> It works fine with 2.6.24-rc1+ and GNOME, even without any initial shell
>>> command to set it up. Just inserting a LUKS volume, brings up a password
>>> dialog, and then mounts all automatically.
>>>
>>> There was a timing problem fix in HAL (in 0.5.10), maybe that is what
>>> happens here.
>>>   
>>>       
>> Hal version is 0.5.9.1-r2.
>>
>> to make things clear:
>> boot 2.6.23 doing "cryptsetup luksOpen /dev/sdb2 crypt-extern" -> kde
>> asks to mount new device
>> boot v2.6.24-rc1-497-gb1d08ac doing "cryptsetup luksOpen /dev/sdb2
>> crypt-extern" -> nothing happens in kde.
>>
>> same user land, different kernel.
>>     
>
> Yeah, but I expect it to be a timing problem, which may show up with a
> new kernel. The kernel is maybe just that bit faster in the event
> generation, that it triggers a silly HAL bug. You probably need:
>   http://gitweb.freedesktop.org/?p=hal.git;a=commit;h=f3e160d0ab85f62b76400cb521b4d1b5813d0711
>
> It's all fine here regarding LUKS volumes, therefore I wouldn't know
> what would be wrong at the kernel side.
>
>   
Yes. With hal-0.5.10 (which includes above commit) the new kernel
behaves like 2.6.23 again.

mfg
thomas


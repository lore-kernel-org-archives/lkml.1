Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZIHVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZIHVjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 17:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZIHVjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 17:39:35 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:42578 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZIHVje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 17:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OWFAxWyFSY7/v4qRf31sVGcB6VVjNEAxdflTHcx50hg9CDiZcirQF2lPXrl72XA7fy
         bmA8CFmQibFUmRoZMKXTQ8T5zN0M7987B+iyxDt9U7IYqN02sQYATa3fWgLrSaB3rmLr
         iNQ3EiVZGlz2qvh85LMP+YYegaBfjRvlohCxI=
MIME-Version: 1.0
In-Reply-To: <20090806200127.GD29827@kroah.com>
References: <71cd59b00908041140j7bd814d2u90585864fe00415e@mail.gmail.com>
	 <20090804203549.GA25332@kroah.com>
	 <71cd59b00908050054q49dabbe4vc8f53eddb4b4d33d@mail.gmail.com>
	 <20090806200127.GD29827@kroah.com>
Date: Tue, 8 Sep 2009 23:39:35 +0200
Message-ID: <71cd59b00909081439x56e6f789hbb92a3f058198a9e@mail.gmail.com>
Subject: Re: Cleaning asus_oled
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Jakub Schmidtke <sjakub@gmail.com>, acpi4asus-user@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 10:01 PM, Greg KH<greg@kroah.com> wrote:
> On Wed, Aug 05, 2009 at 09:54:47AM +0200, Corentin Chary wrote:
>> On Tue, Aug 4, 2009 at 10:35 PM, Greg KH<greg@kroah.com> wrote:
>> > On Tue, Aug 04, 2009 at 08:40:10PM +0200, Corentin Chary wrote:
>> >> Hi,
>> >> I'm trying to clean the asus_oled driver, here is my git tree with
>> >> some trivial patchs.
>> >> http://git.iksaif.net/?p=acpi4asus.git;a=shortlog;h=refs/heads/asus_oled
>> >
>> > That's great!  But note, I need patches in email form, so you are going
>> > to use git format-patch to dig them out for me, right?  :)
>>
>> Yes, of course.
>>
>> >> Before working deeper, I wanted to discuss about the userspace interface:
>> >>
>> >> > TODO:
>> >> > [...]
>> >> >        - audit the userspace interface
>> >> >                - sysfs vs. char?
>> >>
>> >> First, should we move asus_oled functionalities in asus-laptop ?
>> >> Then the interface would be in sysfs under
>> >> /sys/devices/platform/asus-laptop/{picture|enable} ?
>> >
>> > Is that the way that other drivers of this kind of functionality work
>> > today?  If so, yes, that would be good.
>>
>> Hum, actually I think it is not a good idea. It is just an USB device, and
>> Asus may wan't to use it on motherboard on day. We should keep it
>> a simple usb driver.
>>
>> >> Else we can use /dev/asus_oled, with an ioctl (or a zero-size image)
>> >> to switch the OLED off.
>> >> But I don't think /sys/class/oled is a good place to be, because
>> >> /sys/class is for generic things.
>> >
>> > Like /sys/class/video_output?  There's got to be some other generic
>> > backlight driver class already, oh, hey, look at /sys/class/backlight!
>> >
>> > So, why not just use the backlight interface instead, that way you don't
>> > have to write custom userspace code for this specific platform?
>>
>> backlight interface is only to change screen brightness, so we can't
>> use that for an oled screen. There is an lcd class too, but it is used
>> for contrast.
>>
>> After some grepping in the kernel, it seems that there is no generic
>> lcd interface.
>> For example :
>> - drivers/parisc/led.c use a /proc/pdc/lcd file
>> - drivers/ans-lcd.c  use a /dev/anslcd file
>>
>> If you look at http://ssl.bulix.org/projects/lcd4linux/browser/trunk
>>
>> You'll see a lot of drv_***.c files, and each of them are for a
>> different kernel interface
>> (although some of them might don't use any interface).
>>
>> It seems that http://lcd-linux.sourceforge.net/ try to implement a
>> generic interface,
>> but only for alphanumeric displays, and it is not in mainline.
>
> But we could add it, right?  Care to ask those developers if we can do
> that?
>
>> This also could be a classic frambuffer device, but I don't think it's
>> the best way to go for this type of device.
>>
>> Time to write a generic oled/lcd pannel class ?
>
> Probably :)
>
> have fun,
>
> greg k-h
>

Hi,
I've seen your thread about the staging tree status.
I'm currently trying to get the hardware to work on asus_oled.
If I can get it, I'll maintain this driver as a part of the acpi4asus project.
Else, we will need to find another maintainer =).

Thanks,

-- 
Corentin Chary
http://xf.iksaif.net

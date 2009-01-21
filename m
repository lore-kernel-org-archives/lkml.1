Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZAURww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZAURww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZAURwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:52:40 -0500
Received: from timbuctoo.liddicott.com ([206.123.89.57]:51943 "EHLO
	timbuctoo.liddicott.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZAURwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:52:39 -0500
X-Greylist: delayed 1858 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 12:52:39 EST
To: Greg KH <greg@kroah.com>
Date: Wed, 21 Jan 2009 17:20:45 -0000
Subject: Re: "permanently" unbind a device from a driver?
Envelope-To: greg@kroah.com,tom.leiming@gmail.com,mjt@tls.msk.ru,linux-kernel@vger.kernel.org,linux-usb@vger.kernel.org
References: <497638FF.8050805@msgid.tls.msk.ru> <20090120210254.GA5609@kroah.com> <d82e647a0901210744t1655bacesf23bcd54e30002e9@mail.gmail.com> <20090121162345.GB22615@kroah.com>
CC: Ming Lei <tom.leiming@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux USB list <linux-usb@vger.kernel.org>
Message-ID: <4977596D.409@liddicott.com>
From: "Sam Liddicott" <sam@liddicott.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH wrote, On 21/01/09 16:23:
> On Wed, Jan 21, 2009 at 11:44:03PM +0800, Ming Lei wrote:
>   
>> 2009/1/21 Greg KH <greg@kroah.com>:
>>     
>>> Just add a blacklist rule to the usbhid driver for this device.  There
>>> are a number of devices out there that need this functionality, which is
>>> why there is such a list.
>>>       
>> Is it possible to implement a generic blacklist mechanism in driver core
>> to support the function for all kinds of drivers? or is it necessary to do that?
>>     
>
> It's not necessary as the hid core already supports this very thing due
> to the need for it (it's the easiest way to write a userspace Windows
> driver, so lots of manufacturers lie about their devices in order to
> work around having to write a Windows kernel driver.)
>
> So just add this device to the hid core blacklist, and you are all set.
>
> Care to send a patch?
>   

I've often felt that a /proc or /sys interface to allow blacklist
additions or quirk addition would be great.

Hacking of new devices often runs faster than distro's kernel releases;
it will often be very simple to distribute a 1 liner to make some
hardware available than tell people to wait until the next major release
of their distro.

As a point in instance, a couple of years ago I gave up trying to get
some quirks added for usb dual and quad joystick adaptors. I got them
added for one of them but not the other. It was just too much hard work.

I will say for the record that you, Greg, were very helpful, but all
told it was a couple of hours to build and test each quirk patch (I
didn't get the controllers at the same time), and then knowing that I
would either have to maintain my own out-of-distro kernel or wait about
18 months for my distro to get the patch - meant that the work was not
solving any immediate problem; so the pay-off in relation to the
scarcity of my time meant it just got forgotten.

An user-space post-boot uploadable quirk/blacklist would be great and
IMHO result in a bigger supply of quirks.

Sam

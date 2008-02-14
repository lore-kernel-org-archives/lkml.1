Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbYBNVck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbYBNVck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYBNVc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:32:28 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:44547 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYBNVc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:32:27 -0500
Date: Thu, 14 Feb 2008 16:32:18 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Handshaking on USB serial devices
In-reply-to: <20080214205224.GC17277@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802141632.18548.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <47B30291.2040905@davidnewall.com>
 <200802141504.41991.gene.heskett@gmail.com> <20080214205224.GC17277@kroah.com>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Greg KH wrote:
>On Thu, Feb 14, 2008 at 03:04:41PM -0500, Gene Heskett wrote:
>> On Thursday 14 February 2008, Alan Cox wrote:
>> >> byte of a packet is being thrown away about .1% of the time for the
>> >> pl2303, but I'm not sure if the FTDI driver still suffers from a
>> >> similar rash.  I
>> >
>> >A 20 byte low speed message is too small for flow control to account for
>> >it.
>>
>> Where then could the first byte go?  Note I'm not fussing about flow
>> controls per sei, so the subject line maybe needs to be adjusted, but they
>> obviously work well enough that a multimegabyte transfer to my printer
>> works very well, but about usb trying to entirely replace serial here. 
>> There does seem to be a problem but I'm not 100% positive where it is in
>> the chain of a usb packets travels.  What I've observed, with hidraw I
>> think it was, is that the first 'wake up' byte incoming didn't seem to be
>> there.
>
>I have not seen this kind of error in years, why have you not reported
>it?
I did make some noise, probably over a year ago now, but I guess it fell 
through the cracks or no one else could duplicate it.  And my expiry on this 
list means any and all such messages have been expired for several months.

>Can you enable debugging in the pl2303 driver with a simple:
>	modprobe pl2303 debug=1
>or when the driver is running with:
>	echo 1 > /sys/module/pl2303/parameters/debug
>
>That way you can see the data flowing through the device.  If the host
>sends it to the device, perhaps your device is just dropping it somehow?
>
>These pl2303 devices are really cheap, there are lots of different
>variations of them, and none of them are documented at all.  We might be
>missing some kind of interaction here, but in my tests, I have not had
>any lost data.

I have two, both very early models sold by Radio Shack but they have been 
hanging on the pegs except for when I take roadnav with me on a long trip.

>Are you sure your userspace program isn't constantly setting the line
>settings?  We have seen instances where the device does get confused and
>resets itself if that happens a lot.  That was just fixed in the last
>kernel release.

Maybe that is what I was seeing?  ATM runing on 2.6.24 final. Just for grins I 
fired up a 'cat /dev/hideaw0 | hexdump -v' and I'm seeing traffic, mostly 
from the motion sensor, but because hexdump makes a 16 byte line out of one 
byte, and may display that byte anyplace in that 16 byte buffer, I can't tell 
what is right and what is wrong even though I am familiar with the x10 
protocol.  Do we have another such tool that will output only those bytes 
actually received as they come in?  Something that prints the hex value of 
the byte, and then issues a newline to the screen?  Or some way to ship the 
$00's to /dev/null so hexdump ignores them?

>thanks,
>
>greg k-h



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"But I don't like Spam!!!!"

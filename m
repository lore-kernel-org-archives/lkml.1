Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZKAVSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZKAVSi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZKAVSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:18:37 -0500
Received: from lucidpixels.com ([75.144.35.66]:36829 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbZKAVSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:18:36 -0500
Date: Sun, 1 Nov 2009 16:18:40 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, nut-upsuser@lists.alioth.debian.org,
       bruce.w.allan@intel.com, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?]
 [tested 3 different UPS']
In-Reply-To: <20091101175216.GA24436@one-eyed-alien.net>
Message-ID: <alpine.DEB.2.00.0911011613270.2767@p34.internal.lan>
References: <alpine.DEB.2.00.0910311847530.5522@p34.internal.lan> <Pine.LNX.4.44L0.0911011151270.399-100000@netrider.rowland.org> <20091101175216.GA24436@one-eyed-alien.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Nov 2009, Matthew Dharm wrote:

> On Sun, Nov 01, 2009 at 12:11:44PM -0500, Alan Stern wrote:
>> On Sat, 31 Oct 2009, Justin Piszcz wrote:
>>
>>> 1. 5 minutes of usbmon output on via chipset [working]
>>> 2. 5 minutes of usbmon output on intel p55 usb chipset [ehci/not working]
>>
>> To summarize the differences between the logs, the Intel controller
>> shows occasional instances of failed transfers like this:
>>
>> ffff8802138c8500 3487005687 S Ci:2:004:0 s 81 06 2100 0000 0009 9 <
>> ffff8802138c8500 3487006051 C Ci:2:004:0 -32 0
>>
>> while the corresponding transfers worked with the VIA controller:
>>
>> ffff88020c46dd40 1774844264 S Ci:4:002:0 s 81 06 2100 0000 0009 9 <
>> ffff88020c46dd40 1774855248 C Ci:4:002:0 0 9 = 09211001 21012237 04
>>
>> and indeed they worked in the other Intel logs (the failures appeared
>> to be more or less at random).
>>
>> This does indeed look like a low-level hardware problem, but I'm
>> hesitant to blame it on the chipset.  For example, the problem might
>> lie in the hub you've got between the UPS and the computer.  I know,
>> this doesn't explain why everything works okay with the VIA controller.
>> Probably the only way to tell for sure what's really happening is by
>> using an expensive bus analyzer.
>>
>> Have you tried bypassing that hub, and plugging the UPS directly into
>> the computer?

Hi,

I do not use any hubs in this environment, everything is directly 
attached to the motheboard.  Per Matthew (noted below) when I
mention hub I am talking about your typical USB hub one would
attach to a USB port on the board, not the integrated one on the
motherboard.  Everything is directly attached from the motherboard
to each respective device.

MOBO -> UPS
MOBO -> KBD
MOBO -> etc


>
> I think P55 chipset has an integrated hub, which is not removeable.  The
> only USB controller is EHCI, and that is connected directly to a hub in the
> silicon which provides multiple downstream ports and does the translation
> to 1.0 speeds.  So the hub cannot be bypassed.
>
> Two things to note:
>
> 1) Not all ports on that silicon are the same.  Specifically, ports 1 and 9
> have special properties (related to USB-based debugging).  You should try
> other ports (note that I count ports starting at 0).
I have tested every port on the motherboard (the 8 on the back and 4 off
of the USB headers on the motherboard):
http://home.comcast.net/~jpiszcz/20091101/ports.txt

The problem occurred on every port.

>
> 2) I noticed this article:
> http://www.theregister.co.uk/2009/10/30/iphone_p55_problems/ -- this may
> suggest that there are other issues with P55 chipset and USB.  According to
> this article, as with this reported issue, adding an external USB hub
> doesn't help, but an add-in PCI USB card does.  We may have to consider a
> P55 issue as a possibility here.
Very interesting-- the C-state option for the CPU is on/enabled in the
BIOS, it has always remained on, I never disabled it.

Justin.


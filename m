Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbYBNQQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbYBNQQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYBNQQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:16:44 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:50178 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYBNQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:16:43 -0500
Date: Thu, 14 Feb 2008 11:16:14 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Handshaking on USB serial devices
In-reply-to: <20080214121026.16a9c510@core>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Newall <davidn@davidnewall.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802141116.14722.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <47B30291.2040905@davidnewall.com> <47B40918.20206@davidnewall.com>
 <20080214121026.16a9c510@core>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Alan Cox wrote:
>> To make it clear: Even aside from the buffer in 2.6's pl2303.c, there's
>> a race: An in-flight write URB can fill all hardware buffers, making
>> unsafe what previously appeared to be a safe write.  I think it's
>> essential to delay submission of the URB on a stop-transmit condition.
>
>Hardware flow control *is* a race, and always will be. The remote end has
>a delay in signalling 'stop' there is a propogation delay and a response
>delay. This is why most implementations assert stop a bit *before* they
>run out.
>
>Given the size of transfers and the internal buffering one would hope the
>USB devices do their own flow control if told to properly.
>
>Alan

Apparently they do not Alan, the pl2303 in particular is a problem child, 
throwing several lost com errors a day when doing nothing more strenuous than 
talking to my belkin UPS from apcupsd, very small packets there, 20 bytes I 
believe at several second intervals.  I can cut those messages to about 
weekly by using an FDTI adaptor in its place, or I can stop them entirely if 
a pure rs232 connection is used.  Unforch, pure rs232 is going the way of the 
dodo bird, and the adapters in general fail such applications badly.  I want 
to build a new machine, but the first thing I'd have to get after a new video 
card is a serial card.  And there goes a slot I'll need for something else.  
My current home automation via heyu, the ups, and the Garmin GPS all require 
serial ports.

Another linux app, a route navigator program that uses the output of a GPS to 
display where you are, also has errors several times an hour when using a 
pl2303 to connect a low baud rate Garmin 12 with no flow control to it.  I 
just recently used it for a 3000 mile nearly month long trip.

So IMO, neither of the 2 readily available devices for usb-serial use is quite 
ready for mission critical usage.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
No extensible language will be universal.
		-- T. Cheatham

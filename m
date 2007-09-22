Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbXIVO3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbXIVO3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 10:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXIVO3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 10:29:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2083 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752360AbXIVO3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 10:29:40 -0400
Date: Sat, 22 Sep 2007 10:29:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] USB autosuspend and turning of usb pendrive
 leds
In-Reply-To: <46F52012.5050902@hhs.nl>
Message-ID: <Pine.LNX.4.44L0.0709221020080.22762-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007, Hans de Goede wrote:

> I'm afraid that that doesn't work for usb mass-storage devices.
> 
> Here is what I did:
> 1) kill hal
> 2) insert usb stick -> led lights
> 3):
> echo -n 1 >    /sys/bus/usb/devices/.../power/autosuspend
> echo -n auto > /sys/bus/usb/devices/.../power/level
> 
> 4) wait
> 
> Nothing happens, where as sending "suspend" to power/level does turn the led 
> off.

I don't know what went wrong.  It works fine on my systems.  You did 
fill in the correct device path for the "...", right?  And you don't 
need the "-n" -- adding it shouldn't matter, but you should try reading 
back the contents of those files to make sure the values did get 
written correctly.

> Now call me naive, but I would expect a mass-storage devices with no 
> partitions mounted to autosuspend when autosuspend is enabled for that device.

Yes, that is naive.  The driver has no way to tell whether or not any 
partitions are mounted.  Furthermore, you might very well want to 
access the raw device without mounting any partitions (database 
managers frequently do such things to reduce I/O overhead), in which 
case you certainly would not the device to be autosuspended.

> And yes I'm pretty sure nothing else is talking to the device.

You can be absolutely certain by using usbmon (see 
Documentation/usb/usbmon.txt).  It will also show whether any suspends 
or resumes are actually being sent.

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbZATROA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbZATROA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151AbZATRNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:13:49 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40890 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbZATRNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:13:48 -0500
Message-ID: <49760649.8000800@s5r6.in-berlin.de>
Date: Tue, 20 Jan 2009 18:13:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Ionut Leonte <ionut.leonte@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 changes in-kernel name for UVC device ?
References: <200901201349.33707.ionut.leonte@gmail.com> <ac3eb2510901200507p4b107af6ud87a634af6679223@mail.gmail.com>
In-Reply-To: <ac3eb2510901200507p4b107af6ud87a634af6679223@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Tue, Jan 20, 2009 at 12:49, Ionut Leonte <ionut.leonte@gmail.com> wrote:
>> I have a Dell laptop with an integrated webcam which works with the 'uvcvideo'
>> module. For kernel versions 2.6.27 and below the following udev rule:
>>
>>   KERNEL=="video[0-9]*",  NAME="v4l/video%n", SYMLINK+="%k", GROUP="video"
>>
>> would create '/dev/video0' as a link to '/dev/v4l/video0'. When switching to
>> 2.6.28 the rule creates '/dev/video1394-0' instead. Obviously most user-space
>> apps were quite surprised by this (as was I).
>>
>> Is this change intended or is it the accidental result of some modification ?
> 
> These rules are broken, and match also on firewire devices and not
> only video4linux devices.
> 
> Such rules are not part of the standard udev setup and need to be
> fixed to work as intended. There is no change or fault at the kernel
> side.

Exactly.

> You may just disable the firefire drivers if you don't need them.

It is not even necessary to disable the drivers; it would be sufficient
to not force-load the video1394 module.  (Or to fix the udev rule.)
Presence of a Firewire card does not cause video1394 to be auto-loaded;
only certain types of FireWire cameras cause respective uevents and thus
autoloading of the special-purpose driver video1394.  Ergo, Ionut's
userland has a configuration somewhere which loads video1394 explicitly.

> Btw, swapping default kernel names to devfs names and create symlinks
> for the kernel names is not recommended at all.
> 
> Kay

-- 
Stefan Richter
-=====-==--= ---= =-=--
http://arcgraph.de/sr/

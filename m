Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYAGPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYAGPrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYAGPrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:47:10 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20521 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYAGPrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:47:09 -0500
Message-ID: <4782497B.2050306@msgid.tls.msk.ru>
Date: Mon, 07 Jan 2008 18:47:07 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: acpi/apm events as inputs: how to handle?
References: <477B5FD8.5070503@msgid.tls.msk.ru>	 <200801052105.03068.dtor@insightbb.com>	 <47820224.2020902@msgid.tls.msk.ru>	 <20080107130332.5973A2D6BF@smtp02.mtu.ru> <d120d5000801070620i1505e697jf73fa001a9c884db@mail.gmail.com> <47823C28.8010800@msgid.tls.msk.ru>
In-Reply-To: <47823C28.8010800@msgid.tls.msk.ru>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Dmitry Torokhov wrote:
> []
>>> Well, you use event device in any case; as for finding right one - I guess
>>> you look at device capabilities and filter what you need ...
>>>
>>> {pts/0}%
>>> cat /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/capabilities/key
>>> 100000 0 0 0
>> Exactly. Any driver working through evdev interface should examine
>> device's capabilities and decide whether it is interested in the
>> device or not.
> 
> Ok, got it.
> But I can't open the device multiple times, can I?
> Like, there's a daemon listening on volume up/down and other
> multimedia keys for example, and it can't listen to the same
> eventX as a daemon that's watching for power/sleep buttons, --
> instead, they should be combined into the same executable.
> Unless there's a way to multiplex the events...
> (Hmm, this becoming quite... ugly.  Oh well.)

Are the capabilities available over ioctl?  Because if not, it
really is a problem to find correct /sys file for a given /dev
node.  I'd rather not scan whole /sys to find the right device... ;)

> By the way, where are all the capabilities of input devices
> documented?

Looked at the code, but it's a bit... difficult to follow, so
to say.  What is in ../capabilities/keys, for example - is it
a bitmap of all keys the given event device can produce, based
on KEY_xxx constants from <linux/input.h> ?

/mjt

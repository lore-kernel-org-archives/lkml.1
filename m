Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZICOfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZICOfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZICOfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:35:55 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:61890 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZICOfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:35:54 -0400
Message-ID: <3e931de28d0091635547160680e17e5b.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <738fcf0e7c98ac7f03a8c32a1a462bdc.squirrel@intranet.cs.nmsu.edu>
References: <a571ebde1bc221dd250a03e9fb33ed66.squirrel@intranet.cs.nmsu.edu>
    <20090903005051.GA6733@kroah.com>
    <738fcf0e7c98ac7f03a8c32a1a462bdc.squirrel@intranet.cs.nmsu.edu>
Date: Thu, 3 Sep 2009 08:35:54 -0600
Subject: Re: Problem starting the input interrupt pipe on the G13
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: "Greg KH" <greg@kroah.com>, "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rick L. Vinyard, Jr. wrote:
> Greg KH wrote:
>> On Wed, Sep 02, 2009 at 03:25:50PM -0600, Rick L. Vinyard, Jr. wrote:
>>> Hello,
>>>
>>> I'm still working on the G13 driver, but I've run into a problem with
>>> the
>>> interrupt in pipe. In essence, I can't figure out how to get it
>>> started.
>>>
>>> The driver can be found at:
>>> http://g13.svn.sourceforge.net/viewvc/g13/driver/trunk/
>>>
>>> I think the root of the problem lies in the fact that the G13 usage
>>> page
>>> is 0x00 (undefined). The output and feature reports seem to be working
>>> fine to set the backlight color, the LCD image and the leds on the 'M'
>>> keys.
>>>
>>> However, nothing seems to be happening with the input report (there is
>>> only one input report type on endpoint address 0x81 that contains the
>>> joystick and key values).
>>>
>>> The problem is getting the input pipe started. I grepped through the
>>> other
>>> drivers in the hid directory and I couldn't find any that had to
>>> explicitly start the input interrupt.
>>
>> Have you just submitted an interrupt urb?
>>
>> That should be all that is needed, when the device has data, it will
>> return with it if your urb is pending.
>>
>
> I'll give it a shot.
>
> I hadn't tried it yet since I wasn't sure if that was the intended way to
> start it up within the HID framework since none of the other drivers
> submitted the urb.
>
> Also, submitting the urb requires the usbhid_device structure. Since the
> usbhid_device structure is defined in usbhid.h, and usbhid.h isn't
> installed with the kernel headers I wasn't sure if there was a better way
> to do it (raw events, input mapping or something along those lines).
>

Got it working. Submitting the URB didn't work because it wasn't open.
But, calling hdev->ll_driver->open(hdev) in probe opened it up and the
inputs are flowing now.

---

Rick



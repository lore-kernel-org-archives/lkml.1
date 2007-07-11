Return-Path: <linux-kernel-owner+w=401wt.eu-S932712AbXGKUl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbXGKUl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbXGKUlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:41:50 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:65289 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbXGKUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:41:50 -0400
Date: Wed, 11 Jul 2007 13:45:04 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] serial: do not add port that is not initialized
In-reply-to: <20070711194050.GB28258@flint.arm.linux.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <46954150.7050707@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <200707101703.36173.yinghai.lu@sun.com>
 <20070711071742.GA12952@flint.arm.linux.org.uk>
 <200707111005.53836.bjorn.helgaas@hp.com>
 <20070711194050.GB28258@flint.arm.linux.org.uk>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> On Wed, Jul 11, 2007 at 10:05:53AM -0600, Bjorn Helgaas wrote:
>> On Wednesday 11 July 2007 01:17:42 am Russell King wrote:
>>> On Tue, Jul 10, 2007 at 05:03:35PM -0700, Yinghai Lu wrote:
>>>> [PATCH] serial: do not add port that is not initialized
>>>>
>>>> if the port is not initialized with correct iobase, and membase, we don't
>>>> need to add that port.
>>>> for x86, when pnpacpi is enabled, we will not get extra ttyS1/ttyS2/ttyS3 in
>>>> /sys/devices/platform/serial8250/tty
>>>>
>>>> Sign-off-by: Yinghai Lu <yinghai.lu@sun.com>
>>> What if someone wants to run setserial on /dev/ttyS1 to set it's base
>>> address, irq and other parameters?  People still do this.
>> I agree that people still use setserial that way, and we shouldn't
>> make this change because it would break things.
>>
>> But I also agree with Yinghai that these extra phantom devices are
>> just weird.  It would be a lot nicer if there were a way to say,
>> "please, Mr. Serial Driver, create me a new ttyS device with these
>> parameters."
>>
>> But no, I'm not volunteering to do that.
> 
> Indeed, and since distros still haven't picked up my setserial v3,
> I see little chance of that ever being practical.  Not that I've
> really tried very hard to get them to - no real idea who to contact
> to make that happen, and of course I've no interest in making it
> happen anymore.

so remove these extra phantom devices, the kernel distros will use your setserial v3.

we can put some comments in code, so later they will find clue about your setserial v3.

YH

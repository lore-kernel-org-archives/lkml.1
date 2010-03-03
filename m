Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0CCT3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:29:52 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:48893 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab0CCT3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:29:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uRvIp0sEJkVIbew1zQGLVz7f3pYWazw3gCBz6J+ltGnJdGc8/zjywplOZUnOFT+Gb7
         DEk4o5AZmsy0u+H8+OQ9IhrNlDsbXDAPGf2BiUOXiXVDDLIutvfyZwIIbCSqkFkqMGJS
         r+mtQDJ46+8z+4RFhcvM2E39DQT3jL17eGx4k=
MIME-Version: 1.0
In-Reply-To: <4B8EB685.1060302@jic23.retrosnub.co.uk>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	 <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>
	 <20100303184132.GA11471@core.coreip.homeip.net>
	 <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
	 <4B8EB685.1060302@jic23.retrosnub.co.uk>
Date: Wed, 3 Mar 2010 23:29:43 +0400
Message-ID: <1a297b361003031129y6c19ad9cqe8658c2d85d8764@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Manu Abraham <abraham.manu@gmail.com>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 11:20 PM, Jonathan Cameron
<kernel@jic23.retrosnub.co.uk> wrote:
> On 03/03/10 18:52, Linus Torvalds wrote:
>>
>>
>> On Wed, 3 Mar 2010, Dmitry Torokhov wrote:
>>
>>> On Wed, Mar 03, 2010 at 09:03:16AM -0800, Linus Torvalds wrote:
>>>>
>>>> What's the difference between a physical "increase screen brightness" key,
>>>> and a "ambient light sensor"? Absolutely none as far as I can tell.
>>>
>>> Because in general ambient light sensor may have nothing to do with the
>>> screen brightness. The fact that all current uses are tied to
>>> controlling screen brightness is coincidential. You could use it as well
>>> to turn on the lights in the kitchen if it is getting too dark...
>>
>> But my point is, it acts pretty much like a key on a keyboard
>> _regardless_.
> Just one small clarification here.  It behaves a lot more like the axis of
> a joystick.  These sensors report illuminance, not merely a binary result.
> Some of them do have sophisticated threshold type logic, but
> all of them we have seen so far allow direct reading of the value.  Typical
> uses include things like long term environmental monitoring as
> well as screen brightness.  I have at least one Mote on my desk that has a
> ambient light sensor and no ability whatsoever to drive a screen.
> (Not that this effects whether input would make sense anyway!)


Maybe it make sense to put all Generic sensors into one whole lot,
where an application can

- read the value from the driver (eg: 0 - 65535)

- read from device static information (to identify how the application
should treat the values read back.)

   - report what type of device it is (Light, Voltage, Acceleration
and what not, simple enumeration will help, mayeb you can even have
bitwise OR the types, so that you can have a driver with multiple
capabilities)
   - the max value it can go
   - the min value it can go
   - the number of steps (gradient) that the driver can do.


Maybe such a simplistic interface does help ?

The application can simply read the static information from the driver
and decide whether it should really handle that driver class.


Regards,
Manu

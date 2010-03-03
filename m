Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0CCUGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:06:50 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:44491 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab0CCUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:06:44 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8EC1C7.809@cam.ac.uk>
Date: Wed, 03 Mar 2010 20:08:39 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain> <20100303184132.GA11471@core.coreip.homeip.net> <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain> <20100303190753.GB11471@core.coreip.homeip.net> <4B8EB99F.4080104@jic23.retrosnub.co.uk>
In-Reply-To: <4B8EB99F.4080104@jic23.retrosnub.co.uk>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/10 19:33, Jonathan Cameron wrote:
> Hi Dmitry, 
>>>>> What's the difference between a physical "increase screen brightness" key, 
>>>>> and a "ambient light sensor"? Absolutely none as far as I can tell.
>>>>
>>>> Because in general ambient light sensor may have nothing to do with the
>>>> screen brightness. The fact that all current uses are tied to
>>>> controlling screen brightness is coincidential. You could use it as well
>>>> to turn on the lights in the kitchen if it is getting too dark...
>>>
>>> But my point is, it acts pretty much like a key on a keyboard 
>>> _regardless_. 
>>>
>>> Sure, you migth use it to turn up the lights too. But how is that 
>>> different from having a switch to do the same? Again, it doesn't sound 
>>> that different from a key to me.
>>
>> I guess for me the distinction is that the event was not caused by an
>> action of a human being but by change in environment.
>>
>> Also, if we decide that input layer is the best place for such devices,
>> it should not be a key but absolute event, ABS_LIGHT_LEVEL or something.
>>
>>>
>>>> Yes, it is easier, but it is not necessarily the right interface. I
>>>> still believe in using input layer for human iteraction events, and not
>>>> as generic transport a-la netlink or uevent. Voltage measurements,
>>>> network cable presence notifications, ambient light/temperature sensors,
>>>> and so forth do not belong here.
>>>
>>> The thing is, if the choice is about a whole new subsystem just for some 
>>> silly light sensor logic, I'd _much_ rather see the much simpler - and 
>>> more useful - approach of just considering it an input event.
>>>
>>> It happens in the same kind of situations, it has the same kinds of timing 
>>> issues (ie we're not talking streaming megabytes of data), and it has the 
>>> same kind of users (ie a lightsensor really would be used along with 
>>> something that cares about input).
>>>
>>> I agree that that's not true in many other situations. A cable insertion 
>>> event is about the networking, not about some independent input. The kind 
>>> of application that cares about network cable presense is _not_ the kind 
>>> of app that would care about keyboard input. Same goes for voltage.
>>
>> What about magnetometers, accelerometers and so forth? I still do not
>> think they are pure input layer devices although it is possible to build
>> a bridge modules so they could plug into input framework if desired.
>>
>>>
>>> That said, I'm not married to the whole "it has to be input layer". But I 
>>> _do_ think that it's crazy to start doing new subsystems for every little 
>>> thing. That way lies madness. 
>>>
>>
>> I was hoping IIO would fill the niche of framework for generic data
>> acquisition devices, regardless of how fast or slow they are.
> We are working on it, but unfortunately the 'fast' end of the scale is
> making it rather complex beast and there is still a fair bit of work
> to be done before we suggest merging into the main tree.  We allow
> for 'simple' drivers that do have very similar functionality to ALS as
> proposed. (i.e. they just handle some sysfs interfaces and device
> registration).
> 
> I certainly have no objection to taking light sensors back into IIO.
> (one never moved out!)  Obviously I'll want opinions from the individual
> driver developers before doing this. As things currently stand it involves
> moving drivers out of mainline into staging. Whilst we have numerous drivers
> being developed against the subsystem as is, elements of it (including the
> userspace api) are still changing.
Just to clarify, I'm not overly keen on taking them into IIO now. There is
clearly a demand for these drivers and I tend to agree with Jean's earlier
posting. It is better to get things people need out there and refactor
as needed to share functionality as and when it makes sense in the future,
particularly in cases like this where we are effectively already taking
steps in that direction by grouping these existing drivers.

> 
> ALS actually grew out of ACPI and as Zhang Rui was proposing a subsystem
> that got a positive response on LKML, quick discussions amongst IIO devs
> came to the conclusion that these particular drivers actually overlap hardly
> at all in terms of functionality with the rest of our devices set so there
> would be no loss in moving them out and considerable gain in giving them
> a stable user interface etc.
> 
> Jonathan
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab0CCTSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:18:49 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:56251 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab0CCTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:18:34 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8EB685.1060302@jic23.retrosnub.co.uk>
Date: Wed, 03 Mar 2010 19:20:37 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain> <20100303184132.GA11471@core.coreip.homeip.net> <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/10 18:52, Linus Torvalds wrote:
> 
> 
> On Wed, 3 Mar 2010, Dmitry Torokhov wrote:
> 
>> On Wed, Mar 03, 2010 at 09:03:16AM -0800, Linus Torvalds wrote:
>>>
>>> What's the difference between a physical "increase screen brightness" key, 
>>> and a "ambient light sensor"? Absolutely none as far as I can tell.
>>
>> Because in general ambient light sensor may have nothing to do with the
>> screen brightness. The fact that all current uses are tied to
>> controlling screen brightness is coincidential. You could use it as well
>> to turn on the lights in the kitchen if it is getting too dark...
> 
> But my point is, it acts pretty much like a key on a keyboard 
> _regardless_. 
Just one small clarification here.  It behaves a lot more like the axis of
a joystick.  These sensors report illuminance, not merely a binary result.
Some of them do have sophisticated threshold type logic, but
all of them we have seen so far allow direct reading of the value.  Typical
uses include things like long term environmental monitoring as
well as screen brightness.  I have at least one Mote on my desk that has a
ambient light sensor and no ability whatsoever to drive a screen.
(Not that this effects whether input would make sense anyway!)
> 
> Sure, you migth use it to turn up the lights too. But how is that 
> different from having a switch to do the same? Again, it doesn't sound 
> that different from a key to me. 
> 
>> Yes, it is easier, but it is not necessarily the right interface. I
>> still believe in using input layer for human iteraction events, and not
>> as generic transport a-la netlink or uevent. Voltage measurements,
>> network cable presence notifications, ambient light/temperature sensors,
>> and so forth do not belong here.
> 
> The thing is, if the choice is about a whole new subsystem just for some 
> silly light sensor logic, I'd _much_ rather see the much simpler - and 
> more useful - approach of just considering it an input event.
> 
> It happens in the same kind of situations, it has the same kinds of timing 
> issues (ie we're not talking streaming megabytes of data), and it has the 
> same kind of users (ie a lightsensor really would be used along with 
> something that cares about input).
> 
> I agree that that's not true in many other situations. A cable insertion 
> event is about the networking, not about some independent input. The kind 
> of application that cares about network cable presense is _not_ the kind 
> of app that would care about keyboard input. Same goes for voltage.
> 
> That said, I'm not married to the whole "it has to be input layer". But I 
> _do_ think that it's crazy to start doing new subsystems for every little 
> thing. That way lies madness. 

In principle I agree, but the current situation was also causing problems.  Within
the mainline and other incoming trees there were 4 drivers for light sensors.
Each one was in a different 'subsystem' (one was in misc) and each was exporting
data to userspace via different interface causing all sorts of fun for userspace
developers.  The core of the subsystem is really just a small amount of
documentation and a class to give a common location (which we could drop;
it is merely a convenience for userspace). Perhaps we just provide the documentation
and move the lot into misc?

Jonathan

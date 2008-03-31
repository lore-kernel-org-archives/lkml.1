Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYCaRV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYCaRV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbYCaRVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:21:21 -0400
Received: from rtr.ca ([76.10.145.34]:3190 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbYCaRVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:21:20 -0400
Message-ID: <47F11D8F.4020209@rtr.ca>
Date: Mon, 31 Mar 2008 13:21:19 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <200803311704.37256.oliver@neukum.org> <47F0FD8E.4090005@rtr.ca> <200803311837.30129.oliver@neukum.org> <47F1196E.9090509@rtr.ca> <47F11C3D.9080704@rtr.ca>
In-Reply-To: <47F11C3D.9080704@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Oliver Neukum wrote:
>>> Am Montag, 31. März 2008 17:04:46 schrieb Mark Lord:
>>>> Oliver Neukum wrote:
>>>>> Am Montag, 31. März 2008 16:39:33 schrieb Mark Lord:
> ..
>>>>>> Still want USB_SUSPEND=n ?  Please explain.
>>>>> It looks like you are hanging in the kthread for autosuspending.
>>>>> Compiling that out should confirm it.
>>>> ..
>>>>
>>>> Okay, and once we see that it works fine:  then what?
>>>
>>> We'll combine that information with the result of only removing usbhid
>>> and arrive at a pretty good idea where in the kernel the hang occurs.
>>> There are only two functions that touch autosuspend in the usbhid code.
>>> So if it works with usbhid unloaded, either of them should be to blame.
>> ..
>> It does still hang with *usbhid* unloaded,
>> but not if all USB stuff is unloaded.
> ..
> 
> And it does *not* hang with # CONFIG_USB_SUSPEND is not set.
> 
>> I have figured out a way to make this much more reproducible now:
>> When suspended, the notebook does not supply +5V over USB.
>> But with a voltmeter, I discovered that there is sufficient capacitance
>> on the USB +5V, that it takes many minutes for the voltage to decay
>> from 5.1V down to near 0V.
>>
>> Resuming while the voltage is still relatively high, generally works.
>> Resuming after the voltage drops to near zero, always fails (with USB 
>> modules loaded).
>>
>> So I've put a 2Kohm resistor across the USB +5V lines,
>> forcing it to decay to zero within about 5 seconds.
>> This helps a lot for debugging here.
>>
>> It probably also provides a vital clue as to what is wrong.
>> Resume seems to generally work when the USB devices maintain
>> some amount of standby power, and always fails when they don't.
..

Note that it makes no difference whether I unplug all external USB devices
prior to suspend or not.  The failure patterns remain the same.

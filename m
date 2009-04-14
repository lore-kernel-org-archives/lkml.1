Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZDNRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZDNRhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbZDNRhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:37:22 -0400
Received: from rtr.ca ([76.10.145.34]:44431 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbZDNRhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:37:21 -0400
Message-ID: <49E4C9CF.5060504@rtr.ca>
Date: Tue, 14 Apr 2009 13:37:19 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com> <200904131931.24009.dmitry.torokhov@gmail.com> <49E4B678.9030508@rtr.ca> <200904140945.14652.dmitry.torokhov@gmail.com>
In-Reply-To: <200904140945.14652.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Tuesday 14 April 2009 09:14:48 Mark Lord wrote:
>> Dmitry Torokhov wrote:
>>> Hi Mark,
>>>
>>> On Wednesday 08 April 2009 10:28:09 Mark Lord wrote:
>>>> Dmitry,
>>>>
>>>> I briefly had access to a Twinhan remote control (for Mythtv et al.)
>>>> and cobbled something together quickly to make it work.
>>>>
>>>> But I really don't understand the new hid/input stuff,
>>>> so this is undoubtedly a total abomination to your eyes. :)
>>> Actually HID is Juri's baby so let's see what he says ;). From my POV
>>> we need to update keymap to make it emit proper codes instead of Myth
>>> specific ones, but that is a lesser issue.
>> ..
>>
>> That's one thing I haven't figured out:  how to make this compatible
>> with the userspace intput-kbd interface for loading new key maps and stuff.
>>
> 
> You will need to convert your patch into proper hid_driver and
> implement drv->input_mapping() method instead of overriding emitted
> events. Then, once HID core is aware about proper mapping, normal
> EVIOCGKEYCODE/EVIOCSKEYCODE will work and will allow adjusting
> keymap from user space.
..

I tried that earlier, but input-kbd only ever listed a single (wrong)
key in the keymap, and wouldn't allow changing anything.
Obviously there's more to it somewhere, I guess.

> I think if you take drivers/hid/hid-belkin.c as a template the
> conversion will take you no time.
..

Okay, I can have a look at that one.  Thanks.


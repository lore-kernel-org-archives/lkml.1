Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbXDZV0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbXDZV0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbXDZV0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:26:12 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:60082 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135AbXDZV0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:26:10 -0400
Message-ID: <463118E7.3030902@tremplin-utc.net>
Date: Thu, 26 Apr 2007 23:25:59 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.3) Gecko/20070423 Mandriva/2.0.0.0-1mdv2008.0 (2008.0) Thunderbird/2.0.0.0 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mitr@volny.cz,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/5] wistron_btns: add led support
References: <200704260716.l3Q7Gb9U023608@shell0.pdx.osdl.net> <d120d5000704260850m788af054pba2117a002694210@mail.gmail.com>
In-Reply-To: <d120d5000704260850m788af054pba2117a002694210@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[re-CC'ing lkml as it's back to the original topic]
26.04.2007 17:50, Dmitry Torokhov wrote/a écrit:
> On 4/26/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
>> From: Eric Piel <eric.piel@tremplin-utc.net>
>>
>> Add support to wistron_btns for leds that comes with the multimedia keys.
>> Mail and wifi leds are supported, on laptops which have them.  
>> Depending on
>> the laptop, wifi subsystem may control just the led, or both the led and
>> the wifi card.  Wifi led interface is activated only for the former 
>> type of
>> laptops, as the latter type is already managed.  Leds are controled by 
>> the
>> interface in /sys/class/leds.
> 
> I am not sure if we want to allow controlling WIFI state via leds. I'd
> rather plug it into RFkill infrastructure once it is merged and have
> leds only reflect state of the corresponding switch.
> 
Sorry if I wasn't clear. This is basically what does the driver. At 
least, the led interface _do not_ control the WIFI state :-)

What I meant is that there are two kinds of laptops:
A - the one where wifi led _only_ is controlled by the wistron hardware. 
Wifi card is controlled completely independently (pcmcia).
B - the one where wifi card _and_ wifi led are controlled by the wistron 
hardware (they are completely bound).

So far, only B laptops were handled, à la RFkill: the button directly 
modifies the wifi state and wifi led with no userspace involvement. My 
patch adds wifi led interface only to A laptops, only the led is 
controlled. So wifi state is never modified by led interface.

I hope I cleared up what does this patch and that it's ok with you. If 
not, just let me know which behaviour you think would be more 
appropriate and I'll hack a new patch :-)

See you,
Eric

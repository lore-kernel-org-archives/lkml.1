Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbXC0MUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbXC0MUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 08:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXC0MUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 08:20:12 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:46487 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbXC0MUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 08:20:09 -0400
Message-ID: <46090BF2.2000105@gmail.com>
Date: Tue, 27 Mar 2007 14:20:02 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: johann deneux <johann.deneux@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       =?UTF-8?B?IlNUZW55YUsgKEJydW5vIEdvbnrDoWxleiki?= 
	<stenyak@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom
 driver]
References: <2460126662758025813@fi.muni.cz> <46018FB8.1080601@gmail.com> <38b3b7c0703211503s3a8ee177v5b149cfd5975de8c@mail.gmail.com> <200703221150.12403.dtor@insightbb.com>
In-Reply-To: <200703221150.12403.dtor@insightbb.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 27 Mar 2007 14:20:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov napsal(a):
> On Wednesday 21 March 2007 18:03, johann deneux wrote:
>> On 3/21/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>>> Dmitry Torokhov napsal(a):
>>>> On 3/21/07, johann deneux <johann.deneux@gmail.com> wrote:
>>>>> I would suggest adding a new effect type (3d effect) and extending the
>>>>> union in struct ff_effect.
>>>>> Let me know if I'm too vague, I already suggested that solution but
>>>>> got no answer. I wonder if my mail got lost, nobody understood what I
>>>>> said, or if it's just a plain bad idea.
>>>>>
>>>> My concern with a new 3D effect is that it will be a very "simple"
>>>> effect with only constant force apllied. That might be enough for
>>>> phantom but may not be sufficient for future devices. If we add
>>>> ability to specify a "plane" for an effect we will be able to add
>>>> envelopes on top of more complex effects and get desired combined
>>>> effcet.
>>> I didn't get this too much, because I don't understand the FF layer well so
>>> far. How is this going to work? Let's say, we have 3 torque values computed
>>> in US, and this structure:
>>>
>>> struct ff_effect {
>>>     __u16 direction;
>>>     struct ff_trigger trigger;
>>>     struct ff_replay replay;
>>>
>>>     struct ff_constant_effect {
>>>         __s16 level;
>>>         struct ff_envelope {
>>>              __u16 attack_length;
>>>              __u16 attack_level;
>>>              __u16 fade_length;
>>>              __u16 fade_level;
>>>         };
>>>     };
>>> };
>>>
>>> and need to pass the three 16bits torques into s16 ioaddr[0..2]. How?
>>>
>> Stupid question, 

Sorry to be out for so long, maybe I'm stupid idiot, that understands
nothing, but:

>> I have forgotten the details of ioctl: Wouldn't the
>> following work?

No, at least, as far as I understand this. I have computed _torques_, not
forces vector (this was misleading info in my first post), the question is
"how can I pass torques through plane and direction entries into KS?".

>> struct ff_effect {
>>         __u16 type;
>>         __s16 id;
>>         __u16 direction;
>>         struct ff_trigger trigger;
>>         struct ff_replay replay;
>>
>>         union {
>>                 struct ff_constant_effect constant;
>>                 struct ff_ramp_effect ramp;
>>                 struct ff_periodic_effect periodic;
>>                 struct ff_condition_effect condition[2]; /* One for each axis */
>>                 struct ff_rumble_effect rumble;
>>         } u;
>>
>>         /* New member: Specify a plane in the 3d space. */
>>         struct ff_ruct ff_plane plane;
>> };
[...]
>> Alternatively, one could leave ff_effect effect untouched and find
>> another way to specify the plane, e.g. another ioctl.
> 
> I was thinking about a new ioctl to specify a plane for a specific effect,
> but probably extending the structure and having 2 distinct ioctls (with
> and without plane) is cleaner.

This sounds good for me, if I (or someone) have forces vector, but it
doesn't help me in my situation.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

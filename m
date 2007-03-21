Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbXCUNbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbXCUNbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXCUNbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:31:20 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:34821 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXCUNbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:31:19 -0400
Message-ID: <4601339C.6010706@gmail.com>
Date: Wed, 21 Mar 2007 14:31:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: =?UTF-8?B?IlNUZW55YUsgKEJydW5vIEdvbnrDoWxleiki?= 
	<stenyak@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       johann deneux <johann.deneux@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom
 driver]
References: <2460126662758025813@fi.muni.cz>	 <d120d5000703070856of068f19k62c5a7ce1f829336@mail.gmail.com>	 <4af2d03a0703130919nb4893b1ja9ec795dcf4bf53c@mail.gmail.com>	 <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>	 <45F722CE.9000602@gmail.com>	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>	 <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com> <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>
In-Reply-To: <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 21 Mar 2007 14:31:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

STenyaK (Bruno González) napsal(a):
> On 3/14/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> > I have a question: if the force is to be 3D, why only 3 possible
>> values?
>> > What would they be, 3 torques or 3 forces? In the case of car sims (ff
>> > steering wheels), only one axis of torque is usually used (except
>> for 6 dof
>> > platforms, as mentioned).
>> >
>>
>> I wonder if we could somehow extend or augment FF envelope se we could
>> specify a plane for the effect.. Then a vector could be represented by
>> a sum 3 constant effects in 3 separate planes and we could also use
>> spring and other effects as well.
> 
> Ideally, afaik we should use:
> -3 values for translation force (linear force): x,y,z components of
> the force vector.
> -4 values for rotation force (torque): x,y,z,w components of the
> quaternion. You can also use euler angles (and i think there are
> another one or two notations), which is just 3 values, but i'm not
> sure it will be a correct decision (due to the gimbal lock problem,
> which may or may not be present in ff devices, dunno).

So, the resolution is? Since I want no longer have out-of-kernel driver, I
need to know how to implement the phantom driver -- merge it `as is', i.e.
control through mmio or rewrite ff layer somehow, and in that case how?

There seem to be only few possibilities:

- new 3D effect, which will be problematic in any other future use, that may
need more than 3 axis. no matter if torques or vector is passed -- depending
on device and programmer (as I need to compute torques from forces in FP).
Maybe struct with 2x 3 axis is OK

- "raw" effect, which may contain more axis, but this is ugly in Anssi's eyes

- something else? (did I forget something)

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

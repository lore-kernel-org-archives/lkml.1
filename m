Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXCUUEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXCUUEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXCUUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:04:16 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:52601 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXCUUEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:04:15 -0400
Message-ID: <46018FB8.1080601@gmail.com>
Date: Wed, 21 Mar 2007 21:04:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: johann deneux <johann.deneux@gmail.com>,
       =?UTF-8?B?IlNUZW55YUsgKEJydW4=?= =?UTF-8?B?byBHb256w6FsZXopIg==?= 
	<stenyak@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom
 driver]
References: <2460126662758025813@fi.muni.cz> <45F722CE.9000602@gmail.com>	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>	 <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>	 <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>	 <4601339C.6010706@gmail.com>	 <38b3b7c0703211202p29f7865cr34960c7ea708640e@mail.gmail.com> <d120d5000703211222j64fd22fbn1e06267790f8a569@mail.gmail.com>
In-Reply-To: <d120d5000703211222j64fd22fbn1e06267790f8a569@mail.gmail.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 21 Mar 2007 21:04:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov napsal(a):
> On 3/21/07, johann deneux <johann.deneux@gmail.com> wrote:
>> I would suggest adding a new effect type (3d effect) and extending the
>> union in struct ff_effect.
>> Let me know if I'm too vague, I already suggested that solution but
>> got no answer. I wonder if my mail got lost, nobody understood what I
>> said, or if it's just a plain bad idea.
>>
> 
> My concern with a new 3D effect is that it will be a very "simple"
> effect with only constant force apllied. That might be enough for
> phantom but may not be sufficient for future devices. If we add
> ability to specify a "plane" for an effect we will be able to add
> envelopes on top of more complex effects and get desired combined
> effcet.

I didn't get this too much, because I don't understand the FF layer well so
far. How is this going to work? Let's say, we have 3 torque values computed
in US, and this structure:

struct ff_effect {
    __u16 direction;
    struct ff_trigger trigger;
    struct ff_replay replay;

    struct ff_constant_effect {
        __s16 level;
 	struct ff_envelope {
   	     __u16 attack_length;
    	     __u16 attack_level;
   	     __u16 fade_length;
     	     __u16 fade_level;
	};
    };
};

and need to pass the three 16bits torques into s16 ioaddr[0..2]. How?

> I would not worry aboput extra memory needed on I-force like
> devices because they just would not support additional "planes". What
> about phantom? Would it have enough memory?

It's a memless device -- values written into pci space are immediately felt
in FF (it's just PLX chip interface to some their proprietary chip or somewhat).

> On the other hand if you guys (Anssi, Johann, Jiri...) decide that a
> simple new 3d effect is the most efficient solution for now and will
> be enough for a few years (till we get FF v2 API) I will merge it.

I won't force any of mentioned solutions, but this seems the simplest one in
my eyes.

thanks for clues,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

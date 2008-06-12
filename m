Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYFLO6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYFLO6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYFLO6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:58:34 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:7621 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYFLO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=scjve5dnmSsx8Eo2ogS5l5bPESqtzipmQ4o02WkiLQ7Sb28AQQYUwVCOJGyHnZEsyI
         k7iBAdeEZfr39FCttFiwrrbPXmobhtdS/nxI4Ul+wy6pLsb7nFHrjwNJ4laseAQJnld5
         Bo4EwyyHY7kf9ShH8rurZAOcxxIsDcwS/Zucg=
Message-ID: <6278d2220806120758y38d9b431td3996a3cef73bb50@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:58:30 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h8wxarauf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <19f34abd0806120603q2ddc6654r9562dfea556c2791@mail.gmail.com>
	 <s5hlk1are3o.wl%tiwai@suse.de>
	 <19f34abd0806120648j4f15b762r8e72c348c14b946f@mail.gmail.com>
	 <s5hhcbyrcak.wl%tiwai@suse.de>
	 <19f34abd0806120655u75df09bfuaf33f1d54128b0b7@mail.gmail.com>
	 <s5hej72rbsh.wl%tiwai@suse.de>
	 <19f34abd0806120718g21ddfa3bjbf6f194aa1d3d37d@mail.gmail.com>
	 <s5h8wxarauf.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 3:23 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 12 Jun 2008 16:18:14 +0200,
> Vegard Nossum wrote:
>>
>> On Thu, Jun 12, 2008 at 4:02 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Thu, 12 Jun 2008 15:55:45 +0200,
>> > Vegard Nossum wrote:
>> >>
>> >> On Thu, Jun 12, 2008 at 3:52 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> >> > At Thu, 12 Jun 2008 15:48:32 +0200,
>> >> > Vegard Nossum wrote:
>> >> >>
>> >> >> The external mic:
>> >> >>
>> >> >> Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>> >> >>   Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
>> >> >>   Amp-In vals:  [0x00 0x00]
>> >> >
>> >> > The input volume is zero.  Try to raise "Mic Boost" (if present)?
>> >>
>> >> They're already all up.
>> >>
>> >> Line In Boost = 100
>> >> Mic Boost = 100
>> >> Internal Mic Boost = 100
>> >>
>> >> Right after changing all these to max, I've read the value from
>> >> card0/codec#0 again:
>> >>
>> >> Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>> >>   Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
>> >>   Amp-In vals:  [0x00 0x00]
>> >>
>> >> There doesn't seem to be any difference. Even when changing them all
>> >> to 0 in alsamixer, this output stays the same.
>> >
>> > Weird.  What happens if you execute the verb directly via hda-verb
>> > program like below?
>> >        hda-verb /dev/snd/hwC0D0 0x18 SET_AMP 0x7002
>> >
>>
>> Yep, this has the same effect has changing the "Mic Boost" control in
>> the Playback section of alsamixer.
>>
>> What I discovered now, though, is that I get a much wider range of
>> values from the external mic (so playback of the captured data
>> actually sounds correct). It actually works, but there is still a very
>> strong DC offset that seems dependent on the level of the "Capture"
>> control. This offset still makes it unusable for recording, since even
>> slightly louder noises will clip the samples.
>>
>> It also seems that this control is reset each time I start Audacity
>> (even though the "Mic boost" level in alsamixer doesn't change). But I
>> guess this unrelated to the DC offset issue.
>>
>> Changing the voltage level now (0x21, 0x22, 0x24, with Mic Boost at
>> 0x02) doesn't change the DC offset, but has the same effect as before
>> (the values fluctuate, but eventually stabilize at the same level).
>
> Hmm, then it's all what I can guess right now.
> There might be some vendor-specific settings I don't know of.

Maybe. I can readily dump the PCI config space of the Intel HD-audio
controller in Windows and list differences; the datasheet from Intel
allows us to decode the registers. Will this help us any? Of course,
we really need to dump the target behind the HD-bus, but that's
another matter...

> To be sure, try the following git tree (master branch), pull on
> 2.6.26:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
>
> This contains the patches for the next kernel, and some of them are
> related with Realtek codecs.
>
>
> Takashi
>



-- 
Daniel J Blueman

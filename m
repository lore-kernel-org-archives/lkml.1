Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYF1NrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYF1NrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbYF1NrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:47:01 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:30107 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbYF1NrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z07F5FlwhgrHGwwRwAKlLGKV5tmzJIBZpfcX1mVMIL8ZAqVAy5qNPqaYpH7JjkqN0f
         kqfAKFwGrWZp5cJc8UsDhU4JCWHiaSQX8OLPrmkm2RVma/iYCApVdCN8kG8X3x6SwZqh
         8kjoudRfJ6XVXHOX0nuSde3lfVM6XAapQJvP4=
Message-ID: <19f34abd0806280646n47118184vfe44282709f7f76d@mail.gmail.com>
Date: Sat, 28 Jun 2008 15:46:59 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Daniel J Blueman" <daniel.blueman@gmail.com>
Subject: Re: ALC883 recording troubles...
Cc: "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Takashi Iwai" <tiwai@suse.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806280624iec3a67rf25789e98f81521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
	 <19f34abd0806280311s115062e6vc6d0f304cb744934@mail.gmail.com>
	 <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
	 <6278d2220806280529n70c6233dk1c5768df5d52acf@mail.gmail.com>
	 <19f34abd0806280539g4961392evb469d7c106c198c9@mail.gmail.com>
	 <6278d2220806280624iec3a67rf25789e98f81521@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 3:24 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On Sat, Jun 28, 2008 at 1:39 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On Sat, Jun 28, 2008 at 2:29 PM, Daniel J Blueman
>> <daniel.blueman@gmail.com> wrote:
>>> Using your dumped config and
>>> ftp://202.65.194.211/pc/audio/ALC268_DataSheet_1.3.pdf page 42, your
>>> front mic pin complex is at node 19h; the mixers connecting to it are
>>> at nodes 0Bh, 22h and 23h, all at the second input index, so one of
>>> these should work:
>>>
>>> # ./hda-verb /dev/snd/hwC0D0 0x0b SET_AMP_GAIN_MUTE 0x7280
>>> # ./hda-verb /dev/snd/hwC0D0 0x22 SET_AMP_GAIN_MUTE 0x7280
>>> # ./hda-verb /dev/snd/hwC0D0 0x23 SET_AMP_GAIN_MUTE 0x7280
>>>
>>> On my ALC883, we need to mute the first input instead, thus 0x7180.
>>> Can you see if the above helps you out?
>>
>> Thanks for helping out!
>>
>> Unfortunately, none of these commands (with either 0x7180 or 0x7280)
>> seems to make any difference at all. (I tried various combinations,
>> with reloading the driver in-between to undo the trial attempts.)
>
> I made a mistake - the second input is selected by 0x7180, as the
> first is 0x7080...perhaps retry this with nodes 0Bh, 22h and 23h?
>

I did -- no difference.

> Failing that, these are the steps I'd try:
>  1. setup audio so as to reproduce input DC offset
>  2. start recording in audacity and observe DC offset
>  3. for each input of each mixer:
>  3.1 mute until you see the DC offset disappear
>
> ie for ALC268, mixer input amps at nodes (# inputs): 0Eh(1) 0Fh(2)
> 10h(3) 18h(1) 19h(1) 1Ah(1)
> ie:
>

Also no difference :-(

> Changes are real-time, so no need to restart anything. Once you've
> found which mixer input amp and input index stops the DC offset, reset
> the HD codec (eg reboot) and try just that one! I'm interested in
> hearing if this finds the issue...
>

The only result was the muting of playback.

But thanks for the hints, I'll try to look for other combinations that
might help too. If you have other ideas too, I'll be happy to try them
out!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYKEAq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYKEAq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYKEAqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:46:49 -0500
Received: from nebensachen.de ([195.34.83.29]:37883 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbYKEAqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:46:48 -0500
X-Hashcash: 1:20:081105:hancockr@shaw.ca::ybV0KepO6HsV9bZt:00fb+
X-Hashcash: 1:20:081105:liml@rtr.ca::e6oVrKTyeXm70AV5:0000001OkD
X-Hashcash: 1:20:081105:rjw@sisk.pl::yBADaf1+iBD+GTuO:0000004B1b
X-Hashcash: 1:20:081105:torvalds@linux-foundation.org::3yrI2pPj3BRIrlj0:000000000000000000000000000000000X+g
X-Hashcash: 1:20:081105:jeff@garzik.org::FkN8W4apNPbDHEx2:000Ewq
X-Hashcash: 1:20:081105:akpm@linux-foundation.org::F0SElsSVA8rTu86j:0000000000000000000000000000000000004iHi
X-Hashcash: 1:20:081105:linux-ide@vger.kernel.org::v72kiEoGL8MoSoAB:0000000000000000000000000000000000007O2G
X-Hashcash: 1:20:081105:linux-kernel@vger.kernel.org::50xBww609bjmbnoG:0000000000000000000000000000000005FHg
From: Elias Oltmanns <eo@nebensachen.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Mark Lord <liml@rtr.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <fa.Ast7pgG6P20u1PcyOsfgzoaX5YA@ifi.uio.no>
	<fa.1+JQHm7yjIiZJxAzR0eBPn39a9M@ifi.uio.no>
	<fa.+bfipgmFkcLlZMtnFL0Ks2zyN8Q@ifi.uio.no>
	<fa.Iek0GbTZLinM2sOi6+b7bsCgnfs@ifi.uio.no> <4910E240.4000801@shaw.ca>
Date: Wed, 05 Nov 2008 01:45:54 +0100
Message-ID: <87abcfdmpp.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockr@shaw.ca> wrote:
> Mark Lord wrote:
>> Rafael J. Wysocki wrote:
>
>>> On Tuesday, 4 of November 2008, Linus Torvalds wrote:
>>>> On Tue, 4 Nov 2008, Jeff Garzik wrote:
>>>>> This adds code at a late stage (heading towards -rc4), but does
>>>>> eliminate a particular spin-up overcycling behavior associated with
>>>>> hibernation.
>>>> What does this have to do with hibernation?
>>>> If it's a hibernation-only issue, then there is something wrong. 
>>>
>>> No, it is not.  On some machines it is a power-off issue, on the
>>> others it is
>>> hibernation and power-off issue.
>>>
>>>> Also, if it is an issue for normal power-off as well, then I
>>>> wonder why this isn't an issue on Windows. Does windows not spin
>>>> down disks at all?
>>>
>>> In fact, AFAICS, it is an issue on Windows as well, at least if
>>> other-than-HP-preloaded version of Windows is used.
>>>
>>>> IOW, I really don't think this is correct.
>>>> I _do_ think that correct might be:
>>>>
>>>>  - maybe we just do something odd and different, triggering some
>>>> BIOS    behavior that isn't there under Windows.
>>>>
>>>>    So we should power down thigns differently so that the BIOS.
>>>>
>>>>  - quite possibly: we just should not spin down disks at all, and
>>>> just    flush them and do the "park" command thing. If we're
>>>> _really_ powering    off, the disks will spin down on their own
>>>> when power goes away. Maybe    that's what Windows does?
>>>>
>>>> So I really don't want to pull this, because I want to get more of
>>>> an explanation for why we need to do this at all. I also don't
>>>> think this is even appropriate at this stage in -rc.
>>>>
>>>> Is it a regression? If so, that just strengthens the questions
>>>> above - what did _we_ start doing wrong that this is needed at
>>>> all? Let's just stop doing that, not add some idiotic black-list
>>>> for somethign that _we_ do wrong.
>>>
>>> This is a regression, but from something like 2.6.25 or even earlier.
>>> I think what happened is we started to power-off disks at one point
>>> and these
>>> BIOS-es just don't like that.
>>>
>>> [Note that the issue only appears in _some_ HP boxes, other vendors don't
>>> seem to be affected at all.]
>> .
>>
>> So, what happens if we just don't ever spin them down from the kernel?
>> Presumably they still spin-down normally (HP or otherwise) when the BIOS
>> actually cuts the power at the end of all of this?
>>
>> Just curious..
>
> On many disks (especially laptops) just cutting the power without
> spinning the disk down is a bad thing to do, as it causes an emergency
> head unload which causes much more disk wear than a normal controlled
> unload (which a commanded spindown causes). This is much worse than
> the problem here, where the disk is spun down, spun up and down again.
>
> On these systems, not spinning the disk down is fine because the BIOS
> does it. However this would cause problems on systems where the BIOS
> doesn't do so as it will cause an emergency unload on power-down.

Ah, but do BIOSes just cut power without spinning disks down first?
Pressing the power button on my laptop either at the prompt for the HD
password or in GRUB's menu spins the disk down properly. Isn't that the
BIOS doing its job?

>
> From what I have heard, the problem on the HP laptops is thought to be
> something to do with the disk spinning up and back down when it gets
> an IDLE IMMEDIATE command (from the BIOS' SMI code, or whatever it is)
> when it's already spun down (by the kernel). If that's truly the case
> it's pretty retarded behavior on the disk's part..

IDLE IMMEDIATE is supposed to spin the disk up unless the unload feature
is requested. You are probably thinking of STANDBY IMMEDIATE. If your
theory is correct, then a hdparm -y while the drive is in standby mode
should have a similar effect, i.e. the disk should spin up and down
again right afterwards. Is that the case?

Regards,

Elias

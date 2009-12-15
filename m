Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbZLOU35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbZLOU35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761075AbZLOU3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:29:55 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42413 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbZLOU3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:29:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GF/y4dNay6kRlZUhpnq9q/sMF4RHvmO9Tym0e8oU65Sb3NPrlF1I9LLbfsjTm6du2T
         ry6HgCm39y1TOrecygX3IKrCpbidYusjt+YN2u5dIHziNzPEumJd4Vor1C/hPkP7VN3m
         CgwRpXmU1/g/DGR2G3JWH3YNl8CCzsT3ztuk0=
MIME-Version: 1.0
In-Reply-To: <20091215201933.GK24406@elf.ucw.cz>
References: <4B1B99A5.2080903@redhat.com>
	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <m3skbn6dv1.fsf@intrepid.localdomain>
	 <20091207184153.GD998@core.coreip.homeip.net>
	 <4B24DABA.9040007@redhat.com> <20091215115011.GB1385@ucw.cz>
	 <4B279017.3080303@redhat.com> <20091215195859.GI24406@elf.ucw.cz>
	 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
	 <20091215201933.GK24406@elf.ucw.cz>
Date: Tue, 15 Dec 2009 15:29:51 -0500
Message-ID: <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 3:19 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2009-12-15 15:14:02, Jon Smirl wrote:
>> On Tue, Dec 15, 2009 at 2:58 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> >>       (11) if none is against renaming IR as RC, I'll do it on a next patch;
>> >
>> > Call it irc -- infrared remote control. Bluetooth remote controls will
>> > have very different characteristics.
>>
>> How are they different after the scancode is extracted from the
>> network packet? The scancode still needs to be passed to the input
>> system, go through a keymap, and end up on an evdev device.
>>
>> I would expect the code for extracting the scancode to live in the
>> networking stack, but after it is recovered the networking code would
>> use the same API as IR to submit it to input.
>
> For one thing,  bluetooth (etc) has concept of devices (and reliable
> transfer). If you have two same bluetooth remotes, you can tell them
> apart, unlike IR.

IR has the same concept of devices. That's what those codes you enter
into a universal remote do - they set the device.

There are three classes of remotes..
Fixed function - the device is hardwired
Universal - you can change the device
Multi-function - a universal that can be multiple devices - TV, cable,
audio, etc

If you set two Bluetooth remotes both to the same device you can't
tell them apart either.
Two identical fixed function remotes can be distinguished and they
shouldn't be distinguishable.

To distinguish between universal remotes just change the device being emulated.


>
> So yes, keymapping is the same, but that's pretty much it. Decoding
> will not be the same (IR is special), etc...
>                                                                        Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Jon Smirl
jonsmirl@gmail.com

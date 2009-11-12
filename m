Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbZKLBIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbZKLBIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 20:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbZKLBIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 20:08:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48586 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZKLBIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 20:08:11 -0500
Message-ID: <4AFB5E43.5070901@zytor.com>
Date: Wed, 11 Nov 2009 17:00:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Daniel Pittman <daniel@rimspace.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
       Willy Tarreau <w@1wt.eu>, Pavel Machek <pavel@ucw.cz>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF4526B.4060101@zytor.com>	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>	<20091108173708.GF1372@ucw.cz>	<40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>	<20091108181016.GB32364@elf.ucw.cz>	<alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>	<20091108193618.GB4186@elf.ucw.cz>	<40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>	<20091108195158.GD4186@elf.ucw.cz>	<20091108200852.7f2cf092@lxorguk.ukuu.org.uk>	<20091110052711.GA15338@1wt.eu> <4AF9020C.90108@zytor.com>	<4AF9435F.2070103@redhat.com>	<20091110105642.215804e0@lxorguk.ukuu.org.uk>	<4AF99E04.8080704@zytor.com>	<20091110172454.3c4481f2@lxorguk.ukuu.org.uk>	<4AF9B5AB.5010800@zytor.com> <87zl6sva38.fsf@rimspace.net>
In-Reply-To: <87zl6sva38.fsf@rimspace.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 04:51 PM, Daniel Pittman wrote:
>>
>> Consider SSE3, for example.  Why should the same concept not apply to
>> SSE3 instructions as to CMOV?
> 
> FWIW, the issue of the binary-only flashplayer.so came up later in the thread,
> but to add my few cents:
> 
> When flash 10 was released the binary only 64-bit version generated
> instructions from the LAHF set unconditionally, in part because Windows chose
> to emulate those on the very few x86-64 platforms that didn't do them in
> hardware.
> 
> At that time it would have been very nice from a "user support" point of view
> to be able to add LAHF emulation to support the software.  Yes, it is ugly,
> binary-only code, but it is reasonably popular...
> 
> ...in the end, in fact, popular enough to have at least a couple of people
> I know purchase a new CPU that did implement it, just for flash on Linux.

The main use case for emulation is indeed to support binary-only or
otherwise precompiled software that exposes holes in the instruction
set.  As such, emulation can also be used to "raise the baseline", which
can be a highly desirable thing to do.

My point in all of this is that this is not a static problem, and that
if we're going to do emulation we need to consider the requirements
going forward.  I would *prefer* to have only one interpreter to deal
with when it's broken, and I certainly trust Avi & co to do the right
thing, but I'm certainly willing to entertain technical reasons why it
is not the right thing to do -- *not just now but in the future*.  The
latter is an absolutely critical constraint, though.

Once we have a general enough interpreter framework, we can add new
instructions as needed; it should make it a lot easier to phase in new
instructions while not breaking old legacy machines.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYLGSWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYLGSWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYLGSWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:22:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:6806 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbYLGSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:22:44 -0500
Message-ID: <ac3eb2510812071022le85080aiea301609fa8a50b1@mail.gmail.com>
Date: Sun, 7 Dec 2008 19:22:41 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
In-Reply-To: <20081207175118.09c633e8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	 <20081207155507.GA15355@gondor.apana.org.au>
	 <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	 <20081207160921.693f637a@lxorguk.ukuu.org.uk>
	 <20081207163151.GA31838@ioremap.net>
	 <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	 <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070939h17ef6316hea96fe89f01207a6@mail.gmail.com>
	 <20081207175118.09c633e8@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2008 at 18:51, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sun, 7 Dec 2008 18:39:48 +0100
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
>
>> On Sun, Dec 7, 2008 at 18:28, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >> > /dev/console is a logical mapping to a device which may well be
>> >> > different, loaded after PCI is initialised and dependant on PCI.
>> >>
>> >> So wrong. If no driver is associated, like early, in that case, we
>> >> must return -ENODEV, instead of calling modprobe in a loop. It's a
>> >> built-in device, and it's easy to fix.
>> >
>> > You've clearly no idea how initrd even works have you ?
>>
>> Not sure, if you understand the real problem. A kernel forked binary
>> is allowed to access /dev/console, but it triggers a kernel bug.
>
> If there is a hotplug load for the console device then it cannot. Just as
> a request for the driver for /dev/hda cannot open /dev/hda* again.

So wrong. Modprobe 5:1 will never load anything, but kill the box in
such case at that time of bootup.

>> Nonsense. The kernel calls /sbin/modprobe directly, no hotplug involved.
>
> Its up to you if the kernel calls modprobe and what your modprobe is

What are you saying? Your picture of hotplug is just wrong, regardless
of "it's up to you". I talk about what people use, and what is
obviously broken currently.

>> The kernel calls modprobe for something, modprobe tries to log an
>> error, and the kernel calls modprobe again. Bug! No hotplug involved.
>
> A modprobe to load the console device shouln't open /dev/console. Very
> simple and always been true.

We are _not_ loading a console driver that way, we try to load the
console device itself, not the driver. There is no driver for 5:1 in
any module.

>> >                                Kernel issues hotplug message
>> >                                .....
>> >                                Kernel detects this is stuck
>> >                                Kernel replies with -ENODEV/-ENXIO to try
>> > and rescue itself from buggy initrd scripts
>>
>> Totally wrong, It never was that way
>
> Funny but its been that way for many many years. Just as it cannot try and
> syslog an error when loading the AF_UNIX socket family.

And? Keep on the subject please. It's still a bug to run in a loop
trying something that will _never_ exist.

Kay

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbZDGW0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbZDGW0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbZDGWZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:25:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46380 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601AbZDGWZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:25:54 -0400
Message-ID: <49DBD2E6.1060702@garzik.org>
Date: Tue, 07 Apr 2009 18:25:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Robin Getz <rgetz@blackfin.uclinux.org>
CC: Sven-Haegar Koch <haegar@sdinet.de>, Matt Mackall <mpm@selenic.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Peterson <cpeterso@cpeterso.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <alpine.DEB.2.00.0904070003470.6968@aurora.sdinet.de> <49DA91C2.1020106@garzik.org> <200904071758.50823.rgetz@blackfin.uclinux.org>
In-Reply-To: <200904071758.50823.rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz wrote:
> On Mon 6 Apr 2009 19:35, Jeff Garzik pondered:
>> Sven-Haegar Koch wrote:
>>> On Mon, 6 Apr 2009, Matt Mackall wrote:
>>>
>>>> On Mon, 2009-04-06 at 14:30 -0400, Robin Getz wrote:
>>>>> We have lots of embedded headless systems (no keyboard/mouse, no
>>>>> soundcard, no video) systems with *no* sources of entropy - and people
>>>>> using SSL. 
>>>> I'd rather add a random_sample_network call somewhere reasonably central
>>>> in the network stack. Then we can use the knowledge that the sample is
>>>> network-connected in the random core to decide how to measure its
>>>> entropy. The trouble with IRQF_SAMPLE_RANDOM is that many of its users
>>>> are technically bogus as entropy sources in the current model.
>>>>
>>>> I'm eventually going to move the RNG away from the strict theoretical
>>>> entropy accounting model to a more pragmatic one which will be much
>>>> happier with iffy entropy sources, but that's a ways off.
>>> Btw, perhaps not the perfect question in this thread:
>>> But what should we use to keep servers running without a hardware rng 
>>> available and without any external input besides the network?
>>> After having ssh and openvpn die because of no random and having 
>>> the machines like dead and unreachable for me I use "ln -sf 
>>> /dev/urandom /dev/random", but that does not feel so good.
>> We see this question every time IRQF_SAMPLE_RANDOM is discussed.
>>
>> There is plenty of entropy data available, you just have to look 
>> around...  Google around for "EGD", video entropy daemon, audio entropy 
>> daemon, etc...
>>
>> Even headless servers have entropy sources if you look hard enough.
> 
> The original question wasn't headless servers - it was headless, no audio, no 
> video, boot from flash, (initrd root file systems), diskless. embedded 
> devices.
> 
> And few want to load up perl on an embedded device just to gather entropy. :(

Get a list of <special files> from EGD, and

	cat <special files> | sha1sum

then...

The basic point is that you can find entropy, even in a guest VM.

	Jeff



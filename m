Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZKJTvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZKJTvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbZKJTvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:51:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918AbZKJTvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:51:07 -0500
Message-ID: <4AF9C3EF.6000705@redhat.com>
Date: Tue, 10 Nov 2009 21:50:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Willy Tarreau <w@1wt.eu>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF4526B.4060101@zytor.com>	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>	<20091108173708.GF1372@ucw.cz>	<40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>	<20091108181016.GB32364@elf.ucw.cz>	<alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>	<20091108193618.GB4186@elf.ucw.cz>	<40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>	<20091108195158.GD4186@elf.ucw.cz>	<20091108200852.7f2cf092@lxorguk.ukuu.org.uk>	<20091110052711.GA15338@1wt.eu>	<4AF9020C.90108@zytor.com>	<4AF9435F.2070103@redhat.com>	<20091110105642.215804e0@lxorguk.ukuu.org.uk>	<4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com>
In-Reply-To: <4AF9B5AB.5010800@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 08:49 PM, H. Peter Anvin wrote:
>
>> Why is using KVM doing it right ? It sounds like its doing it slowly,
>> and hideously memory inefficiently. You are solving an uninteresting
>> general case problem when you just need two tiny fixups (or perhaps 3 if
>> you want to fix up early x86-64 prefetch)
>>      
> Why do we only need "two tiny fixups"?  Where do we draw the line in
> terms of ISA compatibility?  One could easily argue that the Right
> Thing[TM] is to be able to process any optional instruction -- otherwise
> one has a very difficult place to draw a line.
>
> Consider SSE3, for example.  Why should the same concept not apply to
> SSE3 instructions as to CMOV?
>    

Because then user programs would run 20x or more slower than the user 
expects.  Better to terminate early (and teach userspace how to choose 
the instruction subset correctly).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


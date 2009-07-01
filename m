Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZGAVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZGAVWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZGAVWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:22:13 -0400
Received: from mail.anarazel.de ([217.115.131.40]:57298 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbZGAVWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:22:13 -0400
Message-ID: <4A4BD384.3090407@anarazel.de>
Date: Wed, 01 Jul 2009 23:22:12 +0200
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090629 Shredder/3.0b3pre
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (possibly caused
    by netem)
References: <4A4A9DD6.8060800@anarazel.de> <4A4BAD5F.7050908@gmail.com>
In-Reply-To: <4A4BAD5F.7050908@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/01/2009 08:39 PM, Jarek Poplawski wrote:
> Andres Freund wrote, On 07/01/2009 01:20 AM:
>> While playing around with netem (time, not packet count based loss-
>> bursts) I experienced soft lockups several times - to exclude it was my
>> modifications causing this I recompiled with the original and it is
>> still locking up.
>> I captured several of those traces via the thankfully
>> still working netconsole.
>> The simplest policy I could reproduce the error with was:
>> tc qdisc add dev eth0 root handle 1: netem delay 10ms loss 0
>>
>> I could not reproduce the error without delay - but that may only be a
>> timing issue, as the host I was mainly transferring data to was on a
>> local network.
>> I could not reproduce the issue on lo.
>>
>> The time to reproduce the error varied from seconds after executing tc
>> to several minutes.
>>
>> Traces 5+6 are made with vanilla 52989765629e7d182b4f146050ebba0abf2cb0b7
>>
>> The earlier traces are made with parts of my patches applied, and only
>> included for completeness as I don't believe my modifications were
>> causing this and all traces are different, so it may give some clues.
>>
>> Lockdep was enabled but did not diagnose anything relevant (one dvb
>> warning during bootup).
>>
>> Any ideas for debugging?
>
> Maybe these traces will be enough, but lockdep report could save time.
> If dvb warning triggers every time then lockdep probably turns off
> just after (it works this way, unless something was changed). So,
> could you try to repeat this without dvb? Btw., did you try this on
> some earlier kernel?
Yes. Today I could not manage to reproduce it on 2.6.30 but could on 
current git...

I *think* I could also provoke the same issue on lo, but I am not 
completely sure, as the host I was redirecting netconsole to 
unfortunately was not up, so I could not check if it was a similar trace.
It could also have been triggered by some random traffic on eth0... Hard 
to say.

Will try without dvb.

Andres

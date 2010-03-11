Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab0CKNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:25:56 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51953 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0CKNZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eeXJP1Fbhi9t5u7H5nt8mCvFIRR64FgskA0MBok6A70IwaXQ2HRa6ob0uhCpvfcQun
         n0ilO5ti0Qz7q4vooiw0Yr/00XJzFD6NYQK0w0faMBgsnPIZTacwm5l4cNSrKAmSew0z
         j7qQ74QoCM5UFPCvoUdJPqoW/d9lJuSFqtsCM=
Message-ID: <4B98EF5D.5000609@warmcat.com>
Date: Thu, 11 Mar 2010 13:25:49 +0000
From: Andy Green <andy@warmcat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc14 Thunderbird/3.0.3
MIME-Version: 1.0
To: Cyril Hrubis <metan@ucw.cz>
CC: Pavel Machek <pavel@ucw.cz>, Eric Miao <eric.y.miao@gmail.com>,
       dbaryshkov@gmail.com, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       utx@penguin.cz, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: bit errors on spitz
References: <20100305212708.GC21773@elf.ucw.cz>	<f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>	<20100308072858.GA29939@atrey.karlin.mff.cuni.cz> <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/10 08:25, Somebody in the thread at some point said:
> Hi!
>> dmesg would not be useful, it usually hits user programs. Like... mutt
>> suddenly displaying , instead of - in the header. Program failing to
>> start because function printg is not found (it was not exactly
>> printf->printg,  I don't remember exact symbol), ping complaining
>> about discarding corrupted packets, etc.
>>
>> (Or of course, kernel oopsing or not going from suspend at all. But as
>> even user data are being corrupted, oops is not likely to be
>> interesting and system is typically not in state to capture it any more.)
>>
>
> Well I've seen empty lines when editing file with vim (these that are starting
> with blue tilda) in the middle of file. And sometimes programs segfaults for no
> good reason. Just today I've run "apt-get update" and got:
>
> symbol lookup error: apt-get: undefined symbol: _ZN16pkgAcquireStatus4StopEv
>
> While the correct symbol seems to be _ZN16pkgAcquireStatus4.
>
> When running 'make' in kernel directory and closing the display sometimes
> machine dies and nothing but reset under battery cover helps. I remeber waking
> up in the morning, opening the device and reseting the device. And it seems to
> be provoked much more by active CF wifi card.

I saw very similar failures for a long time on our iMX31 based device. 
Eventually I found a Freescale errata where the RAM inside the USB2 
macrocell started to make single bit errors below 1.38V Vcore; ours was 
1.4V at that time but dipped on CPU load.

I cranked up the Vcore to 1.6V and that solved it, we also added some 
ceramic caps to Vcore to help with the dips.

So it might be worth looking at PMU arrangements for Vcore level / look 
for dips with a 'scope (despite this isn't an iMX31).

A characteristic of it was it never caused kernel issues, since the 
kernel didn't come over USB.  It only ever caused troubles on userspace 
stuff.

-Andy


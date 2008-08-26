Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbYHZKZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbYHZKZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYHZKZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:25:27 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:3464 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYHZKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Ojc3HgK8tDCSLxG6zyW0XP598OxkyoFHRotWv5jZhKecLgwGPvtP/EBHjYPMKme3JU
         yk11bsguQOFyJIgbzDbvrU9y/J2blWFYCziJEe0g96iY3wjhZ7uOpr9C9S+7C7Xub0Ld
         y8yelMSqP6j52mVMep1zid8aU1Lm2SNGvg2Zw=
Message-ID: <48B3DA02.9080002@tuffmail.co.uk>
Date: Tue, 26 Aug 2008 11:25:06 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [BUG] get_rtc_time() triggers NMI watchdog in hpet_rtc_interrupt()
References: <200808230948.m7N9mUc1016360@harpo.it.uu.se>	 <19f34abd0808240214o22748804s45e8487d62b34cb8@mail.gmail.com>	 <18609.14516.873317.52292@harpo.it.uu.se> <19f34abd0808240448w5facaee2gec77662c14b9364f@mail.gmail.com>
In-Reply-To: <19f34abd0808240448w5facaee2gec77662c14b9364f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Sun, Aug 24, 2008 at 12:32 PM, Mikael Pettersson <mikpe@it.uu.se> wrote:
>   
>>  > I also just got this during shutdown:
>>  >
>>  > Syncing hardware clock to system time BUG: NMI Watchdog detected
>>  > LOCKUP on CPU0, ip c011d922, registers:
>>  > Pid: 4181, comm: hwclock Not tainted (2.6.27-rc3-00464-g1fca254-dirty #42)
>>     
> [...]
>
>   
>> See my reply in the thread following Ingo's patch
>> <http://lkml.org/lkml/2008/8/23/158>. I've only seen the lockup
>> while hwclock was setting or flushing the system time, so I suspect
>> broken interaction between the hpet rtc emulation and the rtc
>> user-space interface.
>>     
>
> Oops, I picked the wrong thread :-)
>
> Anyway, I guess it wouldn't be too hard to make a test cast by running
> "hwclock" (or the corresponding initscript) in a tight loop? (Sorry, I
> am not able to test this myself at the moment). That would make it
> easier to test the patch too, I guess. Maybe something like:
>
>     $ while true; do /etc/init.d/ntpdate up; /etc/init.d/ntpdate down; done
>
> (At least "ntpdate" is the one that runs hwclock for me on F9.)
>
> I will try this later unless you beat me to it :-)
>
>   
I beat you :-).  I noticed the problem myself.  It does trigger if I run
hwclock in a loop.

while true; do hwclock; done

However it is fine in latest git.  Looks like Ingo's patch has been
merged, and has fixed it.

Alan

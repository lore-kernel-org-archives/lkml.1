Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXFLGoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXFLGoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 02:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbXFLGoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 02:44:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:56972 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbXFLGoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 02:44:16 -0400
Message-ID: <466E40BD.8080001@qumranet.com>
Date: Tue, 12 Jun 2007 09:44:13 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Luca <kronos.it@gmail.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [BUG] Oops with KVM-27
References: <20070603213432.GA3075@dreamland.darkstar.lan>	 <4663DCE9.3000107@qumranet.com>	 <20070604202248.GA18668@dreamland.darkstar.lan>	 <46647B3E.2090205@qumranet.com>	 <20070604212207.GA22365@dreamland.darkstar.lan>	 <46651069.5040003@qumranet.com>	 <68676e00706071216i4bd051c5hb1c114f3c13ab97f@mail.gmail.com>	 <466BED18.5040708@qumranet.com>	 <68676e00706101354n5fe7e1a9y12cb690cae2924e3@mail.gmail.com>	 <466CFD6D.2080201@qumranet.com> <68676e00706111406r16eafd0eseaf1fb24f5c0d075@mail.gmail.com>
In-Reply-To: <68676e00706111406r16eafd0eseaf1fb24f5c0d075@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 12 Jun 2007 09:44:13 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luca wrote:
> On 6/11/07, Avi Kivity <avi@qumranet.com> wrote:
>> Luca wrote:
>> >>
>> >> I've managed to reproduce this on kvm-21 (it takes many boots for
>> this
>> >> to happen, but it does eventually).
>> >
>> > Hum, any clue on the cause?
>>
>>  From what I've seen, it's the new Linux clocksource code.
>
> Actually I tried forcing the PIT (and any other combination of
> tsc,acpi_pm,jiffies) as the clocksource, without success.
>

Well, there's lots of APIC stuff going on when it hangs.

>> > Should I test older versions?
>>
>> They're unlikely to be better.  Instead, it would be best to see what
>> the guest is doing.
>>
>> I suggest downloading the source rpm for the kernel, building it, and
>> sprinkling printk()s until we know exactly what source the guest is
>> executing at the time of the hang.
>
> Ok, will do. Meanwhile I discovered that the kernel on the boot cd
> (the one that hangs) is compiled for i586, while the one installed on
> disk is for i686 (this one works).

Ah.

>
> i686 has this options enabled:
>
> +CONFIG_X86_GOOD_APIC=y
> +CONFIG_X86_USE_PPRO_CHECKSUM=y
> +CONFIG_X86_TSC=y
>
> but disabling tsc on the command line doesn't make any difference. Is
> it possible that KVM is choking on some instruction not used by the
> i686 kernel?

Unlikely, as then the hang would occur all the time instead of randomly.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


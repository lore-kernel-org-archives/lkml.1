Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303Ab0A1XzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0A1XzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043Ab0A1XzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:55:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:60484 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0A1XzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:55:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BL9qlfiPK347oS+lbvuBUYnks1Ocys/Xszn+mw9MBa89Xd7CIX0gg6iIoAbn0ftE96
         XffkyNGVdrnVIBEB5/RqCtupvlm/rpJlgyju5B5U9n1jG41C0xTDWxjLRyyq/tiB9neX
         CY5Lxfct99RjRA+04JAl4JzE/rYOKAeq8J8+k=
MIME-Version: 1.0
In-Reply-To: <c2673ca61001260607v5fe6c13ai54d10100088382f6@mail.gmail.com>
References: <bug-15076-6666@http.bugzilla.kernel.org/>
	 <201001221017.o0MAHQmu015858@demeter.kernel.org>
	 <alpine.LFD.2.00.1001250831110.2906@localhost.localdomain>
	 <c2673ca61001250333p33305d3fma638d73c0d448e17@mail.gmail.com>
	 <c2673ca61001260607v5fe6c13ai54d10100088382f6@mail.gmail.com>
Date: Fri, 29 Jan 2010 00:55:05 +0100
Message-ID: <c2673ca61001281555l79b755f4r480dabc1be63f881@mail.gmail.com>
Subject: Re: [Bug 15076] System panic under load with clockevents_program_event
From: okias <d.okias@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org,
       x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm afraid it freezed even without HIGHMEM. I left computer run
(compilation KDE 4.3.95) and when I come back, lcd was in dpms mode
and led was blinking. So it look like same problem. Maybe without
HIGHMEM it takes longer until problem appear.

2010/1/26, okias <d.okias@gmail.com>:
> Lastest git without HIGHMEM look good. If no problems occur, then I
> try use kernel with HIGHMEM and see what change...
>
> 2010/1/25, okias <d.okias@gmail.com>:
>> Okey, I try without highmem soon.
>>
>> 2010/1/25, Thomas Gleixner <tglx@linutronix.de>:
>>> Switched to email. Please reply to all instead of using the bugzilla
>>> interface.
>>>
>>>> --- Comment #4 from okias <d.okias@gmail.com>  2010-01-22 10:17:25 ---
>>>> and it's regression. Now I work on 2.6.32.3 and no problem.
>>>
>>> That's a really weird one. The system is 50 min up and running and out
>>> of the blue it crashes in clockevents_program_event(). This function
>>> has been called a couple of thousand times before that point.
>>>
>>> The only way to crash there is when *dev is pointing into nirwana. dev
>>> comes from
>>>
>>> int tick_program_event(ktime_t expires, int force)
>>> {
>>>         struct clock_event_device *dev =
>>> __get_cpu_var(tick_cpu_device).evtdev;
>>>
>>> according to the callchain. At this point nothing fiddles with
>>> tick_cpu_device.evtdev, so I suspect some really nasty memory
>>> corruption going on.
>>>
>>> okias, can you please disable highmem support and verify whether the
>>> problem persists ?
>>>
>>> Thanks,
>>>
>>> 	tglx
>>>
>>
>>
>> --
>> Jabber/XMPP: okias@isgeek.info
>> SIP VoIP: sip:17474537254@proxy01.sipphone.com
>>
>
>
> --
> Jabber/XMPP: okias@isgeek.info
> SIP VoIP: sip:17474537254@proxy01.sipphone.com
>


-- 
Jabber/XMPP: okias@isgeek.info
SIP VoIP: sip:17474537254@proxy01.sipphone.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbZAYXwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbZAYXwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 18:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZAYXv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 18:51:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:61391 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZAYXv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 18:51:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QuYP+lHVnWNMQjdCLH3np4stShBnTzK06ol1WzGmcF6BCq4cvnXVhdQy1u+TKPo7PW
         FHyCl8IlsO8HwHNsJ3VyVQnKAZGaBoCx01ExdoOCR+3lj6SFQ+wUxXt+zMjAFV44KUAD
         kkskYmzWcX0LCX+5RNGe4pp56QhKhCKw0jP7s=
MIME-Version: 1.0
In-Reply-To: <20656.1231267329@turing-police.cc.vt.edu>
References: <c4e36d110901060500w289708d5ne252ace7a2fd9944@mail.gmail.com>
	 <20656.1231267329@turing-police.cc.vt.edu>
Date: Mon, 26 Jan 2009 00:51:54 +0100
Message-ID: <19f34abd0901251551j17231d82n306d2d5bfb26072a@mail.gmail.com>
Subject: Re: MCE error log
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 7:42 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Tue, 06 Jan 2009 14:00:03 +0100, Zdenek Kabelac said:
>
>> CPU 1 BANK 128 TSC 57976afd
>
>> I could only see  bank0ctl ... bank5ctl - so where is bank 128 ?
>
> I've had bank 128 reported before. Turned out it was for thermal events caused
> by dust bunnies clogging a cooling vent.  I never did find an official
> statement that's what 128 is for, but I did find a bunch of hints....
>
> What does lm_sensors say the CPU temp is sitting at?

I get this also:

MCE 0
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 1 THERMAL EVENT TSC dc963a087
Processor core below trip temperature. Throttling disabled
STATUS 882c0100 MCGSTATUS 0
MCE 1
HARDWARE ERROR. This is *NOT* a software problem!
Please contact your hardware vendor
CPU 0 THERMAL EVENT TSC dc970c0d0
Processor core below trip temperature. Throttling disabled
STATUS 882d0200 MCGSTATUS 0

and in kernel log:

Machine check events logged
CPU0: Temperature/speed normal
CPU1: Temperature/speed normal

This is happening since I installed a x86_64 kernel instead of 32-bit.
Maybe this explains those weird (never fatal) APIC errors I always
used to get before (error 40, invalid vector received AFAIR)? In any
case, the APIC errors are not to be seen now, and the frequency of the
MCEs are about that of the APIC errors. What I can say is that it
seems they appear sooner when there is a lot of interrupts, e.g. disk
or network activity. What is the correlation?

Temperature seems completely normal whenever it happens:

# sensors
coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +58.0°C  (high = +100.0°C, crit = +100.0°C)

coretemp-isa-0001
Adapter: ISA adapter
Core 1:      +59.0°C  (high = +100.0°C, crit = +100.0°C)

Anyway, system works fine, so it's not much to worry about. But I am curious...


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

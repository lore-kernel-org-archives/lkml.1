Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXCQQpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXCQQpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 12:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXCQQpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 12:45:30 -0400
Received: from www.osadl.org ([213.239.205.134]:49760 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751286AbXCQQp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 12:45:29 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Len Brown <lenb@kernel.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1174125404.13341.396.camel@localhost.localdomain>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <200703162132.53906.lenb@kernel.org>
	 <1174125404.13341.396.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 17:52:23 +0100
Message-Id: <1174150344.13341.430.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 10:56 +0100, Thomas Gleixner wrote:
> > Maybe I could follow the new logic in apic.c if I saw the "apic=debug"
> > output for this box.
> 
> calibrating APIC timer ...
> ... lapic delta = 2426884
> ... PM timer delta = 833908
> APIC calibration PIT not consistent with PM Timer: 232ms instead of 100ms
> APIC delta adjusted to PM-Timer: 1041737 (2426884)
> ..... delta 1041737
> ..... mult: 44749065
> ..... calibration result: 166677
> ..... CPU clock speed is 4659.0624 MHz.
> ..... host bus clock speed is 166.0677 MHz.
> 
> This box is off by factor 2.3 and using the PM-Timer instead of the
> PIT/jiffies values gives me a correct result.

I instrumented the lapic calibration on this box:

I1:     999 us total:    999 us
I2:     999 us total:   1998 us
...
I28:    999 us total:  27980 us
I29: 135097 us total: 163077 us  <--------------------
I30:    881 us total: 163958 us
...
I98:   1000 us total: 231918 us
I99:    999 us total: 232917 us

So it vanishes away for 132 ms, which is exactly the error above. This
happens in random places and sometimes I'm lucky that it does not happen
at all.

	tglx



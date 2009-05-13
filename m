Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbZEMWao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbZEMWao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761901AbZEMWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:30:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46790 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761761AbZEMWa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:30:27 -0400
Message-ID: <4A0B49C4.4000502@garzik.org>
Date: Wed, 13 May 2009 18:29:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       tglx@linutronix.de, rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	<20090421.173123.191021055.davem@davemloft.net>	<adak55438gp.fsf_-_@cisco.com>	<20090428.221228.217954247.davem@davemloft.net>	<20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	<adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org>	<a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com>	<4A0B30D0.4060806@garzik.org> <ada8wl0iro4.fsf@cisco.com>
In-Reply-To: <ada8wl0iro4.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > To repeat what has already been stated, each case was re-evaluated:
>  > http://marc.info/?l=linux-kernel&m=124103527326835&w=2
>  > 
>  > Roland's patch was acked, apparently, _in spite of_ the commonly
>  > accepted readq() definition already being in use!
>  > 
>  > Thusfar, I see two things:
>  > 
>  > (1) years of history has shown that non-atomic readq/writeq on 32-bit
>  > platforms has been sufficient, based on testing and experience.  In
>  > fact, in niu's case, a common readq/writeq would have PREVENTED a bug.
> 
> But the fact that the 32-bit x86 define would have worked for niu is
> pure luck -- if the clear-on-read bits had been in the other half of the
> register in question, then it would have caused a bug.  And I really
> don't trust all ASIC designers writing RTL to think about which half of
> a 64-bit register is going to be read first.

AFAICS things have unerringly occurred in PCI ordering, which is what 
one would expect.

What you call pure luck, others call 100% track record.


> To me, the point is that the current situation of having the defines for
> 32-bit x86 has zero benefit -- not one driver-specific definition can be
> removed, because there are other 32-bit architectures to worry about.

Um, this is precisely what Mitake-san is trying to address, hence the 
discussion...


> And the risk introduced is not zero -- very few devices have 64-bit
> registers and very few drivers use readq or writeq, but perhaps as
> end-to-end 64-bit buses become more prevalent with PCIe, we may see
> more.  And it's certainly the case that emulation 64-bit register
> operations by doing to 32-bit operations on the register halves carries
> a non-zero risk of making the hardware do something wacky.

Again, fear vs. reality, 0% case versus 100% case.

You continue to lack CONCRETE examples of problems, while existing cases 
CONTINUE to work with the obvious ordering.

	Jeff




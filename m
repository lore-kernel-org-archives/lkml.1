Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYKJVfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYKJVfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYKJVfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:35:12 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48995 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbYKJVfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:35:09 -0500
Message-Id: <1226352907.25721.1284024167@webmail.messagingengine.com>
X-Sasl-Enc: oFHf5wpXygbMeeXhEr1QwWT8EIKehihnXVaRTQ22BZ1h 1226352907
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Mike Travis" <travis@sgi.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081104122839.GA22864@mailshack.com> 
 <20081104150729.GC21470@localhost> 
 <20081104170501.GE29626@one.firstfloor.org> 
 <1225822006.21441.1282961299@webmail.messagingengine.com> 
 <20081104204400.GC10825@elte.hu> 
 <1226243805.27361.1283784629@webmail.messagingengine.com> 
 <20081110085846.GG22392@elte.hu> 
 <1226321061.23701.1283927805@webmail.messagingengine.com> 
 <20081110130709.GA32613@elte.hu>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <20081110130709.GA32613@elte.hu>
Date: Mon, 10 Nov 2008 22:35:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 14:07:09 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > On Mon, 10 Nov 2008 09:58:46 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> > > * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > > > Hi all,
> > > > 
> > > > I have spent some time trying to find out how expensive the 
> > > > segment-switching patch was. I have only one computer available at 
> > > > the time: a "Sempron 2400+", 32-bit-only machine.
> > > > 
> > > > Measured were timings of "hackbench 10" in a loop. The average was 
> > > > taken of more than 100 runs. Timings were done for two seperate 
> > > > boots of the system.
> > 
> > Hi Ingo,
> > 
> > I guess you just stopped reading here?
> 
> yeah, sorry! You describe and did exactly the kind of histogram that i 
> wanted to see done ;-)

I thought so ;).

> I'm not sure i can read out the same thing from the result though. 
> Firstly, it seems the 'after' histograms are better, because there the 
> histogram shifted towards shorter delays. (i.e. lower effective irq 
> entry overhead)
> 
> OTOH, unless i'm misreading them, it's a bit hard to compare them 
> visually: the integral of the histograms does not seem to be constant, 
> they dont seem to be normalized.

The total number of measured intervals (between two almost-adjacent
rdtsc's) is exactly the same for all histograms (10^10). Almost all
measurements are of the "nothing happened" type, i.e., around 11
clock cycles on this machine. The user time spent inside the
rdtsctest program is almost independent of the load, but it
measures time spent outside of the program... But what should be
attributed to what effect is unclear to me at the moment.

> It should be made constant for them to be comparable. (i.e. the total 
> number of irq hits profiled should be equal - or should be normalized 
> with the sum after the fact)

Basically the difference between the "idle" and "hack10" versions
should indicate the effect of extra interrupts (timer) and additional
exceptions and cache effects due to context switching.

Thanks,
    Alexander

> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - I mean, what is it about a decent email service?


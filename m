Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYKNDYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYKNDYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYKNDYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:24:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYKNDYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:24:16 -0500
Message-ID: <491CEEF0.4030001@zytor.com>
Date: Thu, 13 Nov 2008 19:22:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Alexander van Heukelum <heukelum@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com>	 <20081104150729.GC21470@localhost>	 <20081104170501.GE29626@one.firstfloor.org>	 <1225822006.21441.1282961299@webmail.messagingengine.com>	 <20081104204400.GC10825@elte.hu>	 <1226243805.27361.1283784629@webmail.messagingengine.com>	 <20081110085846.GG22392@elte.hu>	 <1226321061.23701.1283927805@webmail.messagingengine.com>	 <20081110130709.GA32613@elte.hu>	 <1226352907.25721.1284024167@webmail.messagingengine.com>	 <49191185.2000102@zytor.com> <1226615039.3343.53.camel@calx>	 <491CD1DD.3020201@zytor.com> <1226629776.3343.84.camel@calx>
In-Reply-To: <1226629776.3343.84.camel@calx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
>>>
>> No, they reflect individual runs.  They start at 1 at the top left and
>> drop to 0 at the far right in each case.  What matters is the horizontal
>> position of large vertical drops.
> 
> Still confused. If, say, the top blue line on the left represents the
> same number of interrupts as the bottom red one, then at some point it
> must cross under the red one as it goes to the right, which it does not
> appear to do. Thus, it does not appear the scale on the left is actually
> in units of constant probability, no?
> 
> Though I'll agree that even if they're not scaled so that the area under
> the curve sums to a probability of 1, the centerpoint of the vertical
> drop is what matters. But that's rather hard to read off this chart, as
> the blue line I mentioned has a center point point well above the red
> one, so while it looks like a shift of 80 cycles, it's more like 30.
> 
> Is there any theoretical reason you can't just sum the histograms for
> runs of the same code and then divide by event count? Is there some sort
> of alignment/cache-coloring issue across boots?
> 

The reason for the multiple curves is to show the range of uncertainty.

There are three sets of graphs in there: black (current mainline,
16-byte stubs), red (4-byte stubs with a double jump), and blue (8-byte
stubs.)

The fact that the system is idle is pretty much a case which should
favor "blue" over "red"; realistically I think the graphs show that they
are identical within the limits of measurement, and both are
significantly better than "black".

Since this is pretty much the optimal case for "blue" and it doesn't
show any performance win over "red", I implemented the "red" option and
pushed it into tip:x86/irq.

> That's what I'd expect on an idle system, certainly.
> 
> Anyway, I'm actually surprised your red graph is visibly better than
> your blue one. FWIW, I was leaning towards your simpler variant (and
> away from the magical segment register proposal). I'd be happy to see
> either of your versions submitted.

Same here, which is why I wanted to check them both out.

	-hpa

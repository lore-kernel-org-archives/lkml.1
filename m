Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYKNBVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYKNBVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYKNBVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:21:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYKNBVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:21:23 -0500
Message-ID: <491CD1DD.3020201@zytor.com>
Date: Thu, 13 Nov 2008 17:18:21 -0800
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
References: <20081104122839.GA22864@mailshack.com>	 <20081104150729.GC21470@localhost>	 <20081104170501.GE29626@one.firstfloor.org>	 <1225822006.21441.1282961299@webmail.messagingengine.com>	 <20081104204400.GC10825@elte.hu>	 <1226243805.27361.1283784629@webmail.messagingengine.com>	 <20081110085846.GG22392@elte.hu>	 <1226321061.23701.1283927805@webmail.messagingengine.com>	 <20081110130709.GA32613@elte.hu>	 <1226352907.25721.1284024167@webmail.messagingengine.com>	 <49191185.2000102@zytor.com> <1226615039.3343.53.camel@calx>
In-Reply-To: <1226615039.3343.53.camel@calx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2008-11-10 at 21:00 -0800, H. Peter Anvin wrote:
>> Okay, after spending most of the day trying to get something that isn't
>> completely like white noise (interesting problem, otherwise I'd have
>> given up long ago) I did, eventually, come up with something that looks
>> like it's significant.  I did a set of multiple runs, and am looking for
>> the "waterfall points" in the cumulative statistics.
>>
>> http://www.zytor.com/~hpa/baseline-hpa-3000-3600.pdf
>>
>> This particular set of data points was gathered on a 64-bit kernel, so I
>> didn't try the segment technique.
>>
>> It looks to me that the collection of red lines is enough to the left of
>> the black ones that one can assume there is a significant effect,
>> probably by about a cache miss worth of time.
> 
> This graph is a little confusing. Is the area under each curve here
> supposed to be a constant?
> 

No, they reflect individual runs.  They start at 1 at the top left and
drop to 0 at the far right in each case.  What matters is the horizontal
position of large vertical drops.

> Is this latency from all interrupts as seen by userspace? Or does a
> particular interrupt dominate?
> 

All interrupts, but rather inherently the difference between interrupt
handlers is going to be bigger than the differences between
implementations of the same handler.  I *believe* all the interrupts
you're seeing in that graph are probably timer interrupts.  The other
major interrupt source that was active on the system was USB.

	-hpa

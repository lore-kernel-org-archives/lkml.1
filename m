Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYKJWWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYKJWWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYKJWWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:22:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46797 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKJWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:22:08 -0500
Message-ID: <4918B3DC.8000905@zytor.com>
Date: Mon, 10 Nov 2008 14:21:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com>  <20081104150729.GC21470@localhost>  <20081104170501.GE29626@one.firstfloor.org>  <1225822006.21441.1282961299@webmail.messagingengine.com>  <20081104204400.GC10825@elte.hu>  <1226243805.27361.1283784629@webmail.messagingengine.com>  <20081110085846.GG22392@elte.hu>  <1226321061.23701.1283927805@webmail.messagingengine.com>  <20081110130709.GA32613@elte.hu> <1226352907.25721.1284024167@webmail.messagingengine.com>
In-Reply-To: <1226352907.25721.1284024167@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
>>
>> OTOH, unless i'm misreading them, it's a bit hard to compare them 
>> visually: the integral of the histograms does not seem to be constant, 
>> they dont seem to be normalized.
> 
> The total number of measured intervals (between two almost-adjacent
> rdtsc's) is exactly the same for all histograms (10^10). Almost all
> measurements are of the "nothing happened" type, i.e., around 11
> clock cycles on this machine. The user time spent inside the
> rdtsctest program is almost independent of the load, but it
> measures time spent outside of the program... But what should be
> attributed to what effect is unclear to me at the moment.
> 

I believe you need to remove the obvious null events at the low end (no
interrupt happened) and renormalize to the same scale for the histograms
to make sense.

As it is, the difference in the number of events that actually matters
dominate the graphs; for example, there are 142187 events >= 12 in
hack10ticks, but 136533 in hack10ticks_hpa.

	-hpa

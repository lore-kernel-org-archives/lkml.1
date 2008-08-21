Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYHUVCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYHUVCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHUVCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:02:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849AbYHUVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:02:13 -0400
Date: Thu, 21 Aug 2008 14:00:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
In-Reply-To: <20080821205045.GA24909@Krystal>
Message-ID: <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org>
 <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2008, Mathieu Desnoyers wrote:
>
> Given that I need to limit the number of readers to a smaller amount of 
> bits

I stopped reading right there.

Why?

Because that is already crap.

Go look at my code once more. Go look at how it has 128 bits of data, 
exactly so that it DOES NOT HAVE TO LIMIT THE NUMBER OF READERS.

And then go look at it again.

Look at it five times, and until you can understand that it still uses 
just a 32-bit word for the fast-path and no unnecessarily crap in it, but 
it actually has 128 bits of data for all the slow paths, don't bother 
emailing me any new versions.

Please. You -still- apparently haven't looked at it, at least not enough 
to understand the _point_ of it. You still go on about trying to fit in 
three or four different numbers in that one word. Even though the whole 
point of my rwlock is that you need exactly _one_ count (active writers), 
and _one_ bit (active reader) and _one_ extra bit ("contention, go to slow 
path, look at the other bits ONLY IN THE SLOW PATH!")

That leaves 30 bits for readers. If you still think you need to "limit the 
number of readers", then you aren't getting it.

		Linus

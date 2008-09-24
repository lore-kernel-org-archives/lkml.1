Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYIXWny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYIXWny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYIXWnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:43:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbYIXWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:43:44 -0400
Date: Wed, 24 Sep 2008 15:41:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809241458270.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809241534400.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org> <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
 <20080924205334.GB12248@Krystal> <alpine.LFD.1.10.0809241458270.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Linus Torvalds wrote:
> 
>  - case 1: TSCExtend marker
> 	data = extended TSC (bits 28..59)
> 	size = 8
> 
>  - case 2: TimeStamp marker
> 	data = tv_nsec
> 	array[0] = tv_sec
> 	size = 16

Btw, in case it wasn't clear, those two are totally different things.

The "case 1" thing is the thing that gets inserted automatically by the 
trace code when it's needed because the 27-bit TSC is too limited.

The "case 2" thing is to allow us to occasionally synchronize with some 
global known wall-time clock like the HPET + xtime. IOW, it would be 
something that on demand creates a mapping from wall clock to TSC for that 
particular CPU. 

I guess I should perhaps have put the TSC frequency in there in that "case 
2" thing too. Maybe that should be in "data" (in kHz) and tv_sec/tv_nsec 
should be in array[0..1], and the time sync packet would be 24 bytes.

			Linus

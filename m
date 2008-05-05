Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbYEEUtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbYEEUtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYEEUt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:49:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990AbYEEUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:49:26 -0400
Date: Mon, 5 May 2008 13:48:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Arjan van de Ven <arjan@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] default to n for GROUP_SCHED and FAIR_GROUP_SCHED
In-Reply-To: <20080505202729.GA1199@elte.hu>
Message-ID: <alpine.LFD.1.10.0805051337530.32269@woody.linux-foundation.org>
References: <82e4877d0805031742o464dd581wd93173d79705ce0d@mail.gmail.com> <20080504092417.GA3425@elte.hu> <82e4877d0805050814j721ae522k84384df48c9f4336@mail.gmail.com> <20080505171501.GA22332@elte.hu> <20080505182427.GA2025@uranus.ravnborg.org>
 <20080505184235.GD22332@elte.hu> <20080505125620.219c4bb6@infradead.org> <20080505202729.GA1199@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Ingo Molnar wrote:
> 
> yeah, that's what i meant mostly - to new drivers we unfortunately 
> default to 'n'. And most of the time (i hope!) our defaults for new core 
> kernel and architectural features otherwise make sense.

I doubt it.

People are *way* too eager to mark things 'y', because it may make sense 
as a default to the developer of the feature, never mind that the average 
user should never *ever* enable it.

There are even things that are clearly marked experimental (and depend on 
the EXPERIMENTAL config option), and then have the gall to say "default 
y".

Another example of that kind of behaviour, for example, is just you 
fighting turning off 'default y' from FAIR_GROUP_SCHED, considering that 
it is known to cause latency problems and the reason isn't understood.

Developers want their features to be enabled. Regardless of whether they 
are features that make sense to normal people.

I'd love to make "default y" be something you must never do (except for 
question that don't get asked at all!), but that would just cause people 
to create negative config options ("disable my cool feature?") which we 
already have to some degree, and which is *really* irritating.

			Linus

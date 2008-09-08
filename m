Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbYIHQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbYIHQdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYIHQda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:33:30 -0400
Received: from mail.lang.hm ([64.81.33.126]:60278 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYIHQda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:33:30 -0400
Date: Mon, 8 Sep 2008 09:34:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       linux@sandersweb.net, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809080925400.10413@asgard.lang.hm>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
 <20080908154535.GL26079@one.firstfloor.org> <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Linus Torvalds wrote:

> On Mon, 8 Sep 2008, H. Peter Anvin wrote:
>>
>> And yes, it should be the default.  The patch I have makes it
>> "default y" as well as change the help text.
>
> It sounds like it shouldn't be a default at all, it should just _always_
> be on, if there really are gcc's that care that much. Most of our
> optimizations have historically really been about _optimizing_, not about
> "it won't work", even if we have had exceptions (but as mentioned, I think
> those exceptions have been way more imporant than NOPL).
>
>> Would it make you happier if this option was forced enabled unless
>> CONFIG_EMBEDDED was on?
>
> Yes, putting it behind EMBEDDED will certainly fix the issue. Anybody who
> actually enables EMBEDDED and does all his choices by hand should no
> longer expect to not have to know _exactly_ what he is doing.
>
> So if it's behind EMBEDDED, and defaults to "on", then I have no problem
> with changing the help text to say "If you do this, we'll statically do
> things that really _require_ you to have a CPU that looks _exactly_ like
> the CPU you claimed".

I always understood the CPU selection to be "this CPU and ones compatible 
with it will work, others won't" unless generic was enabled. the fact that 
only a few CPU's wouldn't work and the rest was optimization is true, but 
the details of what chips would and wouldn't work were never that clear. 
The difference between a kernel compiled for generic and once compiled for 
a specific CPU can be very significant. (I ran into 30% differences back 
in the 2.4 days between generic and Athlon) This is why all the distros 
don't enable the generic cpu option on their kernels nowdays. I'd hate to 
see all the distros enabling embedded just to get this performance boost

David Lang

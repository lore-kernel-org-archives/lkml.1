Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbZE3SsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbZE3SsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 14:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761131AbZE3Sr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 14:47:57 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:38131 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760986AbZE3Sr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 14:47:57 -0400
Date: Sat, 30 May 2009 11:45:34 -0700
From: "Larry H." <research@subreption.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530184534.GJ6535@oblivion.subreption.com>
References: <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com> <4A20E601.9070405@cs.helsinki.fi> <20090530082048.GM29711@oblivion.subreption.com> <20090530173428.GA20013@elte.hu> <20090530180333.GH6535@oblivion.subreption.com> <20090530182113.GA25237@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090530182113.GA25237@elte.hu>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:21 Sat 30 May     , Ingo Molnar wrote:
> SLOB is a rarely used (and high overhead) allocator. But the right 
> answer there: fix kzalloc().

If it's rarely used and nobody cares, why nobody has removed it yet?
Sames like the very same argument Peter and you used at some point
against these patches. Later in your response here you state the same
for kzfree. Interesting.

> if kzfree() is broken then a number of places in the kernel that 
> currently rely on it are potentially broken as well.

Indeed, but it was sitting there unused up to 2.6.29.4. Apparently only
-30-rc2 introduces users of the patch. Someone didn't do his homework
signing off the patch without testing it properly.

> So as far as i'm concerned, your patchset is best expressed in the 
> following form: Cryto, WEP and other sensitive places should be 
> updated to use kzfree() to free keys.
> 
> This can be done unconditionally (without any Kconfig flag), as it's 
> all in slow-paths - and because there's a real security value in 
> sanitizing buffers that held sensitive keys, when they are freed.

And the tty buffers, and the audit buffers, and the crypto block alg
contexts, and the generic algorithm contexts, and the input buffers
contexts, and ... alright, I get the picture!

> Regarding a whole-sale 'clear everything on free' approach - that's 
> both pointless security wise (sensitive information can still leak 
> indefinitely [if you disagree i can provide an example]) and has a 
> very high cost so it's not acceptable to normal Linux distros.

Go ahead, I want to see your example.

I don't even know why I'm still wasting my time replying to you, it's
clearly hopeless to try to get you off your egotistical, red herring
argument fueled attitude, which is likely a burden beyond this list for
you and everyone around, sadly.

> > Honestly your proposed approach seems a little weak.
> 
> Unconditional honesty is definitely welcome ;-)

When it's people's security at stake, if your reasoning and logic is
flawed, I have the moral obligation to tell you.

I'm here to make the kernel more secure, not to deal with your inability
to work with others without continuous conflicts and attempts to fall
into ridicule, that backfire at you in the end.

> Freeing keys is an utter slow-path (if not then the clearing is the 
> least of our performance worries), so any clearing cost is in the 
> noise. Furthermore, kzfree() is an existing facility already in use. 
> If it's reused by your patches that brings further advantages: 
> kzfree(), if it has any bugs, will be fixed. While if you add a 
> parallel facility kzfree() stays broken.

Have you benchmarked the addition of these changes? I would like to see
benchmarks done for these (crypto api included), since you are proposing
them.

> So your examples about real or suspected kzfree() breakages only 
> strengthen the point that your patches should be using it. Keeping a 
> rarely used kernel facility (like kzfree) correct is hard - 
> splintering it by creating a parallel facility is actively harmful 
> for that reason.

Fallacy ad hitlerum delivered. Impressive.

	Larry

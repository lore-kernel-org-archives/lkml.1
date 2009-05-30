Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbZE3Hw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbZE3Hw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 03:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZE3Hwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 03:52:51 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:49679 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZE3Hwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 03:52:50 -0400
Date: Sat, 30 May 2009 00:50:33 -0700
From: "Larry H." <research@subreption.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530075033.GL29711@oblivion.subreption.com>
References: <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:35 Sat 30 May     , Pekka Enberg wrote:
> The GFP_SENSITIVE flag looks like a big hammer that we don't really
> need IMHO. It seems to me that most of the actual call-sites (crypto
> code, wireless keys, etc.) should probably just use kzfree()
> unconditionally to make sure we don't leak sensitive data. I did not
> look too closely but I don't think any of the sensitive kfree() calls
> are in fastpaths so the performance impact is negligible.

That's hopeless, and kzfree is broken. Like I said in my earlier reply,
please test that yourself to see the results. Whoever wrote that ignored
how SLAB/SLUB work and if kzfree had been used somewhere in the kernel
before, it should have been noticed long time ago.

It's called disregard when you ditch something in favor of something
else you have assumed to be better, when it isn't. That's not polite.

Furthermore, selective clearing doesn't solve the roots of the problem.
It's just adding bandages to a wound which never stops bleeding. I
proposed an initial page flag because we could use it later for
unconditional page clearing doing a one line change in a header file.

I see a lot of speculation on what works and what doesn't, but
there isn't much on the practical side of things, yet. I provided test
results that proved some of the comments wrong, and I've referenced
literature which shows the reasoning behind all this. What else can I do
to make you understand you are missing the point here?

	Larry

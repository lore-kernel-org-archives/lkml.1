Return-Path: <linux-kernel-owner+w=401wt.eu-S932681AbZE3Rjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbZE3Rjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 13:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932519AbZE3Rje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 13:39:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbZE3Rjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 13:39:33 -0400
Date: Sat, 30 May 2009 19:39:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Larry H." <research@subreption.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530173906.GB20013@elte.hu>
References: <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com> <4A20E601.9070405@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A20E601.9070405@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Larry,
>
> On 10:35 Sat 30 May, Pekka Enberg wrote:
>>> The GFP_SENSITIVE flag looks like a big hammer that we don't really
>>> need IMHO. It seems to me that most of the actual call-sites (crypto
>>> code, wireless keys, etc.) should probably just use kzfree()
>>> unconditionally to make sure we don't leak sensitive data. I did not
>>> look too closely but I don't think any of the sensitive kfree() calls
>>> are in fastpaths so the performance impact is negligible.
>
> Larry H. wrote:
>> That's hopeless, and kzfree is broken. Like I said in my earlier reply,
>> please test that yourself to see the results. Whoever wrote that ignored
>> how SLAB/SLUB work and if kzfree had been used somewhere in the kernel
>> before, it should have been noticed long time ago.
>
> An open-coded version of kzfree was being used in the kernel:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=00fcf2cb6f6bb421851c3ba062c0a36760ea6e53
>
> Can we now get to the part where you explain how it's broken 
> because I obviously "ignored how SLAB/SLUB works"?

Yeah, kzfree() sounds like the right approach for all places that 
know it for sure that they dont want information to persist.

	Ingo

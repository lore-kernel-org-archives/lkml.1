Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZE3H6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZE3H6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 03:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZE3H6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 03:58:02 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42310 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZE3H6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 03:58:01 -0400
Message-ID: <4A20E601.9070405@cs.helsinki.fi>
Date: Sat, 30 May 2009 10:53:37 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Larry H." <research@subreption.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page	allocator
References: <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com>
In-Reply-To: <20090530075033.GL29711@oblivion.subreption.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On 10:35 Sat 30 May, Pekka Enberg wrote:
>> The GFP_SENSITIVE flag looks like a big hammer that we don't really
>> need IMHO. It seems to me that most of the actual call-sites (crypto
>> code, wireless keys, etc.) should probably just use kzfree()
>> unconditionally to make sure we don't leak sensitive data. I did not
>> look too closely but I don't think any of the sensitive kfree() calls
>> are in fastpaths so the performance impact is negligible.

Larry H. wrote:
> That's hopeless, and kzfree is broken. Like I said in my earlier reply,
> please test that yourself to see the results. Whoever wrote that ignored
> how SLAB/SLUB work and if kzfree had been used somewhere in the kernel
> before, it should have been noticed long time ago.

An open-coded version of kzfree was being used in the kernel:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=00fcf2cb6f6bb421851c3ba062c0a36760ea6e53

Can we now get to the part where you explain how it's broken because I 
obviously "ignored how SLAB/SLUB works"?

Thanks!

			Pekka

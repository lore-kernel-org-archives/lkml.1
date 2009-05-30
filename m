Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZE3IXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZE3IXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZE3IXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:23:08 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:48427 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZE3IXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:23:06 -0400
Date: Sat, 30 May 2009 01:20:48 -0700
From: "Larry H." <research@subreption.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530082048.GM29711@oblivion.subreption.com>
References: <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu> <4A187BDE.5070601@redhat.com> <20090527223421.GA9503@elte.hu> <20090528072702.796622b6@lxorguk.ukuu.org.uk> <20090528090836.GB6715@elte.hu> <20090528125042.28c2676f@lxorguk.ukuu.org.uk> <84144f020905300035g1d5461f9n9863d4dcdb6adac0@mail.gmail.com> <20090530075033.GL29711@oblivion.subreption.com> <4A20E601.9070405@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A20E601.9070405@cs.helsinki.fi>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:53 Sat 30 May     , Pekka Enberg wrote:
>> That's hopeless, and kzfree is broken. Like I said in my earlier reply,
>> please test that yourself to see the results. Whoever wrote that ignored
>> how SLAB/SLUB work and if kzfree had been used somewhere in the kernel
>> before, it should have been noticed long time ago.
>
> An open-coded version of kzfree was being used in the kernel:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=00fcf2cb6f6bb421851c3ba062c0a36760ea6e53
>
> Can we now get to the part where you explain how it's broken because I 
> obviously "ignored how SLAB/SLUB works"?

You can find the answer in the code of sanitize_obj, within my kfree
patch. Besides, it would have taken less time for you to write a simple
module that kmallocs and kzfrees a buffer, than writing these two
emails.

Consider the inuse, size, objsize and offset members of a kmem_cache
structure, for further hints. Test the module on a system with SLUB,
though the issue should replicate over SLAB too. And don't dare test it
on SLOB and its wonderful ksize, or even look at the freelist pointer
management within SLUB.

;)

I'm about to recommend Andrew to take a look at this too:
http://marc.info/?l=linux-mm&m=124301548814293&w=2

	Larry

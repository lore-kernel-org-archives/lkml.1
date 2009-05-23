Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZEWW3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZEWW3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZEWW3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:29:17 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:43605 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbZEWW3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:29:16 -0400
Date: Sat, 23 May 2009 15:28:13 -0700
From: "Larry H." <research@subreption.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090523222813.GN13971@oblivion.subreption.com>
References: <20090520183045.GB10547@oblivion.subreption.com> <4A15A8C7.2030505@redhat.com> <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090523124944.GA23042@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090523124944.GA23042@elte.hu>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:49 Sat 23 May     , Ingo Molnar wrote:
> You need to address my specific concerns instead of referring back 
> to an earlier discussion. The patches touch code i maintain and i 
> find them (and your latest resend) unacceptable.

Meaning the latest boot option-based unconditional sanitization which
doesn't touch anything else and doesn't duplicate clearing (it only
performs such during release)?

> Naming _is_ a technical issue. Especially here.

True, that's no more of an issue since the page flag approach has been
left out of the patch (albeit it mutilates our possibilities to do
fine-grained clearing and track status across the different higher level
interfaces through the gfp flag). Do you still have a problem with
something related to naming?

If any of the variable names still don't catch your fancy, please let me
know.

> What you are missing is that your patch makes _no technical sense_ 
> if you allow the same information to leak over the kernel stack. 
> Kernel stacks can be freed and reused, swapped out and thus 
> 'exposed'.

Do you have technical evidence to back up that claim? Perhaps an
analysis and testcase that demonstrates true resilience of the kernel
stack information? Something that can convince me I'm mistaken by
showing that it isn't extremely volatile? That it doesn't get
overwritten to smithereens?

I have a simple testcase for vmalloc/kmalloc/page allocator
sanitization. The current patch covers both vmalloc and page allocators
well, since the former is basically dependent on the latter. kmalloc
still won't get sanitized until the slab is returned to the page
allocator (during cache shrink/reaping or when it becomes empty).

Also, a political question, are you the only current maintainer of the
affected code, or there are more people who might not necessarily share
your opinion on this?

	Larry


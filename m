Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbZEaKYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbZEaKYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZEaKY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:24:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41043 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756548AbZEaKY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:24:28 -0400
Date: Sun, 31 May 2009 11:24:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page 
 allocator
Message-ID: <20090531112440.50cbc4fd@lxorguk.ukuu.org.uk>
In-Reply-To: <84144f020905302314w12c4c7f8jc8241e36c847f53e@mail.gmail.com>
References: <20090528090836.GB6715@elte.hu>
	<20090530082048.GM29711@oblivion.subreption.com>
	<20090530173428.GA20013@elte.hu>
	<20090530180333.GH6535@oblivion.subreption.com>
	<20090530182113.GA25237@elte.hu>
	<20090530184534.GJ6535@oblivion.subreption.com>
	<20090530190828.GA31199@elte.hu>
	<4A21999E.5050606@redhat.com>
	<84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com>
	<20090531001052.40ac57d2@lxorguk.ukuu.org.uk>
	<84144f020905302314w12c4c7f8jc8241e36c847f53e@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, May 31, 2009 at 2:10 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > #2 Using kzfree() to clear specific bits of memory (and I question the
> > kzfree implementation as it seems ksize can return numbers much much
> > bigger than the allocated space you need to clear - correct but oversize)
> > or using other flags. I'd favour kzfree personally (and fixing it to work
> > properly)
> 
> Well, yes, that's what kzfree() needs to do given the current API. I
> am not sure why you think it's a problem, though. Adding a size
> argument to the function will make it more error prone.

Definitely - am I right however that 

	x = kzalloc(size, flags)
	blah
	kzfree(x)

can memset a good deal more memory (still safely) than "size" to zero ?
That has performance relevance if so and it ought to at least be
documented.

> On Sun, May 31, 2009 at 2:10 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > #3 People wanting to be able to select for more security *irrespective*
> > of performance cost. Which is no different to SELinux for example.
> 
> Yeah, as I said before, I really don't have any objections to this. I
> just think nobody is going to enable it so memset() or kzfree() in
> relevant places is probably a good idea.

Agreed entirely.

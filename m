Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZEWP5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZEWP5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 11:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZEWP46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 11:56:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:53829 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbZEWP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 11:56:57 -0400
Date: Sat, 23 May 2009 08:56:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Larry H." <research@subreption.com>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090523085653.0ad217f8@infradead.org>
In-Reply-To: <20090523090910.3d6c2e85@lxorguk.ukuu.org.uk>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<4A15A8C7.2030505@redhat.com>
	<20090522073436.GA3612@elte.hu>
	<20090522113809.GB13971@oblivion.subreption.com>
	<20090522143914.2019dd47@lxorguk.ukuu.org.uk>
	<20090522180351.GC13971@oblivion.subreption.com>
	<20090522192158.28fe412e@lxorguk.ukuu.org.uk>
	<20090522234031.GH13971@oblivion.subreption.com>
	<20090523090910.3d6c2e85@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 May 2009 09:09:10 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Enabling SLAB poisoning by default will be a bad idea
> 
> Why ?
> 
> > I looked for unused/re-usable flags too, but found none. It's
> > interesting to see SLUB and SLOB have their own page flags. Did
> > anybody oppose those when they were proposed? 
> 
> Certainly they were looked at - but the memory allocator is right at
> the core of the system rather than an add on.
> 
> > > Ditto - which is why I'm coming from the position of an "if we
> > > free it clear it" option. If you need that kind of security the
> > > cost should be more than acceptable - especially with modern
> > > processors that can do cache bypass on the clears.
> > 
> > Are you proposing that we should simply remove the confidential
> > flags and just stick to the unconditional sanitization when the
> > boot option is enabled? If positive, it will make things more
> > simple and definitely is better than nothing. I would have (still)
> > preferred the other old approach to be merged, but whatever works
> > at this point.
> 
> I am because
> - its easy to merge
> - its non controversial
> - it meets the security good practice and means we don't miss any
>   alloc/free cases
> - it avoid providing flags to help a trojan identify "interesting"
> data to acquire
> - modern cpu memory clearing can be very cheap

.. and if we zero on free, we don't need to zero on allocate.
While this is a little controversial, it does mean that at least part of
the cost is just time-shifted, which means it'll not be TOO bad
hopefully...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

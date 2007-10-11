Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbXKAOeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbXKAOeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbXKAOdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:33:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4277 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757026AbXKAOdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:33:05 -0400
Date: Thu, 11 Oct 2007 20:56:42 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] wait: use lock bitops for __wait_on_bit_lock
Message-ID: <20071011205641.GA3864@ucw.cz>
References: <20071024081305.906617000@nick.local0.net> <20071024081405.094887000@nick.local0.net> <20071024181428.1d25299a.akpm@linux-foundation.org> <200710251217.10704.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710251217.10704.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Sorry, I'm just not going to apply a patch like that.
> >
> > I mean, how the heck is anyone else supposed to understand what you're up
> > to?
> 
> Hmm, I might just withdraw this patch 1/5. This is generally a slowpath,
> and it's hard to guarantee that any exported user doesn't rely on the
> full barrier here (not that they would know whether they do or not, let
> alone document the fact).
> 
> I think all the others are pretty clear, though? (read on if no)
...
> > There's a bit of documentation in Documentation/atomic_ops.txt 
> > (probably enough, I guess) but it is totally unobvious to 98.3% of kernel
> > developers when they should use test_and_set_bit() versus
> > test_and_set_bit_lock() and it is far too much work to work out why it was
> > used in __wait_on_bit_lock(), whether it is correct, what advantages it
> > brings and whether and where others should emulate it.
> 
> If you set a bit for the purpose of opening a critical section, then
> you can use this. And clear_bit_unlock to close it.
> 
> The advantages are that it is faster, and the hapless driver writer
> doesn't have to butcher or forget about doing the correct
> smp_mb__before_clear_bit(), or have reviewers wondering exactly WTF
> that barrier is for, etc.

Actually, I'd expect *_lock() ro be slower than *()...

> Basically, it is faster, harder to get wrong, and more self-docuemnting.

So I'd not call it self-documenting.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

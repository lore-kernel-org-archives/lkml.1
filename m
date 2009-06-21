Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbZFUT03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbZFUT03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 15:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZFUT0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 15:26:21 -0400
Received: from www.tglx.de ([62.245.132.106]:60564 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbZFUT0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 15:26:21 -0400
Date: Sun, 21 Jun 2009 21:26:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <alpine.LFD.2.01.0906211049060.3119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906212059340.2784@localhost.localdomain>
References: <20090620173022.GA14145@elte.hu> <alpine.LFD.2.01.0906201132020.4160@localhost.localdomain> <alpine.LFD.2.01.0906201154230.4160@localhost.localdomain> <alpine.LFD.2.00.0906211553150.2784@localhost.localdomain> <alpine.LFD.2.01.0906211031230.3119@localhost.localdomain>
 <alpine.LFD.2.01.0906211049060.3119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Sun, 21 Jun 2009, Linus Torvalds wrote:
> So just doing a "make_sure_its_writable()" and using handle_fault() is the 
> right thing to do. Because it's what get_user_fast() would have done too, 
> except it would have gone through first the fast case, and failed, then 
> the slow case, and failed the lookup there, and then the slow case would 
> have done that handle_mm_fault() in the end anyway.
> 
> In fact, since you're not actually interested in the page, you _could_ 
> just do
> 
> 	get_user_pages(tsk, mm, uaddr, 4, 1, 0, NULL, NULL);
> 
> where a NULL "pages" pointer already tells get_user_pages() that you're 
> not interested.
> 
> That's at least cleaner than doing a "gup_fast()" (which isn't fast), and 
> then freeing the page that you weren't even interested in.

Yes, you are right. The retry fixup path is after the fault and we
should go through handle_mm_fault as long as we do not have a general
available nondestructive counterpart of get_user().

I confused myself by twisting my brain whether we can simplify or even
get rid of the whole retry business.

Sorry, I did not express myself very well - looking for more than an
hour into the futex code definitely hurts your brain. It's worse than
the drugs you suspected we're on. :)

Thanks,

	tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0CCVyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:54:23 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37253 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756811Ab0CCVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:54:12 -0500
Date: Wed, 3 Mar 2010 22:54:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
Message-ID: <20100303215402.GE2579@ucw.cz>
References: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp> <alpine.DEB.2.00.1002261009320.7719@router.home> <201002270959.EEI05786.OOFFQVMFJLOtSH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002270959.EEI05786.OOFFQVMFJLOtSH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Everybody should check for ptr != NULL, and most callers are actually checking
> > > for ptr != NULL. But nobody is checking for ptr != ZERO_SIZE_PTR.
> > 
> > That is so intentionally because some kernel subsystem can do a zero size
> > allocation.
> > 
> So, not only users *can* do zero size allocation,
> but also there *are* users who are intentionally doing zero size allocation.
> Then, we can't remove ZERO_SIZE_PTR.
> 
> > > Yes, this is the fault of caller. But ZERO_SIZE_PTR is too small value to
> > > distinguish "NULL pointer dereference" and "ZERO_SIZE_PTR dereference" because
> > > address printed by oops message can easily exceed ZERO_SIZE_PTR when
> > > "struct foo" is large.
> > 
> > Correct.
> 
> Maybe PAGE_SIZE / 2 is better than 16?

Actually maybe 1 is better than 16?

It is 'nicer' number, and <= ZERO_SIZE_PTR will actually be correct.

Accessing field it struct will also be easy to differentiate from NULL
pointer -- as most members are word aligned...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

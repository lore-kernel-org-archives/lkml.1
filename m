Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbXEIKuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbXEIKuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXEIKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:50:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38029 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755251AbXEIKuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:50:01 -0400
Date: Wed, 9 May 2007 12:49:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, rjw@sisk.pl,
       James.Bottomley@SteelEye.com, aneesh.kumar@gmail.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, ego@in.ibm.com, greg@kroah.com, mingo@elte.hu,
       neilb@suse.de, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       vatsa@in.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 128/197] freezer: add try_to_freeze calls to all kernel threads
Message-ID: <20070509104949.GA8164@elf.ucw.cz>
References: <200705090934.l499YTvX019783@shell0.pdx.osdl.net> <4641A5F1.5080901@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4641A5F1.5080901@s5r6.in-berlin.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Add try_to_freeze() calls to the remaining kernel threads that do not call
> > try_to_freeze() already, although they set PF_NOFREEZE.
> > 
> > In the future we are going to replace PF_NOFREEZE with a set of flags that
> > will be set to indicate in which situations the task should not be frozen (for
> > example, there can be a task that should be frozen for the CPU hotplugging and
> > should not be frozen for the system suspend).  For this reason every kernel
> > thread should be able to freeze itself (ie.  call try_to_freeze()), so that it
> > can be frozen whenever necessary.
> 
> A few questions:
> 
> Does try_to_freeze()'s kerneldoc document that try_to_freeze() is a
> no-op sometimes but should nevertheless be called for this and that
> reason?  (I don't know the entire patch series.)
> 
> Why add no-op-try_to_freeze() everywhere now, instead of adding it later
> when it will actually be needed?  (I.e. "in the future".)

It is needed later in the patch series... for kprobes, etc.

> Can we please have a future where no device driver has to care if and
> when and how to freeze its threads?

No. Freezing is useful for kprobes/cpu hotplug as well as suspend.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

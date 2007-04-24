Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbXDXUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbXDXUXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXDXUXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:23:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58603 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754372AbXDXUXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:23:48 -0400
Date: Tue, 24 Apr 2007 22:23:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070424202336.GC16503@elf.ucw.cz>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419070437.GA25211@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > From subsequent emails, I think you already got your answer, but just 
> > in case...
> > 
> > Yes, if you enabled "Replace swsusp by default" and you already had it 
> > set up for getting swsusp to resume. If not, and you're using an 
> > initrd/ramfs, you'll need to modify it to echo
> > > /sys/power/suspend2/do_resume after /sys and /proc are mounted but
> > prior to mounting / and so on.
> 
> yeah, went with the default suggested by your patch:
> 
>    CONFIG_SUSPEND2_REPLACE_SWSUSP=y
> 
> and it was pretty easy to set things up. I used "echo disk > 
> /sys/power/state" to trigger it.
> 
> In hindsight it was all pretty straightforward and suspend2 worked 
> beautifully on an UP and on an SMP system i tried. So in exchange for 
> suspend2 folks debugging a bug in CFS here's some suspend2 review 
> feedback ;) Any plans about moving suspend2 to the upstream kernel? It 
> should be pretty easy for it to co-exist with the current swsuspend 
> code.

Well, current uswsusp code can do most of stuff suspend2 can do, with
20% (or so) of kernel code. 

"Major feature" that is missing is ability to save 100% of memory if
it is all the pagecache. I think that is not that important; we have
200 line patch to do that, but noone was able to verify it is correct.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

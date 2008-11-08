Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYKHSlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYKHSlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYKHSlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:41:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:54020 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYKHSlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:41:00 -0500
Date: Sat, 8 Nov 2008 10:41:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081108104116.48bd26e6@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org>
References: <20081108170224.GA553@elte.hu>
	<alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Nov 2008 10:28:21 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 8 Nov 2008, Ingo Molnar wrote:
> >
> > Ingo Molnar (2):
> >       sched: improve sched_clock() performance
> >       sched: optimize sched_clock() a bit
> 
> Btw, why do we do that _idiotic_ rdtsc_barrier() AT ALL?
> 
> No sane user can possibly want it. If you do 'rdtsc', there's nothing
> you can do about a few cycles difference due to OoO _anyway_. Adding
> barriers is entirely meaningless - it's not going to make the return
> value mean anything else.
> 
> Can we please just remove that idiocy? Or can somebody give a _sane_ 
> argument for it?

historically it was for early AMD cpus (K7, not sure if early K8 did
this) where 2 consecutive rdtsc's in the same codestream would get
reordered compared to eachother, so you could observe the tsc go
backwards...



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

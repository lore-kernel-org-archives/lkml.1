Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZB1WHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZB1WHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZB1WHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:07:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60554 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZB1WHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:07:42 -0500
Date: Sat, 28 Feb 2009 23:08:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090228220829.GE21230@elf.ucw.cz>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <20090227210856.GB1476@ucw.cz> <20090228165624.GC26292@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228165624.GC26292@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The very old text poke code I had for this just used a dynamic
> > > mapping elsewhere instead to modify the code. That's much less
> > > intrusive than changing the complete mappings. Any reason you can't use 
> > > that too?
> > 
> > Is it legal to have two mappings of same page with different
> > attributes? IIRC some processors did not like that...
> 
> If you mean PAT caching attributes: correct it is not legal in x86 and
> causes problems including data corruption.

Aha, PAT is what I remembered on x86-64.

> If you mean other attributes like large page vs small page: it's normally legal,
> with a few exceptions.

...but is it okay on other architectures, like sparc, with funky cache
setups?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

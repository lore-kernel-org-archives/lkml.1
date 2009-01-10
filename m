Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZAJRxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZAJRxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 12:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZAJRwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 12:52:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38925 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZAJRwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 12:52:54 -0500
Date: Sat, 10 Jan 2009 18:52:41 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Message-ID: <20090110175240.GA1436@ucw.cz>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106121052.GA27232@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Linus, what do you think about this particular approach of spin-mutexes? 
> It's not the typical spin-mutex i think.
> 
> The thing i like most about Peter's patch (compared to most other adaptive 
> spinning approaches i've seen, which all sucked as they included various 
> ugly heuristics complicating the whole thing) is that it solves the "how 
> long should we spin" question elegantly: we spin until the owner runs on a 
> CPU.

Well; if there's a timeout, that's obviously safe.

But this has no timeout, and Linus wants to play games with accessing
'does owner run on cpu?' lockless. Now, can it mistakenly spin when
the owner is scheduled away? That would deadlock, and without locking,
I'm not sure if we prevent that....

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

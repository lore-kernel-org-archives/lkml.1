Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbXLEDmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbXLEDmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXLEDmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:42:02 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbXLEDmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:42:01 -0500
Date: Tue, 4 Dec 2007 19:41:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] fix for futex_wait signal stack corruption
In-Reply-To: <Pine.LNX.4.58.0712042135030.18314@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.0.9999.0712041935140.13796@woody.linux-foundation.org>
References: <1196801858.1645.37.camel@localhost.localdomain> <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org> <20071204213924.GA14915@goodmis.org> <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
 <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com> <alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org> <Pine.LNX.4.58.0712042135030.18314@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Patch looks fine to me.

On Tue, 4 Dec 2007, Steven Rostedt wrote:
> 
> Note: I'm a bit nervious to add "linux/types.h" and use u32 and u64
> in thread_info.h, when there's a #ifdef __KERNEL__ just below that.
> Not sure what that is there for.

Hmm. I'd not expect user-mode headers to ever include 
<linux/thread-info.h>, and if they do, they'd already get get totally 
invalid namespace pollution ("struct restart_block" at a minimum) along 
with stuff that simply isn't sensible in user-space at all, so I think 
this part is fine.

And I guess somebody will scream if it bites them ;)

Anyway, my gut feel is that this is potentially a real problem, and we 
should fix it asap (ie it should go into 2.6.24 even at this late stage in 
the game), but it would be nice to know if the problem actually hit any 
actual real program, and not just a test-setup.

So here's a question for David Holmes:  What caused you to actually notice 
this behaviour? Can this actually be seen in real life usage?

Anyway, at a minimum, here's an

	Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

and I suspect I should just apply it directly. Any comments from anybody 
else?

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbXLEDtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbXLEDtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXLEDtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:49:15 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:55989 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbXLEDtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:49:15 -0500
Date: Tue, 4 Dec 2007 19:47:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] fix for futex_wait signal stack corruption
Message-Id: <20071204194719.e048ebc1.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.0.9999.0712041935140.13796@woody.linux-foundation.org>
References: <1196801858.1645.37.camel@localhost.localdomain>
	<alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
	<20071204213924.GA14915@goodmis.org>
	<alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
	<Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com>
	<alpine.LFD.0.9999.0712041740490.13796@woody.linux-foundation.org>
	<Pine.LNX.4.58.0712042135030.18314@gandalf.stny.rr.com>
	<alpine.LFD.0.9999.0712041935140.13796@woody.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 19:41:32 -0800 (PST) Linus Torvalds wrote:

> 
> Patch looks fine to me.
> 
> On Tue, 4 Dec 2007, Steven Rostedt wrote:
> > 
> > Note: I'm a bit nervious to add "linux/types.h" and use u32 and u64
> > in thread_info.h, when there's a #ifdef __KERNEL__ just below that.
> > Not sure what that is there for.
> 
> Hmm. I'd not expect user-mode headers to ever include 
> <linux/thread-info.h>, and if they do, they'd already get get totally 
> invalid namespace pollution ("struct restart_block" at a minimum) along 
> with stuff that simply isn't sensible in user-space at all, so I think 
> this part is fine.
> 
> And I guess somebody will scream if it bites them ;)
> 
> Anyway, my gut feel is that this is potentially a real problem, and we 
> should fix it asap (ie it should go into 2.6.24 even at this late stage in 
> the game), but it would be nice to know if the problem actually hit any 
> actual real program, and not just a test-setup.

Steve/David,

where can I find the test case, please?

> So here's a question for David Holmes:  What caused you to actually notice 
> this behaviour? Can this actually be seen in real life usage?
> 
> Anyway, at a minimum, here's an
> 
> 	Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> and I suspect I should just apply it directly. Any comments from anybody 
> else?

---
~Randy
Features and documentation: http://lwn.net/Articles/260136/

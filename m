Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbXFWSu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbXFWSu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXFWSuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:50:50 -0400
Received: from xenotime.net ([66.160.160.81]:55914 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750938AbXFWSut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:50:49 -0400
Date: Sat, 23 Jun 2007 11:52:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hch@infradead.org,
       johnstul@us.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
Message-Id: <20070623115252.fc36f20c.rdunlap@xenotime.net>
In-Reply-To: <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
References: <20070622182051.859570787@goodmis.org>
	<20070622182315.571740041@goodmis.org>
	<20070623095359.4667514e.akpm@linux-foundation.org>
	<alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 11:19:18 -0700 (PDT) Linus Torvalds wrote:

> 
> 
> On Sat, 23 Jun 2007, Andrew Morton wrote:
> > 
> > Anyway.  Please fix the many correct warnings which checkpatch.pl
> > generates
> 
> Actually, please don't.
> 
> Especially for code movement, *just* do the movement. Screw any 
> checkpatch.pl crap - the code is better off not changing, because that way 
> a big patch can not only be proven to not change anything at all, but 
> software archeology tools can trivially find the true history of the code 
> over code movement.
> 
> For example, "git blame -C" already finds copies and can annotate the 
> history of a line of code past a pure code movement. But if you move *and* 
> change things at the same time, it gets a lot harder to show where the 
> code came from and that the movement itself caused no regressions.
> 
> So do cleanups _separately_ from movement.
> 
> (Yeah, yeah, "git blame -C -w" will generally work across whitespace 
> changes too, but only whitespace _within_ a line. If you do things like 
> split long lines etc, you immediately have a lot harder time to follow 
> these thigns. Not impossible, but the point is that you're not *fixing* 
> anything, you're just making things *worse* by doing changes and code 
> movement at the same time).
> 
> Quite frankly, I personally am considering removing "checkpatch.pl". That 
> thing is just a nazi dream. That hard-coded 80-character limit etc is just 
> bad taste.

Who wrote that part of CodingStyle?


The script is certainly no substitute for personal review.
And it's certainly not the final say on anything.
(neither is CodingStyle AFAIK)
It's just a helper for Andrew.

The problem IMO is that we are seeing less and less patch review
but it needs to be more and more.  Andrew is one of a handful of
people who are reviewing lots of patches.  It shouldn't be his
wheelbarrow to have to push around all the time.  So if a little
automation can help Andrew, that's a good thing.  Until people
revolt, that is.


> Dammit, code cleanliness is not about "automated and mindless slavish 
> following of rules". A process that is too inflexible is a *bad* process. 
> I'd much rather have a few 80+ character lines than stupid and unreadable 
> line wrapping just because the line hit 87 characters in length.
> 
> I don't have 25 lines on a screen either. 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

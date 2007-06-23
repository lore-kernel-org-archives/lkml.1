Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbXFWS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbXFWS0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 14:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXFWS0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 14:26:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbXFWS0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 14:26:03 -0400
Date: Sat, 23 Jun 2007 11:19:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hch@infradead.org,
       johnstul@us.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
In-Reply-To: <20070623095359.4667514e.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
References: <20070622182051.859570787@goodmis.org> <20070622182315.571740041@goodmis.org>
 <20070623095359.4667514e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Jun 2007, Andrew Morton wrote:
> 
> Anyway.  Please fix the many correct warnings which checkpatch.pl
> generates

Actually, please don't.

Especially for code movement, *just* do the movement. Screw any 
checkpatch.pl crap - the code is better off not changing, because that way 
a big patch can not only be proven to not change anything at all, but 
software archeology tools can trivially find the true history of the code 
over code movement.

For example, "git blame -C" already finds copies and can annotate the 
history of a line of code past a pure code movement. But if you move *and* 
change things at the same time, it gets a lot harder to show where the 
code came from and that the movement itself caused no regressions.

So do cleanups _separately_ from movement.

(Yeah, yeah, "git blame -C -w" will generally work across whitespace 
changes too, but only whitespace _within_ a line. If you do things like 
split long lines etc, you immediately have a lot harder time to follow 
these thigns. Not impossible, but the point is that you're not *fixing* 
anything, you're just making things *worse* by doing changes and code 
movement at the same time).

Quite frankly, I personally am considering removing "checkpatch.pl". That 
thing is just a nazi dream. That hard-coded 80-character limit etc is just 
bad taste. 

Dammit, code cleanliness is not about "automated and mindless slavish 
following of rules". A process that is too inflexible is a *bad* process. 
I'd much rather have a few 80+ character lines than stupid and unreadable 
line wrapping just because the line hit 87 characters in length.

I don't have 25 lines on a screen either. 

		Linus

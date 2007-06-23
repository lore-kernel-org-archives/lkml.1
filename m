Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbXFWTZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbXFWTZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 15:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXFWTZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 15:25:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724AbXFWTZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 15:25:04 -0400
Date: Sat, 23 Jun 2007 12:18:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hch@infradead.org,
       johnstul@us.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 5/5 v2] Convert tasklets to work queues
In-Reply-To: <20070623115252.fc36f20c.rdunlap@xenotime.net>
Message-ID: <alpine.LFD.0.98.0706231209130.3593@woody.linux-foundation.org>
References: <20070622182051.859570787@goodmis.org> <20070622182315.571740041@goodmis.org>
 <20070623095359.4667514e.akpm@linux-foundation.org>
 <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org>
 <20070623115252.fc36f20c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Jun 2007, Randy Dunlap wrote:
> > 
> > Quite frankly, I personally am considering removing "checkpatch.pl". That 
> > thing is just a nazi dream. That hard-coded 80-character limit etc is just 
> > bad taste.
> 
> Who wrote that part of CodingStyle?

I don't think that the notion of "80 characters per line" is *wrong* per 
se.

So don't take this the wrong way - I think the goal really _should_ be 
that a function fits on a vt100 terminal window (*both* ways: less than 24
lines of code, and less than 80 characters wide).

So I think the notion of trying to keep lines below 80 characters is 
admirable. That part isn't the problem.

The problem is when "coding style guidelines" become "hard inviolate 
rules".

Yes, code should be less than 80 characters wide. 

But hey, sometimes it's just more readable to have one line that is 
slightly longer than it should be, than to split something that is awkward 
to split. 

The thing that scripts (and computers) have a really hard time with is 
"judgement". 

So I don't disagree with any of the checkpatch.pl things individually, but 
I do disagree with the notion that we should enforce strict rules, when 
all the guidelines are really just guidelines.

For example, the coding style also says that you should avoid indentation 
that is more than tree deep. It's _true_, but does that mean that we 
should make deeply indented code *illegal*? Obviously not. It's a "please 
try to split your functions up" kind of thing.  Not a hard rule.

The only reason I picked the 80-character thing in particular is that 
I've seen a fair number of patches that don't do anything *but* change 
that, and quite often I think it makes the code look worse if it's not 
done judiciously..

There are other things we really *could* be strict against. For example, 
the "space followed by tab" thing really is somethign where a strict rule 
(at least for C files) probably really *is* a good idea, because there 
really is never a really good reason for it. Add the fact that the problem 
is "invisible" in most editors, and having a script that checks for it 
makes even more sense.

So I'm happy with checkpatch.pl as a *guide*, but I'm not happy if it 
means that people start taking it as a *requirement*.

(And then I'm doubly unhappy when there are issues like code movement and 
file renames etc, where there are other reasons why we actually want to 
keep the code as unmodified as possible).

		Linus

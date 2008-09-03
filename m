Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYICAZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYICAZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYICAZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:25:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49782 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYICAZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:25:42 -0400
Date: Tue, 2 Sep 2008 17:23:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Isely <isely@pobox.com>
Cc: Mike Isely <isely@isely.net>, Roland Dreier <rdreier@cisco.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, LKML <linux-kernel@vger.kernel.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: CodingStyle question: multiple statements on a single line
Message-Id: <20080902172356.43d7b6fb.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0809021830400.17907@cnc.isely.net>
References: <200809030021.00122.hverkuil@xs4all.nl>
	<ada7i9ufa7x.fsf@cisco.com>
	<Pine.LNX.4.64.0809021830400.17907@cnc.isely.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Tue, 2 Sep 2008 18:50:44 -0500 (CDT) Mike Isely wrote:

> On Tue, 2 Sep 2008, Roland Dreier wrote:
> 
> >  > 2) No, never use the 'if (a) b;' construction. Put 'b;' on the next line 
> >  > instead.
> > 
> > This is correct.  Always write simple if statements as
> > 
> > 	if (a)
> > 		b;
> 
> Going back to the text:
> 
> <quote>
> Don't put multiple statements on a single line unless you have
> something to hide:
> </quote>
> 
> Then what does "unless you have something to hide" refer to exactly?

IMO it means "don't do it".  I.e., you/we shouldn't have anything to hide.


> <quote>
>         if (condition) do_this;
>           do_something_everytime;
> </quote>
> 
> Realize that "if (condition) do_this;" is in fact one statement.  The 
> "if (condition)" part is not something that can stand on its own; it is 
> a predicate which is not completed without the rest of the statement.  
> I interpret the example to be showing what is correct, not what is 

I disagree FWIW.  It's a deliberate bad example AFAIK.

> disallowed.  Both lines are single statements, each on their own line.  
> I see the above as trying to illustrate outlawing of this sort of 
> silliness:
> 
>         if (condition) do_this; do_something_everytime;
> 
> which will compile and run but is obviously misleading.
> 
> If anything the "do_this" is an example where one has something to hide, 
> since it is not in the normal flow of execution (predicated instead by 
> "if (condition)").
> 
> If anything,
> 
> 	if (condition) do_this;
> 
> is safer than
> 
> 	if (conditon)
> 		do_this;
> 
> because while in both cases it's one statement, the second case is split 
> in exactly the spot where somebody's later errant line of code (say, a 
> debug printk) will completely change what is going on.  With the whole 
> statement on one line, this situation is avoided.  Or perhaps

I suppose anyone can screw anything up.  :(


> 
> 	if (condition) {
> 		do_this;
> 	}
> 
> is another way to avoid the same issue, but that seems frowned upon for 
> other reasons (below).
> 
> I know the answer to all this is just "but nobody does it that way".  
> But my reading of the CodingStyle says this is allowed and that is what 
> I thought was being asked - what does CodingStyle say?
> 
> 
> > 
> >  > And in general, why is this:
> >  > 
> >  > if (a) {
> >  > 	b;
> >  > }
> >  > 
> >  > not accepted by the CodingStyle? (At least as I understand it)
> > 
> > The braces take up another line of whitespace, which means less code
> > fits on the screen.  And in simple cases, they don't add anything.
> > Finally, the vast majority of the kernel leaves the braces off, so they
> > look funny to people who read a lot of kernel code.
> 
> So by that reasoning "if (a) b;" - provided it stays under 80 columns - 
> should be even better.  It occupies less space so that more code can fit 
> on the screen.

It's too close to hidden IMO.

> > 
> > And uniformity counts for a lot: most coding style rules are completely
> > arbitrary, but having a uniform kernel style makes reading kernel code
> > much easier.
> 
> What about drivers?  The statement has been made by others that there is 
> a strong desire for outside drivers to be brought into mainline rather 
> than being out-of-tree.  So must every chunk of code brought in this way 
> be sanitized to this level of detail?  In many cases that can be a large 
> (and some might say arbitrary) hurdle.

It's not difficult.  It's not a big hurdle.

> > 
> > Keep in mind that common sense always trumps any mechanical rule.  So if
> > there is some case where writing
> > 
> > 	if (a) {
> > 		b;
> > 	}
> > 
> > is clearly easier to read than leaving the braces off, then that would
> > be OK.
> 
> That's great.  How does one reconcile this statement with subsystem 
> maintainers who treat checkpatch.pl - which is the epitome of 
> "mechanical rule" and has no notion of common sense - as the gatekeeper 
> for all incoming changesets?

Use a clue-by-four?  The checkpatch.pl maintainers know that it is
just a tool.  There are numerous exceptional cases.
Use common sense.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYIBX6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYIBX6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYIBX6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:58:16 -0400
Received: from cnc.isely.net ([64.81.146.143]:35694 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbYIBX6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:58:16 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2008 19:58:15 EDT
Date: Tue, 2 Sep 2008 18:50:44 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Roland Dreier <rdreier@cisco.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>, LKML <linux-kernel@vger.kernel.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: CodingStyle question: multiple statements on a single line
In-Reply-To: <ada7i9ufa7x.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0809021830400.17907@cnc.isely.net>
References: <200809030021.00122.hverkuil@xs4all.nl> <ada7i9ufa7x.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Roland Dreier wrote:

>  > 2) No, never use the 'if (a) b;' construction. Put 'b;' on the next line 
>  > instead.
> 
> This is correct.  Always write simple if statements as
> 
> 	if (a)
> 		b;

Going back to the text:

<quote>
Don't put multiple statements on a single line unless you have
something to hide:
</quote>

Then what does "unless you have something to hide" refer to exactly?


<quote>
        if (condition) do_this;
          do_something_everytime;
</quote>

Realize that "if (condition) do_this;" is in fact one statement.  The 
"if (condition)" part is not something that can stand on its own; it is 
a predicate which is not completed without the rest of the statement.  
I interpret the example to be showing what is correct, not what is 
disallowed.  Both lines are single statements, each on their own line.  
I see the above as trying to illustrate outlawing of this sort of 
silliness:

        if (condition) do_this; do_something_everytime;

which will compile and run but is obviously misleading.

If anything the "do_this" is an example where one has something to hide, 
since it is not in the normal flow of execution (predicated instead by 
"if (condition)").

If anything,

	if (condition) do_this;

is safer than

	if (conditon)
		do_this;

because while in both cases it's one statement, the second case is split 
in exactly the spot where somebody's later errant line of code (say, a 
debug printk) will completely change what is going on.  With the whole 
statement on one line, this situation is avoided.  Or perhaps

	if (condition) {
		do_this;
	}

is another way to avoid the same issue, but that seems frowned upon for 
other reasons (below).

I know the answer to all this is just "but nobody does it that way".  
But my reading of the CodingStyle says this is allowed and that is what 
I thought was being asked - what does CodingStyle say?


> 
>  > And in general, why is this:
>  > 
>  > if (a) {
>  > 	b;
>  > }
>  > 
>  > not accepted by the CodingStyle? (At least as I understand it)
> 
> The braces take up another line of whitespace, which means less code
> fits on the screen.  And in simple cases, they don't add anything.
> Finally, the vast majority of the kernel leaves the braces off, so they
> look funny to people who read a lot of kernel code.

So by that reasoning "if (a) b;" - provided it stays under 80 columns - 
should be even better.  It occupies less space so that more code can fit 
on the screen.


> 
> And uniformity counts for a lot: most coding style rules are completely
> arbitrary, but having a uniform kernel style makes reading kernel code
> much easier.

What about drivers?  The statement has been made by others that there is 
a strong desire for outside drivers to be brought into mainline rather 
than being out-of-tree.  So must every chunk of code brought in this way 
be sanitized to this level of detail?  In many cases that can be a large 
(and some might say arbitrary) hurdle.


> 
> Keep in mind that common sense always trumps any mechanical rule.  So if
> there is some case where writing
> 
> 	if (a) {
> 		b;
> 	}
> 
> is clearly easier to read than leaving the braces off, then that would
> be OK.

That's great.  How does one reconcile this statement with subsystem 
maintainers who treat checkpatch.pl - which is the epitome of 
"mechanical rule" and has no notion of common sense - as the gatekeeper 
for all incoming changesets?

  -Mike


--

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

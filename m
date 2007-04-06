Return-Path: <linux-kernel-owner+w=401wt.eu-S933640AbXDFRim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640AbXDFRim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933701AbXDFRim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:38:42 -0400
Received: from smtp103.sbc.mail.re2.yahoo.com ([68.142.229.102]:39098 "HELO
	smtp103.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933640AbXDFRil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:38:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5ZxB7Iy4jstj3q39O6kdZlCh3eY8qE2mKCNOWzLt3a58eS4H0qWuHPTeFTAuJJ8y18t4/YONXpsd+C5UUxMwCa0EFnNBnAtlMPrmqWYW6ZG9cqdHIbYQ30QSxKf8SIdAKxVnYqfNfTyn9JzjF1dKOXy5QR8oyZNC88wOFjkdnpg=  ;
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Date: Fri, 6 Apr 2007 10:29:55 -0700
User-Agent: KMail/1.7.1
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
References: <11757099691323-git-send-email-tony@atomide.com> <200704051119.11944.david-b@pacbell.net> <Pine.LNX.4.61.0704052232540.6042@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704052232540.6042@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061029.55710.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 1:35 pm, Jan Engelhardt wrote:
>
> >obeys the only-ident-by-tabs rule, as does
> >
> >1	if (To control chain reactions, your odds
> >2			Improve if you've got cadmium rods) {
> >3		In your fission reactor
> >4		Their lack is a factor
> >5	}
> >6	In screams of "A meltdown! Ye gods!"
> >
> >Now, the former makes it hard to tell what's condition vs consequent.
> >(Or whatever the correct technical term is in cases like these.)
> 
> My fu dictates that continuation lines (line 2 in this example)
> should have more indent than line 1, 

Yes.  Where "indent" is measured -- always!! -- in tabs.
Documentation/Coding style is quite explicit on that point:

	Outside of comments, documentation and except in Kconfig,
	spaces are never used for indentation ...

Note also:

	Statements longer than 80 columns will be broken into sensible
	chunks.   Descendants are always substantially shorter than the
	parent and are placed substantially to the right. The same applies
	to function headers with a long argument list. Long strings are
	as well broken into shorter strings.

So not just "more" indent, but "substantially more".  (Although one
could quibble, this is "expression" not "statement".  Don't quibble.)


> and that the inner block code 
> (lines 3 and 4) should have more indent than line 2.

We disagree.  The "inner" block should in all cases have one-tab indent.

And CodingStyle says that line 2 should have "substantially more" indent...

Think of it this way:  when the condition becomes so complex that it
no longer fits on one line, that block should never be re-indented.
Only the condition needs to be reworked to fit into 80 columns.

The entire point of "substantially more" is to stand out from the normal
"indent by one tab" rule" ... so that it's not mistaken for anything
except a line-wrap reformat.


> Using 
> /^\t+\x20{2,8}/ on continuation line(s) is perfect because it does
> not cause either the continuation line(s) or the inner block code to
> move too much to the right.

No, that's a clear violation of CodingStyle on two separate points:
(a) the "always use tabs" rule, (b) the "substantially more" rule.

Note also that the notion of using spaces is for indents is clearly
described there as "heresy" .. your fu needs review if not overhaul.

- Dave




Return-Path: <linux-kernel-owner+w=401wt.eu-S1751165AbXDFTTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbXDFTTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXDFTTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:19:01 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:48413 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbXDFTS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:18:59 -0400
Date: Fri, 6 Apr 2007 21:16:00 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Brownell <david-b@pacbell.net>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
 blinky leds!!)
In-Reply-To: <200704061029.55710.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.61.0704061951580.6042@yvahk01.tjqt.qr>
References: <11757099691323-git-send-email-tony@atomide.com>
 <200704051119.11944.david-b@pacbell.net> <Pine.LNX.4.61.0704052232540.6042@yvahk01.tjqt.qr>
 <200704061029.55710.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 6 2007 10:29, David Brownell wrote:
>> Using 
>> /^\t+\x20{2,8}/ on continuation line(s) is perfect because it does
>> not cause either the continuation line(s) or the inner block code to
>> move too much to the right.
>
>No, that's a clear violation of CodingStyle on two separate points:
>(a) the "always use tabs" rule, (b) the "substantially more" rule.
>
>Note also that the notion of using spaces is for indents is clearly
>described there as "heresy" .. your fu needs review if not overhaul.

Well, I did not consider that "space" to be indent, as in:
if($previous_line_was_an_if)
	($indent, $padding) = (/^(\t+)(\x20{2,})/);
I do not want to argue about that now, though.



>And CodingStyle says that line 2 should have "substantially more" indent...
>
>Think of it this way:  when the condition becomes so complex that it
>no longer fits on one line, that block should never be re-indented.
>Only the condition needs to be reworked to fit into 80 columns.

If the condition becomes so complex that it's "too complex", it should
be split up into multiple ifs, or even functions, 



>So not just "more" indent, but "substantially more".  (Although one
>could quibble, this is "expression" not "statement".  Don't quibble.)
>
>> and that the inner block code 
>> (lines 3 and 4) should have more indent than line 2.
>
>We disagree.  The "inner" block should in all cases have one-tab indent.

You disagree. "We", as in, the kernel coders, though I do not speak for
them, seem to do it much the way I described, judging from the code they
wrote/write.

Please see the referenced perl script [1] that heuristically tries to figure
out the number of space-continued (SC) vs. tab-continued (TC) lines (L)
following an if (IF) statement.

	linux-2.6.21-rc6$ find . -type f -iname '*.[ch]' -print0 | \
		xargs -0 cat | ./findcont 

	L:7227630 IF:352877 NOCONT:309465 SC:30395 TC:8689 ##
	NOCONT: 87.7% SC:8.6% TC:2.5%

	(Does not quite add up to 100%, but I'll let someone
	else figure that out.)


Jan
====
[1] https://svn.ahn.hopto.org/hxtools/trunk/supp/findcont

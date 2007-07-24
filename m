Return-Path: <linux-kernel-owner+w=401wt.eu-S1762591AbXGXAG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591AbXGXAG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 20:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXGXAGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 20:06:49 -0400
Received: from xenotime.net ([66.160.160.81]:36376 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752432AbXGXAGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 20:06:48 -0400
Date: Mon, 23 Jul 2007 17:11:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-Id: <20070723171132.bc4d7b98.rdunlap@xenotime.net>
In-Reply-To: <46A534EA.6030008@intel.com>
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>
	<46A534EA.6030008@intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 16:08:26 -0700 Kok, Auke wrote:

> Andy Whitcroft wrote:
> > This version brings a number of new checks, and a number of bug
> > fixes.  Of note:
> > 
> >   - warnings for multiple assignments per line
> 
> 
> This is bugged. e.g. the following line will hit this exception check:
> 
> 	int i = some_function(a, b, c);

Agreed.

...

> This is a royal pain, since it now throws an ERROR for the obviously preferable 
> piece of code below:
> 
> if (err) {
> 	do_something();
> 	return -ERR;
> } else {
> 	do_somthing_else();
> }
> 
> 
> 
> Also, CondingStyle explicitly permits this style (even encourages it):

Yes, Linus has recently written that he prefers that style also.

The problem (to me at least) is that this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e659ba4a0d2d471c0d73590f78e1a1b5a1eede48

was not discussed before it was merged.  It was discussed a little bit
after it was merged.  Basically we have no concensus on this patch,
just a dictate (which we can all live with).



> ---
> Do not unnecessarily use braces where a single statement will do.
> 
> if (condition)
> 	action();
> 
> This does not apply if one branch of a conditional statement is a single
> statement. Use braces in both branches.
> 
> if (condition) {
> 	do_this();
> 	do_that();
> } else {
> 	otherwise();
> }
> ---
> 
> So, IMO this test needs to go, unless the script becomes smart enough to know 
> that either side of the else requires braces. It's definately not an ERROR.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

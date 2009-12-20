Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZLTRhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZLTRhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZLTRhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:37:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZLTRhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:37:17 -0500
Subject: Re: sched: restore sanity
From: Peter Zijlstra <peterz@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: San Mehat <san@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1261329743.30458.179.camel@Joe-Laptop.home>
References: <1261315437.4314.6.camel@laptop>
	 <20091220144925.GA19608@elte.hu> <1261320715.4314.9.camel@laptop>
	 <236ccac0912200703g464912b1r421497ebf3b6ebc6@mail.gmail.com>
	 <236ccac0912200705i369d00d1v42603a00e92039b6@mail.gmail.com>
	 <1261322387.4314.22.camel@laptop>
	 <1261329743.30458.179.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 18:36:32 +0100
Message-ID: <1261330592.4314.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 09:22 -0800, Joe Perches wrote:
> On Sun, 2009-12-20 at 16:19 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-12-20 at 07:05 -0800, San Mehat wrote:
> > > >> Probably, but the rest is just as annoying, pr_* is crap.
> > > Oh? Out of curiosity whats wrong with it?
> > That's what should be asked of printk().
> 
> pr_<level> offers some things printk cannot:
> 
> o standardization, eliminates frequent missing KERN_ levels
>   and missing/typo/misspelled module prefixes  

There's other ways of fixing that, one way is to make it a proper
function argument, like:

printk(char level, char *fmt, ...);

Which is something we have precedent for too in fprintf() and syslog().

> o visually shorter, fewer chars used, less 80 char wrapping

Fuck me senseless, visually less obvious too.

> o finer grained ability to eliminate unnecessary messages
>   for embedded systems

How is that not possible with another solution.

> o standardized mechanism to prefix messages with module/function

Who fucking gives a shit, that is the very thing that made me send the
revert.

> o eventual code reduction via use of a singleton instead of
>   duplicated module/function names

text reduction?

> o eventual dynamic_debug styled control of prefix by
>   module/function

Feh, who cares, printk output simply shouldn't be frequent enough to
need filtering, there's much better solutions for that.

> There are quite of number of arbitrarily named module wrapper
> macros and functions that build on printk.

Then remove them all..

Are you really arguing to fully deprecate printk()? If not this is all
going to be useless since I'll simply keep using printk().


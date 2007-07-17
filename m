Return-Path: <linux-kernel-owner+w=401wt.eu-S935810AbXGQSPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935810AbXGQSPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761665AbXGQSPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:15:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51977 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932655AbXGQSPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:15:22 -0400
Date: Tue, 17 Jul 2007 11:14:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, Greg KH <greg@kroah.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
In-Reply-To: <20070717100300.821650f5.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.0.999.0707171110540.27353@woody.linux-foundation.org>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org>
 <20070717154934.GA24231@elte.hu>
 <20070717100300.821650f5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, Randy Dunlap wrote:
>
> > +	if ((print_timestamp >= touch_timestamp &&
> > +			print_timestamp < (touch_timestamp + 1)) ||
> > +			did_panic || !per_cpu(watchdog_task, this_cpu)) {
> >  		return;
> > +	}
> >  
> >  	/* do not print during early bootup: */
> >  	if (unlikely(system_state != SYSTEM_RUNNING)) {
> 
> patch contains unneeded braces { }.

When there are issues with indentation, those braces are actually not 
unneeded any more, except for the compiler.

Just _look_ at the code. The indentation is not obvious, because the 
if-conditional itself is multiple lines, and indented (arguably wrongly so 
too, but that's another issue).

So it's no longer a trivial one-liner statement, it's a "multi-statement" 
spread out over multiple lines, and I think the braces are actually a good 
idea for things like that.

I also encourage people do do braces when you have nested indentation, ie

	if (something)
		if (somethingelse)
			return;

is actively *wrong*, while

	if (something) {
		if (somethingelse)
			return;
	}

is right, even though the braces are "unnecessary". Again, it's about the 
visual representation, not about whether the compiler needs them or not.

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759839AbXFVRYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839AbXFVRYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760010AbXFVRXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:23:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759999AbXFVRXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:23:52 -0400
Date: Fri, 22 Jun 2007 10:16:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
In-Reply-To: <20070622040014.234651401@goodmis.org>
Message-ID: <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
References: <20070622040014.234651401@goodmis.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jun 2007, Steven Rostedt wrote:
> 
> I just want to state that tasklets served their time well. But it's time
> to give them an honorable discharge.  So lets get rid of tasklets and
> given them a standing salute as they leave :-)

Well, independently of whether we actually discharge them or not, I do 
tend to always like things that split independent concepts up (whether 
they then end up being _implemented_ independently of each other or not is 
a separate issue).

So patches 1-4 all look fine to me. In fact, 5 looks ok too.

Whether we actually then want to do 6 is another matter. I think we'd need 
some measuring and discussion about that.

I'm absolutely 100% sure that we do *not* want to be in a situation where 
we have two different implementations of tasklets, and just keep the 
CONFIG variable and let people just choose one or the other.

So imnsho doing #6 is really something that makes sense only in a "let's 
measure this and decide which implementation is actually the better one", 
_not_ in the sense of merging it into the standard kernel and letting them 
fight it out in the long run.

But I'd happily merge 1-4 regardless after 2.6.22 is out.

Leaving patch 6 as a "only makes sense after we actually have some numbers 
about it", and patch 5 is a "could go either way" as far as I'm concerned 
(ie I could merge it together with the 1-4 series, but I think it's 
equally valid to just see it as a companion to 6).

Does that make sense to people?

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbXFXPnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbXFXPnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXFXPnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:43:24 -0400
Received: from vena.lwn.net ([206.168.112.25]:33147 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbXFXPnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:43:23 -0400
X-Greylist: delayed 1635 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jun 2007 11:43:23 EDT
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 22 Jun 2007 23:59:53 +0200."
             <20070622215953.GA22917@elte.hu> 
Date: Sun, 24 Jun 2007 09:16:07 -0600
Message-ID: <10876.1182698167@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> so how about the following, different approach: anyone who has a tasklet 
> in any performance-sensitive codepath, please yell now.

The cafe_ccic (OLPC) camera driver uses a tasklet to move frames out of
the DMA buffers in the streaming I/O path.  With this change in place,
I'd worry that the possibility of dropping frames would increase,
especially considering that (1) this is running on OLPC hardware, and 
(2) there is typically a streaming video application running in user
space. 

Obviously some testing is called for here.  I will make an attempt to do
that testing, but the next few weeks involve some insane travel which
will make that hard.  Stay tuned.

Thanks,

jon

Jonathan Corbet / LWN.net / corbet@lwn.net

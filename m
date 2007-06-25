Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbXFYVFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbXFYVFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXFYVFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:05:05 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:64134 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbXFYVFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:05:03 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <46802A98.4030407@imap.cc>
References: <10876.1182698167@lwn.net>  <467FF23B.30509@imap.cc>
	 <1182791203.5493.161.camel@localhost.localdomain>
	 <46802A98.4030407@imap.cc>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 17:03:29 -0400
Message-Id: <1182805409.5493.221.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 22:50 +0200, Tilman Schmidt wrote:

> Ok, I'm reassured. I'll look into converting these to a work queue
> then, although I can't promise when I'll get around to it.
> 
> In fact, if these timing requirements are so easy to meet, perhaps
> it doesn't even need its own work queue, and just making each
> tasklet into a work item and queueing them to the global queue
> with schedule_work() would do? Or am I getting too reckless now?

I'm sure you probably wouldn't have a problem with using just
schedule_work. But that's shared and you don't know with what. A
function in the keventd work queue can call schedule (not recommended,
but with closed source drivers, you'd never know. schedule_work is
EXPORT_SYMBOL not EXPORT_SYMBOL_GPL).

So, if you convert it to work queues, I'd strongly recommend adding a
new instance.

-- Steve



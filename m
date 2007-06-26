Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbXFZCDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbXFZCDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXFZCDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:03:05 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:61410 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbXFZCDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:03:02 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
	 <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 22:01:16 -0400
Message-Id: <1182823276.5493.240.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 18:46 -0700, Dan Williams wrote:
> 
> Context switches on this platform flush the L1 cache so bouncing
> between a workqueue and the MD thread is painful.

Why is context switches between two kernel threads flushing the L1
cache?  Is this a flaw in the ARM arch?  I would think the only thing
that needs to be done between a context switch of two kernel threads (or
even a user thread to a kernel thread) is update the general regs and
stack. The memory access (page_tables or whatever ARM uses) should stay
the same.

Perhaps something else is at fault here.

Thanks for testing!

-- Steve



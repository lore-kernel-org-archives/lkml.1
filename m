Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXF2O1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXF2O1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXF2O1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:27:47 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:41528 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752646AbXF2O1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:27:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=nUgu3IgfJQUy6rRcxHyVvvedUcW0WSKBLPs6JIinoJlPIffRtCVktfSEAbXq/cdC+teQqU/+lyUcOikulyhcMJnBY8VK7Fex+Rd0T7VpWxZX0qq6qCmnvBUVgBfTdpCn6oFNEhMLrWj43ky98gv359wpB+Hmk+Vxp7L6ZTW98n0=;
Date: Fri, 29 Jun 2007 18:27:31 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629142731.GA30957@ms2.inr.ac.ru>
References: <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <Pine.LNX.4.58.0706290919350.8866@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0706290919350.8866@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Not a very accurate measurement (jiffies that is).

Believe me or not, but the measurement has nanosecond precision.


> Since the work queue *is* a thread, you are running a busy loop here. Even
> though you call schedule, this thread still may have quota available, and
> will not yeild to the work queue.  Unless ofcourse this caller is of lower
> priority. But even then, I'm not sure how quickly the schedule would
> choose the work queue.

Instantly. That's why cnt is printed. Unless cnt==1000000, the result
is invalid.


> get it into -mm)  But the thing was is that tasklets IMHO are over used.

You preach to a choir. :-)

Alexey

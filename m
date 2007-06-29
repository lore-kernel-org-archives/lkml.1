Return-Path: <linux-kernel-owner+w=401wt.eu-S933914AbXF2Qfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbXF2Qfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXF2QfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:35:17 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:43800 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933073AbXF2QfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:35:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=T7yun7uuxNVK8xMuhlHw1f8h8Y8CDOONVo+aKDxi2oq4BbKHUp9V3R/aGLOCbnSrZpboJIj3T29wOcepPY4v5Yj2/kMJd/MzA14yIonGuHC9/exq930c0g0B6Rmnk7xwk8803hkx8/A7ihTYluhau6mnW4FG+W4g4vYV2bt+kO0=;
Date: Fri, 29 Jun 2007 20:34:09 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629163409.GB17709@ms2.inr.ac.ru>
References: <20070622040014.234651401@goodmis.org> <200706291348.21193.duncan.sands@math.u-psud.fr> <20070629133658.GB19021@ms2.inr.ac.ru> <200706291601.41680.duncan.sands@math.u-psud.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706291601.41680.duncan.sands@math.u-psud.fr>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> What changed? 

softirq remains raised for such tasklet. Old times softirq was processed
once per invocation, in schedule and on syscall exit and this was relatively
harmless. Since softirqs are very weakly moderated, it results in strong
cpu hogging. 


> And can it be fixed?

With current tasklets this can be fixed only introducing additional
synchronization cost to tasklet schedule. Not good. Better to fix
caller.

If Ingo knows about this, I guess it is already fixed in -rt tasklet
or can be fixed. They are really flexible and extensible:
-rt tasklet cost is so high, that even another thousand of cycles
will remain unnnoticed. :-)

Alexey

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZADO5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZADO5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 09:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZADO5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 09:57:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:44644 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750909AbZADO5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 09:57:33 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX190EdxuzGh04f08lGjuqulgbaFIKrrAFnu3PeaysH
	suNPalo7IwMayo
Date: Sun, 4 Jan 2009 15:57:26 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090104145726.GA14895@alice>
References: <20090102111819.GC6088@alice> <20090102175853.GC6842@linux.vnet.ibm.com> <20090102185303.GC5743@linux.vnet.ibm.com> <20090102195326.GF6842@linux.vnet.ibm.com> <20090102231239.GA19778@alice> <20090103015748.GL6842@linux.vnet.ibm.com> <20090103094003.GA6149@alice> <20090104013254.GG6958@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090104013254.GG6958@linux.vnet.ibm.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 15:56:05 up  2:22,  9 users,  load average: 0.18, 0.54, 0.53
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sat, Jan 03, 2009 at 10:40:03AM +0100, Eric Sesterhenn wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Sat, Jan 03, 2009 at 12:12:39AM +0100, Eric Sesterhenn wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > 
> > > > I tried to apply the patch from
> > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=392ddc32982a5c661dd90dd49a3cb37f1c68b782;hp=bb799ca0202a360fa74d5f17039b9100caebdde7
> > > > but get a message that it is already applied. Seems i already got that
> > > > one.
> > > 
> > > Is your configuration able to support ftrace?
> > 
> > yes
> > 
> > > Looks like someone is (wrongly) freeing some memory that was sent to
> > > call_rcu(), and ftrace might be one way to locate the problem.
> > 
> > I set the filter to call_rcu() and call_rcu_sched(), reproduced the
> > oops, and got this in the trace file.
> 
> Hmmm...  The only unique ones are _rcu_barrier() used during module
> removal by rcutorture and rt_worker_func(), which occurs near the
> beginning of the trace.  My next step would be to trace the addresses of
> rcu_head structures passed to call_rcu() and friends and to also trace
> the addresses of the structures as they are invoked (where the original
> NULL-pointer exception occurred).
> 
> Is this tracing something you would be interested in taking on?  My
> test setup is having some trouble, so it would probably be a couple of
> days before I got it working.  :-/

Just tell me what i need to do, I am not really familiar with ftrace.
I am only able to test 2.6.28-04980-gb58602a, since current -git is not
able to boot on this box :|

Greetings, Eric

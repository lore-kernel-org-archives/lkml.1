Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYLCAsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYLCAsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754091AbYLCAsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:48:06 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51244 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbYLCAsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:48:03 -0500
Date: Tue, 2 Dec 2008 16:47:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de
Subject: Re: [PATCH -tip] v9 scalable classic RCU implementation
Message-ID: <20081203004759.GG6719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081202222157.GA14911@linux.vnet.ibm.com> <20081202233144.GE6703@one.firstfloor.org> <20081202235145.GF6719@linux.vnet.ibm.com> <20081203001811.GF6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203001811.GF6703@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 01:18:12AM +0100, Andi Kleen wrote:
> On Tue, Dec 02, 2008 at 03:51:45PM -0800, Paul E. McKenney wrote:
> > On Wed, Dec 03, 2008 at 12:31:44AM +0100, Andi Kleen wrote:
> > > > o	I now test with a more brutal random-selection online/offline
> > > > 	script (attached).  Probably more brutal than it needs to be
> > > > 	on the people reading it as well, but so it goes.
> > > 
> > > Does that cover both dynticks on and off? afaik the dynticks off problem
> > > I ran into on a 16 thread box and we discussed some time ago is still there.
> > 
> > The failures I see with this patch I also see with mainline.  Are you
> > seeing something with this patch that does not happen with mainline?
> 
> No, that is in mainline too. Sorry to be misleading. Do you see the
> same problems in your testing?

On Power, I see a hang in all three flavors of RCU when CPU hotplug
is enabled and dynticks is not.  I have not yet seen this hang on x86.
On Power, the hang occurs in the CPU-offline code, and is identical to
the hangs I was seeing in 2.6.27, except that "sleep 1" does not hang
in recent 2.6.28 versions.  So the timeout is apparently failing to fire
(or being ignored) for some other reason.

Is this similar to what you are seeing on x86?

I am currently undergoing a line-by-line code walkthrough of rcutree on
the off-chance that all three versions of RCU suffer from the same bug.
(And I have found a few bugs and spelling errors, but nothing related
to the problem at hand.)  If I don't find anything, I will start looking
more closely at the CPU-hotplug code.

							Thanx, Paul

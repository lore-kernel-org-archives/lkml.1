Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYJILyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYJILyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYJILyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:54:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59074 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbYJILyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:54:09 -0400
Date: Thu, 9 Oct 2008 04:54:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Message-ID: <20081009115407.GD6628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <c62985530810090323vd5d08e0haa618ca0cbe0c73f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810090323vd5d08e0haa618ca0cbe0c73f@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 12:23:13PM +0200, Frédéric Weisbecker wrote:
> 2008/10/9 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > Hello!
> >
> > This is a tracing patch for Classic RCU, which creates an "rcu/rcucb"
> > file in debugfs.  This patch can be handy when you need to work out
> > why RCU is refusing to end the current grace period.
> >
> > Reading from the file results in something like the following:
> >
> >        rcu: cur=1129  completed=1128  np=0  s=0
> >                0,3,7
> >        rcu_bh: cur=-287  completed=-287  np=0  s=0
> >
> >        online: 0-7
> 
> 
> Hi Paul,
> 
> Why don't you use the ring-buffer tracing engine?
> You will really make your life better by putting it as a tracer in
> kernel/trace and by using the relevant API.
> That will avoid you to manage the debugfs things, the memory
> allocation, the buffer managment.....

Hello, Frédéric,

Well, one reason is that I didn't know about it.  ;-)

Does it allow the user to trigger a one-shot trace?  Right now, what
one does is:

	cat /debug/rcu/rcucb

whenever one wants to see what RCU is up to.  You really don't want to
see every new value, as that would generate hundreds of trace records
per second -- per CPU.  What does the user do with the ring-buffer
tracing enging?

							Thanx, Paul

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZKVRl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZKVRl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 12:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbZKVRl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 12:41:56 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54480 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZKVRlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 12:41:55 -0500
Date: Sun, 22 Nov 2009 09:42:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 0/3] rcu: resend of grace-period stall and
	cleanup patches
Message-ID: <20091122174203.GE9029@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091122165321.GA19922@linux.vnet.ibm.com> <20091122170542.GA12827@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091122170542.GA12827@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 12:05:42PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > Hello!
> > 
> > This patch series is a resend of the three RCU patches that are candidates
> > for the upcoming 2.6.33 merge window, but that are not yet in -tip.
> > These are:
> > 
> > 1.	A fix for a grace-period-stall bug that occurs on large
> > 	machines.
> [...]
> 
> Hi Paul,
> 
> I was thinking about the last bugs you discovered. Some caracteristics
> they had in common were that they occur only on large marchines (32+ or
> 64+ CPUs). This is caused by the fact that some of your code is only
> covered by tests when the number of CPUs go over the architecture size
> (in bits).
> 
> I managed to cover this kind of scenario with smaller state-space in the
> LTTng formal models (but it also applies to kernel code) by tweaking the
> code, with bitmasks, to ensure that the number of bits the code uses is,
> e.g., no more than the minimum amount of required bits. Therefore, you
> are ensured to run into overflow scenarios either more quickly or, as in
> this case, on decently-sized hardware.

You mean by setting CONFIG_RCU_FANOUT=2 in order to get three levels
of rcu_node hierarchy on an eight-CPU machine, which would otherwise
require more than 1024 CPU on a 32-bit system or more that 4096 CPUs on
a 64-bit system?  ;-)

http://paulmck.livejournal.com/14969.html

But yes, the largest machine I have access to has "only" 128 CPUs,
and it is often heavily used by others.  So I heartily agree with
your point, which is that we should use various techniques to test
code on smaller machines in ways that larger machines will stress it.
Of course, my favorite such technique is differential profiling, which
allows performance results collected on small machines to reveal problems
that would only show up on large machines:

http://www.rdrop.com/users/paulmck/scalability/paper/profiling.2002.06.04.pdf

(This is a revision of a paper that appeared in the 1995 MASCOTS
conference and in the 1999 Software Practice & Experience journal.)

							Thanx, Paul

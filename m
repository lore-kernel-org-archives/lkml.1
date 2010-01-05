Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228Ab0AECDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0AECDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983Ab0AECDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:03:49 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60637 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab0AECDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:03:47 -0500
Date: Mon, 4 Jan 2010 18:03:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [PATCH tip/core/rcu 0/8] rcu: add lockdep-based diagnostics to
	rcu_dereference()
Message-ID: <20100105020345.GA32114@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series adds lockdep-based checking to the rcu_dereference()
primitive in order to flag misuses of RCU.  The first three patches
put the RCU infrastructure in place, while the last five use this
infrastructure in the net, sched, vfs, radix-tree, and idr subsystems.
There are very likely additional changes required.

							Thanx, Paul


 b/fs/file.c                     |    2 
 b/include/linux/cgroup.h        |    2 
 b/include/linux/cred.h          |    2 
 b/include/linux/fdtable.h       |    8 +-
 b/include/linux/rculist.h       |   14 ++--
 b/include/linux/rculist_nulls.h |    5 -
 b/include/linux/rcupdate.h      |  124 ++++++++++++++++++++++++++++++++++++----
 b/include/linux/srcu.h          |   87 +++++++++++++++++++++++++++-
 b/init/main.c                   |    2 
 b/kernel/exit.c                 |   14 +++-
 b/kernel/fork.c                 |    1 
 b/kernel/notifier.c             |    6 -
 b/kernel/pid.c                  |    2 
 b/kernel/rcupdate.c             |   10 +++
 b/kernel/rcutorture.c           |   12 +++
 b/kernel/sched.c                |    7 --
 b/kernel/srcu.c                 |   50 ++++++++++------
 b/lib/debug_locks.c             |    2 
 b/lib/idr.c                     |    9 +-
 b/lib/radix-tree.c              |   25 +++-----
 b/net/core/dev.c                |    2 
 b/net/core/filter.c             |    6 -
 b/net/core/sock.c               |    2 
 b/net/decnet/dn_route.c         |   14 ++--
 b/net/ipv4/route.c              |   14 ++--
 b/net/packet/af_packet.c        |    3 
 include/linux/rcupdate.h        |   45 ++++++++++----
 include/linux/srcu.h            |    9 ++
 28 files changed, 369 insertions(+), 110 deletions(-)

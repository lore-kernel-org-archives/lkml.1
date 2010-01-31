Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294Ab0AaVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0AaVMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 16:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299Ab0AaVMR
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 16:12:17 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60138 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab0AaVMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 16:12:16 -0500
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 16:12:16 EST
Message-Id: <20100131205254.407214951@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 31 Jan 2010 15:52:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: [patch 0/3] introduce sys_membarrier(): process-wide memory barrier (v8)
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sun, 31 Jan 2010 21:00:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an updated version of the sys_membarrier system call. It implements a
system call that allows userspace to distribute the overhead of memory barriers
asymmetrically. It is particularly useful for Userspace RCU (liburcu), to allow
the RCU read-side to only issue compiler barriers, matched by calls to
sys_membarrier() in the userspace synchronize_rcu().

Even though sys_membarrier should be portable to other architecture as-is
without arch-specific modifications, I propose to incrementally reserve the
system call IDs as we test it on each architecture.

Here is a version that I think should be ready for merging. It is based on the
2.6.33-rc6 kernel. I would appreciate if people who gave their Acked-by in the
RFC rounds could confirm their Acked-by following the patch set updates.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZJRX3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZJRX3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 19:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZJRX3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 19:29:15 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:58312 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753952AbZJRX3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 19:29:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEAL4720pMRK1g/2dsb2JhbACBU9dqhDEE
Date: Sun, 18 Oct 2009 19:29:18 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Kernel RCU: shrink the size of the struct rcu_head
Message-ID: <20091018232918.GA7385@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:20:14 up 61 days, 10:09,  4 users,  load average: 2.24, 1.16,
	0.77
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I noticed that you already discussed the possibility of shrinking the
struct rcu_head by removing the function pointer.
(http://kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html)

The ideas brought in so far require having per-callback lists, which
involves a bit of management overhead and don't permit keeping the
call_rcu() in cpu order.

You might want to look into the Userspace RCU urcu-defer.c
implementation, where I perform pointer encoding to compact the usual
case, expected to be the same callback passed as parameter multiple
times in a row to call_rcu(). This is very typical with multiple free()
calls for different data structures next to each other.

This typically keeps the size of the information to encode per callback
down to a minimum: the size of a single pointer. It would be good to
trace the kernel usage of call_rcu() to see if my assumption holds.

I just thought I should tell you before you start looking at this
issue further.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

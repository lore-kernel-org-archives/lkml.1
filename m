Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbZKCPHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbZKCPHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbZKCPHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:07:36 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:37402 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZKCPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:07:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0EADPV70pGGN1W/2dsb2JhbACBUN0WhD0E
Date: Tue, 3 Nov 2009 10:02:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: [RELEASE] Userspace RCU 0.3.0
Message-ID: <20091103150234.GA20060@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:53:41 up 77 days,  1:43,  3 users,  load average: 0.55, 0.45,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I released userspace RCU 0.3.0, which includes a small API change for
the "deferred work" interface. After discussion with Paul, I decided to
drop the support for call_rcu() and only provide defer_rcu(), to make
sure I don't provide an API with the same name as the kernel RCU but
with different arguments and semantic. It will generate the following
linker error if used:

file.c:240: undefined reference to 
   `__error_call_rcu_not_implemented_please_use_defer_rcu'

Note that defer_rcu() should *not* be used in RCU read-side C.S.,
because it calls synchronize_rcu() if the queue is full. This is a major
distinction from call_rcu(). (note to self: eventually we should add
some self-check code to detect defer_rcu() nested within RCU read-side
C.S.).

I plan to eventually implement a proper call_rcu() within the userspace
RCU library. It's not, however, a short-term need for me at the moment.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

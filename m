Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYI2PL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYI2PL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYI2PLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:11:50 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:41847 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYI2PLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:11:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAL+L4EhMQWq+/2dsb2JhbACBYrowgWc
Date: Mon, 29 Sep 2008 11:11:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeremy Kerr <jk@ozlabs.org>,
       linuxppc-dev@ozlabs.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] sputrace : use marker_synchronize_unregister()
Message-ID: <20080929151147.GH11245@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080929082722.GB18663@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:10:54 up 116 days, 19:51,  9 users,  load average: 0.58, 0.62,
	0.51
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need a marker_synchronize_unregister() before the end of exit() to make sure
every probe callers have exited the non preemptible section and thus are not
executing the probe code anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Kerr <jk@ozlabs.org>
CC: linuxppc-dev@ozlabs.org
CC: Christoph Hellwig <hch@infradead.org>
---
 arch/powerpc/platforms/cell/spufs/sputrace.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/sputrace.c	2008-07-31 09:34:58.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.c	2008-07-31 09:35:15.000000000 -0400
@@ -233,6 +233,7 @@ static void __exit sputrace_exit(void)
 
 	remove_proc_entry("sputrace", NULL);
 	kfree(sputrace_log);
+	marker_synchronize_unregister();
 }
 
 module_init(sputrace_init);
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

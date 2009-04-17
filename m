Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZDQCiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZDQCiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZDQCiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:38:06 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:47845 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754849AbZDQCiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:38:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEACuI50lMQW1W/2dsb2JhbACBTs5Dg30G
Date: Thu, 16 Apr 2009 22:38:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h (update)
Message-ID: <20090417023802.GA26612@Krystal>
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:37:05 up 47 days, 23:03,  1 user,  load average: 0.82, 0.72,
	0.61
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Thu, 16 Apr 2009, Jeremy Fitzhardinge wrote:
> 
> > I don't think this helps.  rcupdate_types.h uses preempt_disable/enable, but
> > doesn't include linux/preempt.h for them - but someone's going to have to, so
> > you've got an implicit dependency on the user to #include the right headers in
> > advance.
> 
> Would including linux/preempt.h in rcupdate_types.h be a problem?
> 
> -- Steve
> 

Here is the updated patch to tracepoint.h that includes preempt.h.


tracepoints : remove rcupdate.h dependency

Use the slimmer rcupdate_types.h instead of the fat rcupdate.h.

Changelog : include preempt.h from tracepoint.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>
---
 include/linux/tracepoint.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux.trees.git/include/linux/tracepoint.h
===================================================================
--- linux.trees.git.orig/include/linux/tracepoint.h	2009-04-16 20:32:27.000000000 -0400
+++ linux.trees.git/include/linux/tracepoint.h	2009-04-16 22:13:53.000000000 -0400
@@ -15,7 +15,8 @@
  */
 
 #include <linux/types.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_types.h>
+#include <linux/preempt.h>
 
 struct module;
 struct tracepoint;
@@ -150,11 +151,11 @@ extern int tracepoint_get_iter_range(str
  * tracepoint_synchronize_unregister must be called between the last tracepoint
  * probe unregistration and the end of module exit to make sure there is no
  * caller executing a probe when it is freed.
+ * Using a define rather than a static inline to make sure tracepoint.h does not
+ * depend on rcupdate.h. rcupdate.h must be included whenever
+ * tracepoint_synchronize_unregister() is used.
  */
-static inline void tracepoint_synchronize_unregister(void)
-{
-	synchronize_sched();
-}
+#define tracepoint_synchronize_unregister() synchronize_sched()
 
 #define PARAMS(args...) args
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

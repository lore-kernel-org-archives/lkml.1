Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZEUXc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZEUXc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZEUXcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:32:48 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2619 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZEUXcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:32:47 -0400
Subject: Re: [PATCH 1/3] kernel.h: Add DO_ONCE statement expression macro
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       x86@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <4A15E36E.9080501@oracle.com>
References: <cover.1242943463.git.joe@perches.com>
	 <7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
	 <4A15E36E.9080501@oracle.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 16:32:42 -0700
Message-Id: <1242948762.3373.143.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 16:27 -0700, Randy Dunlap wrote:
> Joe Perches wrote:
> > Add a DO_ONCE statement expression analogous to printk_once
> > that executes any arbitrary statement exactly once.
> Since x is of arbitrary size & time duration, I think that x; should follow
> 		__done = true;
> instead of being before it, as was done in printk_once().  Otherwise there
> could be a sizable window there x could be done more than once.

Makes sense to me.

Add a DO_ONCE statement expression analogous to printk_once
that executes any arbitrary statement exactly once.

This will take the place of printk_once so that
DO_ONCE(pr_<foo>) or any other statement performed
a single time may be easily written.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..a5520c9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -637,7 +637,18 @@ static inline void ftrace_dump(void) { }
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/*
+ * Do something once (analogous to WARN_ONCE() et al):
+ */
+#define DO_ONCE(x...) ({			\
+	static bool __done = false;		\
+						\
+	if (!__done) {				\
+		__done = true;			\
+		x;				\
+	}					\
+})
+
 /**
  * container_of - cast a member of a structure out to the containing structure
  * @ptr:	the pointer to the member.
-- 
1.6.3.1.10.g659a0.dirty




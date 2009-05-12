Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbZELK74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbZELK74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZELK7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:59:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:41885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbZELK7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:59:45 -0400
Subject: [PATCH] perf_counter: fix ioctl()s
From: Peter Zijlstra <peterz@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200905120952.12847.arnd@arndb.de>
References: <20090508165219.469818319@chello.nl>
	 <1242109650.11251.313.camel@twins> <1242112226.11251.315.camel@twins>
	 <200905120952.12847.arnd@arndb.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 12 May 2009 12:59:33 +0200
Message-Id: <1242125974.11251.329.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 09:52 +0200, Arnd Bergmann wrote:
> On Tuesday 12 May 2009, Peter Zijlstra wrote:
> > Ah, so _IO() gets an unsigned long 3rd argument.
> > _IOW() treats the 3rd arg as a (type __user *) and copies the bits over
> > _IOR() copies the bits back out to userspace
> > _IORW() does both
> > 
> > In which case the below should fix things up, no?
> > 
> 
> Yes, this looks good now.

---
Arnd spotted that I misunderstood and wrongly used the 3rd ioctl
argument. Fix up the perf counter ioctl()s to use the 3rd argument as
value -- as opposed to a pointer as would now be the case.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 614f921..6a9cebc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -159,10 +159,10 @@ struct perf_counter_hw_event {
 /*
  * Ioctls that can be done on a perf counter fd:
  */
-#define PERF_COUNTER_IOC_ENABLE		_IOW('$', 0, u32)
-#define PERF_COUNTER_IOC_DISABLE	_IOW('$', 1, u32)
-#define PERF_COUNTER_IOC_REFRESH	_IOW('$', 2, u32)
-#define PERF_COUNTER_IOC_RESET		_IOW('$', 3, u32)
+#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
+#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
+#define PERF_COUNTER_IOC_REFRESH	_IO('$', 2)
+#define PERF_COUNTER_IOC_RESET		_IO('$', 3)
 
 enum perf_counter_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,


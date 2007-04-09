Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXDIWBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXDIWBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXDIWBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:01:42 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38535 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbXDIWBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:01:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Apr 2007 00:01:15 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: <linux/wait.h> uses definitions from <linux/sched.h> (was Re:
 2.6.21-rc6-mm1)
To: linux1394-devel@lists.sourceforge.net
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Torsten Kaiser <just.for.lkml@googlemail.com>
In-Reply-To: <461AB361.5050207@s5r6.in-berlin.de>
Message-ID: <tkrat.07a56906742bb41b@s5r6.in-berlin.de>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <64bb37e0704091203m7cb4adc9g1bf6bf179603cf4a@mail.gmail.com>
 <461AB361.5050207@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote at lkml:
> Torsten Kaiser wrote:
>> drivers/ieee1394/ieee1394_transactions.c fails for me if CONFIG_SMP=n
>> 
>> gcc complains:
>>  CC      drivers/ieee1394/ieee1394_transactions.o
>> drivers/ieee1394/ieee1394_transactions.c: In function 'hpsb_get_tlabel':
>> drivers/ieee1394/ieee1394_transactions.c:183: error:
>> 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
> [...]
>> I fixed this by adding #include <linux/sched.h> before #include
>> <linux/wait.h>
>> But that is probably not the correct fix, but gives me a working kernel.
> 
> Thanks, I'll add this to linux1394-2.6.git (which exposed the problem)
> ASAP.  On the other hand, the culprit is actually include/linux/wait.h
> which IMO should include the headers it needs for itself.

And while I am at it:


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: some more includes

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/ieee1394_transactions.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/ieee1394/ieee1394_transactions.c
===================================================================
--- linux.orig/drivers/ieee1394/ieee1394_transactions.c
+++ linux/drivers/ieee1394/ieee1394_transactions.c
@@ -10,13 +10,16 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/compiler.h>
 #include <linux/hardirq.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/sched.h>  /* because linux/wait.h is broken if CONFIG_SMP=n */
 #include <linux/wait.h>
 
 #include <asm/bug.h>
 #include <asm/errno.h>
+#include <asm/system.h>
 
 #include "ieee1394.h"
 #include "ieee1394_types.h"


-- 
Stefan Richter
-=====-=-=== -=-- -=--=
http://arcgraph.de/sr/


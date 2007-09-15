Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbXIOJEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbXIOJEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 05:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbXIOJEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 05:04:16 -0400
Received: from web52004.mail.re2.yahoo.com ([206.190.49.251]:47978 "HELO
	web52004.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755269AbXIOJEP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 05:04:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xe/DT6losEyELvJ11q7wZRzd6FVprJMiituGbCze5T24BU9/mBw6h62Sxy7UGGfV+JptlbVAJqO/3ajPhPifX5+8l0fnln8xvyS6ssaFlHqjIb/FQRjg9LN4LAcu0OtHnSdutbYZ1cRWLIIIMkVfPBMi7QX5bLuH/yqwLTcfn/s=;
X-YMail-OSG: fMt8H8gVM1kSY1KxpcRoWNeRDjLQ6Et1JpV6HGg2QJv_GnHLy8ft6eWminzzD25BR8rJSDSJyb2KDen1wWVkeEHgeQ_7TCkT39wXJbUtgWbr3iFlm1Z3Q92nHuH1Pw--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Sat, 15 Sep 2007 02:04:13 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: include/linux/mutex.h file is unclear about software interrupts and mutex_trylock
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: mingo@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <79726.86356.qm@web52004.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

include/linux/mutex.h file is unclear about software interrupts and the return value of mutex_trylock.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

---

--- linux-2.6.23-rc6/include/linux/mutex.h    2007-09-09 09:55:34.917468000 +0300
+++ linux-2.6.23/include/linux/mutex.h    2007-09-15 11:49:28.353291500 +0300
@@ -29,7 +29,8 @@
  * - task may not exit with mutex held
  * - memory areas where held locks reside must not be freed
  * - held mutexes must not be reinitialized
- * - mutexes may not be used in irq contexts
+ * - mutexes may not be used in hardware or software interrupt
+ *   contexts such as tasklets and timers
  *
  * These semantics are fully enforced when DEBUG_MUTEXES is
  * enabled. Furthermore, besides enforcing the above rules, the mutex
@@ -133,6 +134,7 @@ extern int __must_check mutex_lock_inter
 #endif
 
 /*
+ * mutex_trylock returns nonzero on success or 0 on failure to lock.
  * NOTE: mutex_trylock() follows the spin_trylock() convention,
  *       not the down_trylock() convention!
  */






      Die etwas anderen Infos rund um das Thema Reisen. BE A BETTER WELTENBUMMLER!  www.yahoo.de/clever

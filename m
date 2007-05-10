Return-Path: <linux-kernel-owner+w=401wt.eu-S1761723AbXEJTDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761723AbXEJTDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbXEJTD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:03:27 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:54333 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbXEJTD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:03:26 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Fri, 11 May 2007 00:32:02 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, mingo@elte.hu, sripathik@in.ibm.com
Subject: [PATCH -mm 2/2] Reintroduce write_trylock_irqsave()
Message-ID: <Pine.LNX.4.64.0705110031050.30531@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reintroduce the new write_trylock_irqsave() implementation: slightly faster,
less invasive and similar in style to the implementation of
spin_trylock_irqsave() in mainline and -mm.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>

---

  include/linux/spinlock.h |    7 +++++++
  1 file changed, 7 insertions(+)

---

diff -ruNp a/include/linux/spinlock.h b/include/linux/spinlock.h
--- a/include/linux/spinlock.h	2007-05-11 00:25:34.000000000 +0530
+++ b/include/linux/spinlock.h	2007-05-11 00:27:35.000000000 +0530
@@ -282,6 +282,13 @@ do {						\
  	1 : ({ local_irq_restore(flags); 0; }); \
  })

+#define write_trylock_irqsave(lock, flags) \
+({ \
+	local_irq_save(flags); \
+	write_trylock(lock) ? \
+	1 : ({ local_irq_restore(flags); 0; }); \
+})
+
  /*
   * Locks two spinlocks l1 and l2.
   * l1_first indicates if spinlock l1 should be taken first.


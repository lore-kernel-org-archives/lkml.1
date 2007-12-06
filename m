Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbXLFXVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbXLFXVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbXLFXUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:20:25 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50762 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbXLFXUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:20:21 -0500
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: [PATCH 4/6] syslets: add indirect args
Date: Thu,  6 Dec 2007 15:20:17 -0800
Message-Id: <1196983219370-git-send-email-zach.brown@oracle.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11969832192868-git-send-email-zach.brown@oracle.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
 <11969832193635-git-send-email-zach.brown@oracle.com>
 <1196983219225-git-send-email-zach.brown@oracle.com>
 <11969832192868-git-send-email-zach.brown@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the syslet indirect args to the indirect_params union.

This is broken, but it lets us simply demonstrate the rest of the syslet
universe around the indirect argument passing convention.

A caller could well want to perform a syscall that uses indirect arguments as a
syscall.  Maybe we turn indirect_params into a struct that contains a union for
arguments which can never be used concurrently.  This needs wider discussion.

Signed-off-by: Zach Brown <zach.brown@oracle.com>

diff --git a/include/linux/indirect.h b/include/linux/indirect.h
index 97f9ac4..5d5abd7 100644
--- a/include/linux/indirect.h
+++ b/include/linux/indirect.h
@@ -3,6 +3,7 @@
 #define _LINUX_INDIRECT_H
 
 #include <asm/indirect.h>
+#include <linux/syslet-abi.h>
 
 
 /* IMPORTANT:
@@ -14,6 +15,7 @@ union indirect_params {
   struct {
     int flags;
   } file_flags;
+  struct syslet_args syslet;
 };
 
 #define INDIRECT_PARAM(set, name) current->indirect_params.set.name
-- 
1.5.2.2


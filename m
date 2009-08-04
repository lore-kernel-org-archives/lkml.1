Return-Path: <linux-kernel-owner+w=401wt.eu-S933621AbZHDXa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621AbZHDXa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933610AbZHDXa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:30:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45908 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609AbZHDXay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:30:54 -0400
Subject: [PATCH -rt] Fix build error with !CONFIG_PREEMPT_RT
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, Darren Hart <dvhltc@us.ibm.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 16:30:52 -0700
Message-Id: <1249428652.3289.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,
	Here's a small build fix to get !CONFIG_PREEMPT_RT +
CONFIG_PREEMPT_HARDIRQS to build. Not sure why this change was
introduced between 2.6.29-rt and 2.6.31-rt, but this sets it back.

Tested with and without CONFIG_PREEMPT_RT and with and without
CONFIG_PREEMPT_HARDIRQS.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

Index: 2.6.31-rc4-rt1/include/linux/bottom_half.h
===================================================================
--- 2.6.31-rc4-rt1.orig/include/linux/bottom_half.h	2009-08-04 16:14:13.000000000 -0700
+++ 2.6.31-rc4-rt1/include/linux/bottom_half.h	2009-08-04 16:14:25.000000000 -0700
@@ -1,7 +1,7 @@
 #ifndef _LINUX_BH_H
 #define _LINUX_BH_H
 
-#ifdef CONFIG_PREEMPT_RT
+#ifdef CONFIG_PREEMPT_HARDIRQS
 # define local_bh_disable()		do { } while (0)
 # define __local_bh_disable(ip)		do { } while (0)
 # define _local_bh_enable()		do { } while (0)



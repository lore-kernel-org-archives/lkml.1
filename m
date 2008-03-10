Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYCJGdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYCJGdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 02:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYCJGdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 02:33:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:47681 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYCJGdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 02:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=QvOv2AhquPjABSamXWAUCQoA9Daf9D0Sfs7glxHOg0YA4brhTMIsQj281A6aE/40TQ3bdEvtZ7rtX+Eq4rce3ii/kxfdeVB0EbV1HF4q99ujVaxB4tGnxBUP6mTgEr+/jeuufRG3C+DWX+Qdqwg7PF07QYFJ/vWerBgYdAf3ZtM=
Date: Mon, 10 Mar 2008 14:39:22 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com
Subject: [PATCH] [3/3] Use WARN_ON_SECS in rcupreempt.h
Message-ID: <20080310063922.GC6745@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use WARN_ON_SECS in rcupreempt.h to avoid warning flood 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/linux/rcupreempt.h |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -upr linux/include/linux/rcupreempt.h linux.new/include/linux/rcupreempt.h
--- linux/include/linux/rcupreempt.h	2008-03-10 13:33:13.000000000 +0800
+++ linux.new/include/linux/rcupreempt.h	2008-03-10 13:32:35.000000000 +0800
@@ -88,7 +88,7 @@ DECLARE_PER_CPU(long, dynticks_progress_
 static inline void rcu_enter_nohz(void)
 {
 	__get_cpu_var(dynticks_progress_counter)++;
-	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
+	WARN_ON_SECS(__get_cpu_var(dynticks_progress_counter) & 0x1, 10);
 	mb();
 }
 
@@ -96,7 +96,7 @@ static inline void rcu_exit_nohz(void)
 {
 	mb();
 	__get_cpu_var(dynticks_progress_counter)++;
-	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
+	WARN_ON_SECS(!(__get_cpu_var(dynticks_progress_counter) & 0x1), 10);
 }
 
 #else /* CONFIG_NO_HZ */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYCGDDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYCGDDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 22:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYCGDDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 22:03:09 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:56984 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYCGDDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 22:03:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=pojyDcQ0V/P00PBHoBGy4BHH+x5GauPvK2WYvSbBeBkntLzYw2x+uh7iCWXpnZBA53muV2Kbs+TvAk1OhHRnAoWX1L2xJk2Rv1t1Bbk1qvLQtdlPxzmNWgIl0+bWQp2pYkDLC/Jk4aoM3dUZVMW9MgiULiYsMobTbNdlPnwomso=
Date: Fri, 7 Mar 2008 11:09:01 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH RFC] add time_after_now and other macros which compare with
	jiffies
Message-ID: <20080307030901.GA4375@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of time_after like macros users just compare jiffies and
another number, so here add some other _now macros to do it.

Another aproach is changing original time_ macros to use jiffies to compare,
add a generic compare macro like time_compare(a, b)

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
jiffies.h |    8 ++++++++
1 file changed, 8 insertions(+)

diff -upr linux/include/linux/jiffies.h linux.new/include/linux/jiffies.h
--- linux/include/linux/jiffies.h	2008-03-07 10:40:04.000000000 +0800
+++ linux.new/include/linux/jiffies.h	2008-03-07 10:50:12.000000000 +0800
@@ -134,6 +134,14 @@ static inline u64 get_jiffies_64(void)
 	 ((__s64)(a) - (__s64)(b) >= 0))
 #define time_before_eq64(a,b)	time_after_eq64(b,a)
 
+#define time_after_now(a) time_after(jiffies, a)
+
+#define time_before_now(a) time_before(jiffies, a)
+
+#define time_after_eq_now(a) time_after_eq(jiffies, a)
+
+#define time_before_eq_now(a) time_before_eq(jiffies, a)
+
 /*
  * Have the 32 bit jiffies value wrap 5 minutes after boot
  * so jiffies wrap bugs show up earlier.

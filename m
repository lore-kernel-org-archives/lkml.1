Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbXJQXG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbXJQXG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758880AbXJQXGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:06:20 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51370 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036AbXJQXGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:06:20 -0400
Subject: [PATCH] Move _rtc_time() routines under CONFIG_ADB_CUDA
From: Badari Pulavarty <pbadari@us.ibm.com>
To: linuxppc-dev@ozlabs.org
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 16:09:38 -0700
Message-Id: <1192662578.14504.11.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to clean up compile warnings (against 2.6.23-git12)

Thanks,
Badari

to_rtc_time() and from_rtc_time() seems to be used only if CONFIG_ADB_CUDA
defined. Moving them under that ifdef.

arch/powerpc/platforms/powermac/time.c:88: warning: `to_rtc_time' defined but not used
arch/powerpc/platforms/powermac/time.c:95: warning: `from_rtc_time' defined but not used

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 arch/powerpc/platforms/powermac/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/arch/powerpc/platforms/powermac/time.c
===================================================================
--- linux-2.6.23.orig/arch/powerpc/platforms/powermac/time.c	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23/arch/powerpc/platforms/powermac/time.c	2007-10-17 15:59:56.000000000 -0700
@@ -84,6 +84,7 @@ long __init pmac_time_init(void)
 	return delta;
 }
 
+#ifdef CONFIG_ADB_CUDA
 static void to_rtc_time(unsigned long now, struct rtc_time *tm)
 {
 	to_tm(now, tm);
@@ -97,7 +98,6 @@ static unsigned long from_rtc_time(struc
 		      tm->tm_hour, tm->tm_min, tm->tm_sec);
 }
 
-#ifdef CONFIG_ADB_CUDA
 static unsigned long cuda_get_time(void)
 {
 	struct adb_request req;



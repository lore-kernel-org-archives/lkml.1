Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbXL1Avx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbXL1Avx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXL1Avp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:51:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45992 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXL1Avp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:51:45 -0500
Message-ID: <477448DE.6050007@jp.fujitsu.com>
Date: Fri, 28 Dec 2007 09:52:46 +0900
From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] remove val in __do_proc_dointvec
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

What's the purpose of the val in __do_proc_dointvec ?
It seems no one ever uses this val.

Tomohiro Kusumi
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>

diff -Nur linux-2.6.23.org/kernel/sysctl.c linux-2.6.23/kernel/sysctl.c
--- linux-2.6.23.org/kernel/sysctl.c	2007-12-28 09:29:18.000000000 +0900
+++ linux-2.6.23/kernel/sysctl.c	2007-12-28 09:31:32.000000000 +0900
@@ -1716,7 +1716,7 @@
 		  void *data)
 {
 #define TMPBUFLEN 21
-	int *i, vleft, first=1, neg, val;
+	int *i, vleft, first=1, neg;
 	unsigned long lval;
 	size_t left, len;
 	
@@ -1769,8 +1769,6 @@
 			len = p-buf;
 			if ((len < left) && *p && !isspace(*p))
 				break;
-			if (neg)
-				val = -val;
 			s += len;
 			left -= len;


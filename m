Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbXGQITs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbXGQITs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbXGQITH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:19:07 -0400
Received: from out002.atlarge.net ([129.41.63.60]:6767 "EHLO
	out002.atlarge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360AbXGQITF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:19:05 -0400
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 04:19:05 EDT
Date: Tue, 17 Jul 2007 10:02:48 +0200
From: Domen Puncer <domen.puncer@telargo.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] introduce __init_exit function annotation
Message-ID: <20070717080248.GK4375@moe.telargo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 17 Jul 2007 08:02:23.0001 (UTC) FILETIME=[CE703890:01C7C848]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce __init_exit, which is useful ie. for drivers that call
cleanup functions when they fail in __init functions.


Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
---
 include/linux/init.h |    2 ++
 1 file changed, 2 insertions(+)

Index: work-powerpc.git/include/linux/init.h
===================================================================
--- work-powerpc.git.orig/include/linux/init.h
+++ work-powerpc.git/include/linux/init.h
@@ -60,8 +60,10 @@
 
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text")))
+#define __init_exit
 #else
 #define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text")))
+#define __init_exit	__init
 #endif
 
 /* For assembly routines */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZKNFp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZKNFp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 00:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZKNFp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 00:45:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:42187 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZKNFpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 00:45:55 -0500
Date: Fri, 13 Nov 2009 21:47:33 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Fix invalid type in ioctl definition
Message-ID: <20091113214733.7cd76be9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 39ad70666fd2e6fdb9a5b83845c2244b4a111219 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 13 Nov 2009 21:36:06 -0800
Subject: [PATCH] perf: Fix invalid type in ioctl definition

u64 is invalid in userspace headers, including ioctl definitions;
use __u64 instead

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9e70126..81c9689 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -219,7 +219,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_DISABLE		_IO ('$', 1)
 #define PERF_EVENT_IOC_REFRESH		_IO ('$', 2)
 #define PERF_EVENT_IOC_RESET		_IO ('$', 3)
-#define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, u64)
+#define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 
 enum perf_event_ioc_flags {
-- 
1.6.0.6


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

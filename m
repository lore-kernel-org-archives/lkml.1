Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbXK3Tcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbXK3Tcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXK3Tc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:32:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbXK3TcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:32:25 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH] apm_event{,info}_t are userspace types.
Date: Fri, 30 Nov 2007 15:02:43 -0500
Message-Id: <1196452963295-git-send-email-ajax@redhat.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These types define the size of data read from /dev/apm_bios.  They
should not be hidden behind #ifdef __KERNEL__.
---
 include/linux/apm_bios.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/apm_bios.h b/include/linux/apm_bios.h
index 9754baa..01a6244 100644
--- a/include/linux/apm_bios.h
+++ b/include/linux/apm_bios.h
@@ -18,6 +18,9 @@
 
 #include <linux/types.h>
 
+typedef unsigned short	apm_event_t;
+typedef unsigned short	apm_eventinfo_t;
+
 struct apm_bios_info {
 	__u16	version;
 	__u16	cseg;
@@ -32,9 +35,6 @@ struct apm_bios_info {
 
 #ifdef __KERNEL__
 
-typedef unsigned short	apm_event_t;
-typedef unsigned short	apm_eventinfo_t;
-
 #define APM_CS		(GDT_ENTRY_APMBIOS_BASE * 8)
 #define APM_CS_16	(APM_CS + 8)
 #define APM_DS		(APM_CS_16 + 8)
-- 
1.5.2.4


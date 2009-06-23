Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZFXACS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZFXACS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZFXACK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:02:10 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43697 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbZFXACJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:02:09 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, devel@ksplice.com,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 2/2] Add new __init_task_data macro to be used in arch init_task.c files.
Date: Tue, 23 Jun 2009 19:59:36 -0400
Message-Id: <1245801576-13374-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245801452-13222-1-git-send-email-tabbott@ksplice.com>
References: <1245801452-13222-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation for replacing most ".data.init_task" in the
kernel with macros, so that the section name can later be changed
without having to touch a lot of the kernel.

The long-term goal here is to be able to change the kernel's magic
section names to those that are compatible with -ffunction-sections
-fdata-sections.  This requires renaming all magic sections with names
of the form ".data.foo".

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 include/linux/init_task.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 5368fbd..7fc01b1 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -183,5 +183,8 @@ extern struct cred init_cred;
 	LIST_HEAD_INIT(cpu_timers[2]),					\
 }
 
+/* Attach to the init_task data structure for proper alignment */
+#define __init_task_data __attribute__((__section__(".data.init_task")))
+
 
 #endif
-- 
1.6.3.1


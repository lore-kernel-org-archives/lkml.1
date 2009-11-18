Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbZKRQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbZKRQoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757650AbZKRQoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:44:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45199 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbZKRQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:44:16 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 2/3] sysctl: Remove CTL_NONE and CTL_UNNUMBERED
Date: Wed, 18 Nov 2009 08:44:13 -0800
Message-Id: <1258562654-31370-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1d43fbx8i.fsf@fess.ebiederm.org>
References: <m1d43fbx8i.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that the sysctl structures no longer have a ctl_name field
there is no reason to retain the definitions for CTL_NONE and
CTL_UNNUMBERED, or to explain their historic usage.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 Documentation/sysctl/ctl_unnumbered.txt |   22 ----------------------
 include/linux/sysctl.h                  |    9 ---------
 2 files changed, 0 insertions(+), 31 deletions(-)
 delete mode 100644 Documentation/sysctl/ctl_unnumbered.txt

diff --git a/Documentation/sysctl/ctl_unnumbered.txt b/Documentation/sysctl/ctl_unnumbered.txt
deleted file mode 100644
index 23003a8..0000000
--- a/Documentation/sysctl/ctl_unnumbered.txt
+++ /dev/null
@@ -1,22 +0,0 @@
-
-Except for a few extremely rare exceptions user space applications do not use
-the binary sysctl interface.  Instead everyone uses /proc/sys/...  with
-readable ascii names.
-
-Recently the kernel has started supporting setting the binary sysctl value to
-CTL_UNNUMBERED so we no longer need to assign a binary sysctl path to allow
-sysctls to show up in /proc/sys.
-
-Assigning binary sysctl numbers is an endless source of conflicts in sysctl.h,
-breaking of the user space ABI (because of those conflicts), and maintenance
-problems.  A complete pass through all of the sysctl users revealed multiple
-instances where the sysctl binary interface was broken and had gone undetected
-for years.
-
-So please do not add new binary sysctl numbers.  They are unneeded and
-problematic.
-
-If you really need a new binary sysctl number please first merge your sysctl
-into the kernel and then as a separate patch allocate a binary sysctl number.
-
-(ebiederm@xmission.com, June 2007)
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index b4f6adc..c83a86a 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -15,9 +15,6 @@
  **  The kernel will then return -ENOTDIR to any application using
  **  the old binary interface.
  **
- **  For new interfaces unless you really need a binary number
- **  please use CTL_UNNUMBERED.
- **
  ****************************************************************
  ****************************************************************
  */
@@ -50,12 +47,6 @@ struct __sysctl_args {
 
 /* Top-level names: */
 
-/* For internal pattern-matching use only: */
-#ifdef __KERNEL__
-#define CTL_NONE	0
-#define CTL_UNNUMBERED	CTL_NONE	/* sysctl without a binary number */
-#endif
-
 enum
 {
 	CTL_KERN=1,		/* General kernel info and control */
-- 
1.6.5.2.143.g8cc62


Return-Path: <linux-kernel-owner+w=401wt.eu-S933081AbXBLHqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbXBLHqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964789AbXBLHqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:42 -0500
Received: from ns.suse.de ([195.135.220.2]:38405 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933092AbXBLHiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:15 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Giuliano Procida <giuliano.procida@googlemail.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [26/39] i386: fix 32-bit ioctls on x64_32
Message-Id: <20070212073814.1879213DA0@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Giuliano Procida <giuliano.procida@googlemail.com>
[MTRR] fix 32-bit ioctls on x64_32

Signed-off-by: Giuliano Procida <giuliano.procida@googlemail.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---

Fixed incomplete support for 32-bit compatibility ioctls in
2.6.19.1. They were unhandled in one of three case-statements.
Testing using X server before and after change.

---
 arch/i386/kernel/cpu/mtrr/if.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: linux/arch/i386/kernel/cpu/mtrr/if.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/if.c
+++ linux/arch/i386/kernel/cpu/mtrr/if.c
@@ -211,6 +211,9 @@ mtrr_ioctl(struct file *file, unsigned i
 	default:
 		return -ENOTTY;
 	case MTRRIOC_ADD_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_ADD_ENTRY:
+#endif
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		err =
@@ -218,21 +221,33 @@ mtrr_ioctl(struct file *file, unsigned i
 				  file, 0);
 		break;
 	case MTRRIOC_SET_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_SET_ENTRY:
+#endif
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		err = mtrr_add(sentry.base, sentry.size, sentry.type, 0);
 		break;
 	case MTRRIOC_DEL_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_DEL_ENTRY:
+#endif
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		err = mtrr_file_del(sentry.base, sentry.size, file, 0);
 		break;
 	case MTRRIOC_KILL_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_KILL_ENTRY:
+#endif
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		err = mtrr_del(-1, sentry.base, sentry.size);
 		break;
 	case MTRRIOC_GET_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_GET_ENTRY:
+#endif
 		if (gentry.regnum >= num_var_ranges)
 			return -EINVAL;
 		mtrr_if->get(gentry.regnum, &gentry.base, &size, &type);
@@ -249,6 +264,9 @@ mtrr_ioctl(struct file *file, unsigned i
 
 		break;
 	case MTRRIOC_ADD_PAGE_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_ADD_PAGE_ENTRY:
+#endif
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		err =
@@ -256,21 +274,33 @@ mtrr_ioctl(struct file *file, unsigned i
 				  file, 1);
 		break;
 	case MTRRIOC_SET_PAGE_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_SET_PAGE_ENTRY:
+#endif
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		err = mtrr_add_page(sentry.base, sentry.size, sentry.type, 0);
 		break;
 	case MTRRIOC_DEL_PAGE_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_DEL_PAGE_ENTRY:
+#endif
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		err = mtrr_file_del(sentry.base, sentry.size, file, 1);
 		break;
 	case MTRRIOC_KILL_PAGE_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_KILL_PAGE_ENTRY:
+#endif
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		err = mtrr_del_page(-1, sentry.base, sentry.size);
 		break;
 	case MTRRIOC_GET_PAGE_ENTRY:
+#ifdef CONFIG_COMPAT
+	case MTRRIOC32_GET_PAGE_ENTRY:
+#endif
 		if (gentry.regnum >= num_var_ranges)
 			return -EINVAL;
 		mtrr_if->get(gentry.regnum, &gentry.base, &size, &type);

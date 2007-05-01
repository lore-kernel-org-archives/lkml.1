Return-Path: <linux-kernel-owner+w=401wt.eu-S1946497AbXEAEB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946497AbXEAEB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946593AbXEAEBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:48946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946213AbXEAD6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:03 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/30] x86_64: Define IGNORE_IOCTL() macro for compat_ioctls
Message-Id: <20070501035802.4A82615146@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Define a new IGNORE_IOCTL() to let a compat ioctl not be warned about even when
it is not implemented.

This is the same as COMPATIBLE_IOCTL internally, but better self documentng.

Valid reasons to use this:
- It is implemented with ->compat_ioctl on some device, but programs
  call it on others too.
- The ioctl is not implemented in the native kernel, but programs
  call it commonly anyways.
Most other reasons are not valid. 

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/compat_ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/fs/compat_ioctl.c
===================================================================
--- linux.orig/fs/compat_ioctl.c
+++ linux/fs/compat_ioctl.c
@@ -2396,6 +2396,14 @@ lp_timeout_trans(unsigned int fd, unsign
 #define ULONG_IOCTL(cmd) \
 	{ (cmd), (ioctl_trans_handler_t)sys_ioctl },
 
+/* ioctl should not be warned about even if it's not implemented.
+   Valid reasons to use this:
+   - It is implemented with ->compat_ioctl on some device, but programs
+   call it on others too.
+   - The ioctl is not implemented in the native kernel, but programs
+   call it commonly anyways.
+   Most other reasons are not valid. */
+#define IGNORE_IOCTL(cmd) COMPATIBLE_IOCTL(cmd)
 
 struct ioctl_trans ioctl_start[] = {
 #include <linux/compat_ioctl.h>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbYHNGoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbYHNGoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHNGie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:34 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38135 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYHNGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:37:58 -0400
Date: Thu, 14 Aug 2008 00:14:38 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EcMB006257@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 20/29] mdb: export the console redirection handle
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export the console redirection handle to allow 
the debugger screen to becoime visible again during exceptions.  Export
of this variable allows the debugger to switch to the current screen 
in order to enable the debugging console on systems with a redirected
system console.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/drivers/char/vt.c	2008-08-13 14:22:15.000000000 -0600
+++ b/drivers/char/vt.c	2008-08-13 11:56:03.000000000 -0600
@@ -188,6 +188,10 @@
 int want_console = -1;
 int kmsg_redirect;
 
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(kmsg_redirect);
+#endif
+
 /*
  * For each existing display, we have a pointer to console currently visible
  * on that display, allowing consoles other than fg_console to be refreshed

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760655AbYHDGr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbYHDGr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbYHDGrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:47:52 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48515 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbYHDGrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:47:51 -0400
Message-ID: <51614.166.70.238.45.1217831246.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:27:26 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 1/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/arch/x86/kernel/reboot.c	2008-08-03 16:09:54.000000000 -0600
+++ b/arch/x86/kernel/reboot.c	2008-08-03 16:15:00.000000000 -0600
@@ -432,7 +432,16 @@
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
+#ifdef CONFIG_MDB
+        // do not stop the other processors if the debugger is active
+        {
+           extern atomic_t inmdb;
+           if (!atomic_read(&inmdb))
+	      smp_send_stop();
+        }
+#else
 	smp_send_stop();
+#endif // CONFIG_MDB
 #endif

 	lapic_shutdown();


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey




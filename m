Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbYGOUq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbYGOUq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763452AbYGOUoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:44:54 -0400
Received: from gw.goop.org ([64.81.55.164]:47268 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760951AbYGOUow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:44:52 -0400
Message-ID: <487D0BFE.1010401@goop.org>
Date: Tue, 15 Jul 2008 13:43:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] xen: fix up config dependencies on PM
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen save/restore needs bits of code enabled by PM_SLEEP, and PM_SLEEP
depends on PM.  So make XEN_SAVE_RESTORE depend on PM and PM_SLEEP
depend on XEN_SAVE_RESTORE.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/xen/Kconfig |    5 +++++
 kernel/power/Kconfig |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -23,3 +23,8 @@
          according to the maximum possible memory size of a Xen
          domain.  This array uses 1 page per gigabyte, so there's no
          need to be too stingy here.
+
+config XEN_SAVE_RESTORE
+       bool
+       depends on PM
+       default y
\ No newline at end of file
===================================================================
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -82,7 +82,7 @@
 
 config PM_SLEEP
 	bool
-	depends on SUSPEND || HIBERNATION
+	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
 	default y
 
 config SUSPEND




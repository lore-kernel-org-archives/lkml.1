Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYGAReL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYGAReL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 13:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYGAReA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 13:34:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10322 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYGARd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 13:33:59 -0400
Date: Tue, 1 Jul 2008 10:33:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, andi@firstfloor.org
Subject: [PATCH -next] bug.h: add empty warn_on_slowpath() for CONFIG_BUG=n
Message-Id: <20080701103339.b5acc1f3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add an empty function for warn_on_slowpath() when CONFIG_BUG=n so that
this build error does not happen:

linux-next-20080701/drivers/acpi/utilities/utmisc.c: In function 'acpi_ut_error':
linux-next-20080701/drivers/acpi/utilities/utmisc.c:1028: error: implicit declaration of function 'warn_on_slowpath'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-generic/bug.h |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20080701.orig/include/asm-generic/bug.h
+++ linux-next-20080701/include/asm-generic/bug.h
@@ -81,4 +81,9 @@ extern void warn_on_slowpath(const char 
 # define WARN_ON_SMP(x)			do { } while (0)
 #endif
 
+#ifndef __ASSEMBLY__
+static inline void warn_on_slowpath(const char *file, const int line)
+{ }
+#endif
+
 #endif


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

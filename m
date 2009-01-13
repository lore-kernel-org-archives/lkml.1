Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZAMV5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZAMV5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZAMV5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:57:46 -0500
Received: from c60.cesmail.net ([216.154.195.49]:60961 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbZAMV5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:57:45 -0500
Subject: checkpatch confused by pre-existing #endif
From: Pavel Roskin <proski@gnu.org>
To: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 13 Jan 2009 16:57:43 -0500
Message-Id: <1231883863.21706.17.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch confuses checkpatch.pl from Linux 2.6.29-rc1:

====================
--- foo.h.old	2009-01-13 16:48:22.000000000 -0500
+++ foo.h	2009-01-13 16:48:18.000000000 -0500
@@ -3,4 +3,8 @@
 
 
 
+#ifdef FOOBAR
+#define foo
+#endif
+
 #endif /* FOO_H */
====================

$ scripts/checkpatch.pl foo.diff 
Can't use an undefined value as an ARRAY reference at
scripts/checkpatch.pl line 453.

Apparently, the last #endif causes some data to be popped from the stack
for preprocessor directives.  However, the corresponding #ifdef is
outside the patch, so this fails.

-- 
Regards,
Pavel Roskin

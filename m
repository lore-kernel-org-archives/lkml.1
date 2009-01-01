Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbZAARiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbZAARiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 12:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZAARiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 12:38:07 -0500
Received: from host49.cc-host.de ([195.140.232.81]:56536 "EHLO
	host49.cc-host.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZAARiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 12:38:06 -0500
X-Greylist: delayed 4805 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jan 2009 12:38:05 EST
From: Anders Larsen <al@alarsen.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Include <linux/types.h> for definitions of __[us]{8,16,32,64} types
Date: Thu,  1 Jan 2009 17:17:35 +0100
Message-Id: <1230826655-18495-1-git-send-email-al@alarsen.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: anders@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-12-30 11:32:33, Sam Ravnborg wrote:
> We have added a few additional validation checks of the userspace headers:
...
> 3) We should include <linux/types.h> and not <asm/types.h>
> 4) If we use a __[us]{8,16,32,64} type then we must include <linux/types.h>

Satisfy these requirements for the linux/qnx*.h headers.

Signed-off-by: Anders Larsen <al@alarsen.net>
---
 include/linux/qnx4_fs.h  |    4 +---
 include/linux/qnxtypes.h |    5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/qnx4_fs.h b/include/linux/qnx4_fs.h
index 34a196e..787d19e 100644
--- a/include/linux/qnx4_fs.h
+++ b/include/linux/qnx4_fs.h
@@ -2,14 +2,12 @@
  *  Name                         : qnx4_fs.h
  *  Author                       : Richard Frowijn
  *  Function                     : qnx4 global filesystem definitions
- *  Version                      : 1.0.2
- *  Last modified                : 2000-01-31
- *
  *  History                      : 23-03-1998 created
  */
 #ifndef _LINUX_QNX4_FS_H
 #define _LINUX_QNX4_FS_H
 
+#include <linux/types.h>
 #include <linux/qnxtypes.h>
 #include <linux/magic.h>
 
diff --git a/include/linux/qnxtypes.h b/include/linux/qnxtypes.h
index a3eb113..bebbe5c 100644
--- a/include/linux/qnxtypes.h
+++ b/include/linux/qnxtypes.h
@@ -2,9 +2,6 @@
  *  Name                         : qnxtypes.h
  *  Author                       : Richard Frowijn
  *  Function                     : standard qnx types
- *  Version                      : 1.0.2
- *  Last modified                : 2000-01-06
- *
  *  History                      : 22-03-1998 created
  *
  */
@@ -12,6 +9,8 @@
 #ifndef _QNX4TYPES_H
 #define _QNX4TYPES_H
 
+#include <linux/types.h>
+
 typedef __le16 qnx4_nxtnt_t;
 typedef __u8  qnx4_ftype_t;
 
-- 
1.5.4.3


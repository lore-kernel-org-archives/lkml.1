Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYADFjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYADFjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYADFjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:39:32 -0500
Received: from gw.goop.org ([64.81.55.164]:48755 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbYADFjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:39:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 8] x86: add _AT() macro to conditionally cast
X-Mercurial-Node: f7e7db3facd9406545103164f9be8f9ba1a2b549
Message-Id: <f7e7db3facd940654510.1199391060@localhost>
In-Reply-To: <patchbomb.1199391057@localhost>
Date: Thu, 03 Jan 2008 12:11:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Jeremy Fitzhardinge <jeremy@xensource.com>
# Date 1199317452 28800
# Node ID f7e7db3facd9406545103164f9be8f9ba1a2b549
# Parent  4d9a413a0f4c1d98dbea704f0366457b5117045d
x86: add _AT() macro to conditionally cast

Define _AT(type, value) to conditionally cast a value when compiling C
code, but not when used in assembler.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/linux/const.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/const.h b/include/linux/const.h
--- a/include/linux/const.h
+++ b/include/linux/const.h
@@ -7,13 +7,18 @@
  * C code.  Therefore we cannot annotate them always with
  * 'UL' and other type specifiers unilaterally.  We
  * use the following macros to deal with this.
+ *
+ * Similarly, _AT() will cast an expression with a type in C, but
+ * leave it unchanged in asm.
  */
 
 #ifdef __ASSEMBLY__
 #define _AC(X,Y)	X
+#define _AT(T,X)	X
 #else
 #define __AC(X,Y)	(X##Y)
 #define _AC(X,Y)	__AC(X,Y)
+#define _AT(T,X)	((T)(X))
 #endif
 
 #endif /* !(_LINUX_CONST_H) */



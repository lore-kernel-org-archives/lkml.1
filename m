Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZFDMmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZFDMmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbZFDMmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:42:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:38721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbZFDMmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:42:04 -0400
Subject: [PATCH 4/6] headers_check fix: mips, ioctl.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips <linux-mips@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>
In-Reply-To: <1244118714.5172.33.camel@ht.satnam>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244118476.5172.29.camel@ht.satnam>  <1244118599.5172.31.camel@ht.satnam>
	 <1244118714.5172.33.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 18:05:49 +0530
Message-Id: <1244118949.5172.37.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ioctl.h compatible with asm-generic/ioctl.h and userspace

fix the following 'make headers_check' warning:

  usr/include/asm-mips/ioctl.h:64: extern's make no sense in userspace

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/mips/include/asm/ioctl.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/ioctl.h
b/arch/mips/include/asm/ioctl.h
index 85067e2..9161634 100644
--- a/arch/mips/include/asm/ioctl.h
+++ b/arch/mips/include/asm/ioctl.h
@@ -60,12 +60,16 @@
 	 ((nr)   << _IOC_NRSHIFT) | \
 	 ((size) << _IOC_SIZESHIFT))
 
+#ifdef __KERNEL__
 /* provoke compile error for invalid uses of size argument */
 extern unsigned int __invalid_size_argument_for_IOC;
 #define _IOC_TYPECHECK(t) \
 	((sizeof(t) == sizeof(t[1]) && \
 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
 	  sizeof(t) : __invalid_size_argument_for_IOC)
+#else
+#define _IOC_TYPECHECK(t)	(sizeof(t))
+#endif
 
 /* used to create numbers */
 #define _IO(type, nr)		_IOC(_IOC_NONE, (type), (nr), 0)
-- 
1.6.0.6




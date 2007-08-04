Return-Path: <linux-kernel-owner+w=401wt.eu-S932571AbXHDUa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbXHDUa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 16:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761536AbXHDUaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 16:30:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:61152 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759925AbXHDUaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 16:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=I9F7ywB4xY0E1JjLQJXxIV/ROzDkdgie0R7t4wMtbJXEP00vqV2vIp+MAYt/Q7ok9pAx1rKP/CFacm5sfrx9csNwd4aRtrxT3G5Fd6lxN8tBYUkUeuMrx9lfQT62KuQHjJ6/giDff0bQHkPOVHPbw9W+eaoWYXQq/JoCXSX2AWU=
Date: Sun, 5 Aug 2007 00:30:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: [PATCH] sparc: fix fallout from O_CLOEXEC changes
Message-ID: <20070804203005.GA7668@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just "#define O_CLOEXEC" is OK, because asm-generic/fcntl.h will check if it's
already defined.

Loads of "struct flock inside parameter list" warnings and
"O_WRONLY undefined" errors.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/asm-sparc/fcntl.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-sparc/fcntl.h
+++ b/include/asm-sparc/fcntl.h
@@ -32,5 +32,6 @@
 #define __ARCH_FLOCK_PAD	short __unused;
 #define __ARCH_FLOCK64_PAD	short __unused;
 
+#include <asm-generic/fcntl.h>
 
 #endif


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXJXIPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXJXIPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJXIPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:15:01 -0400
Received: from ro-out-1112.google.com ([72.14.202.179]:48292 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXJXIPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=j5LTHxu4ld6p6mtYy05HPeQIuKsD7+o0r7+wQ+BZHYYGlxtOs4B4S3Y/+4wIjli3StNomwUZoUlFBgROffpCq6njq6Rxasol6DMmQUkioY+FN6dEkxea1coeiv3MrT2wZ3qSddPABSFM1VVFmLmD0llqPUx86WR5exIV6UqC3Q8=
Date: Wed, 24 Oct 2007 16:10:47 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, jdike@karaya.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Git Patch] arch/um/drivers/ubd_kern.c: fix a building error
Message-ID: <20071024081047.GC2464@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix this uml building error:
arch/um/drivers/ubd_kern.c: In function 'do_ubd_request':
arch/um/drivers/ubd_kern.c:1118: error: implicit declaration of function 'sg_page'
arch/um/drivers/ubd_kern.c:1118: warning: passing argument 6 of 'prepare_request' makes pointer from integer without a cast
make[1]: *** [arch/um/drivers/ubd_kern.o] Error 1
make: *** [arch/um/drivers] Error 2

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 arch/um/drivers/ubd_kern.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 3a8cd3d..440ed25 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -35,6 +35,7 @@
 #include "linux/genhd.h"
 #include "linux/spinlock.h"
 #include "linux/platform_device.h"
+#include "linux/scatterlist.h"
 #include "asm/segment.h"
 #include "asm/uaccess.h"
 #include "asm/irq.h"

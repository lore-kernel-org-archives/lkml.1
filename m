Return-Path: <linux-kernel-owner+w=401wt.eu-S1764619AbXHJJ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764619AbXHJJ4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 05:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934624AbXHJJ4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 05:56:21 -0400
Received: from hall.aurel32.net ([88.191.38.19]:45371 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765983AbXHJJ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 05:56:19 -0400
X-Greylist: delayed 1961 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 05:56:19 EDT
Date: Fri, 10 Aug 2007 11:23:34 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-ID: <20070810092334.GA15285@hall.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
X-Mailer: Mutt 1.5.13 (2006-08-11)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/
> 
> - Various problems from 2.6.23-rc2-mm1 were fixed

I have just tried it, and it fails to build for MIPS with the following
error:

  CC      arch/mips/kernel/asm-offsets.s
In file included from include/linux/sched.h:58,
                 from arch/mips/kernel/asm-offsets.c:13:
include/linux/mm_types.h:115: error: expected specifier-qualifier-list before 'pgprot_t'
include/linux/mm_types.h:169: warning: 'struct file' declared inside parameter list
include/linux/mm_types.h:169: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/mm_types.h:175: error: expected specifier-qualifier-list before 'pgd_t'


The trivial patch below fixes this problem.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -10,6 +10,7 @@
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/completion.h>
+#include <asm/page.h>
 #include <asm/mmu.h>
 
 struct address_space;

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net

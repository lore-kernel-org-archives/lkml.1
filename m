Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbXGYRDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbXGYRDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbXGYRDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:03:13 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36076 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbXGYRDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:03:13 -0400
Date: Wed, 25 Jul 2007 19:04:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.23-rc1-mm1 -- mostly fails to build
Message-ID: <20070725170427.GA26343@uranus.ravnborg.org>
References: <20070725040304.111550f4.akpm@linux-foundation.org> <46A77C28.1050807@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A77C28.1050807@shadowen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 05:36:56PM +0100, Andy Whitcroft wrote:
> ia64 (elm3b10):
> 
>   LD      vmlinux.o
> ld: dynreloc miscount for kernel/built-in.o, section .opd
> ld: can not edit opd Bad value
> make: *** [vmlinux.o] Error 1

On powerpc we had something similar. It was a binutils bug
(see: http://article.gmane.org/gmane.comp.gnu.binutils/33650)

I tracked it down to be fixed by the following:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c456c3a..2ea222f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1246,7 +1246,7 @@ void drop_slab(void);
 extern int randomize_va_space;
 #endif
 
-__attribute__((weak)) const char *arch_vma_name(struct vm_area_struct *vma);
+//__attribute__((weak)) const char *arch_vma_name(struct vm_area_struct *vma);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */



This is obviously just a quick hack and I used brutal force
to find out how to fix it - but does not yet understand why this
weak prototype cause the bug.

	Sam

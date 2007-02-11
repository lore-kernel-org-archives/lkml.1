Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbXBKAQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbXBKAQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 19:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXBKAQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 19:16:22 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:52204 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXBKAQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 19:16:21 -0500
Date: Sun, 11 Feb 2007 01:15:09 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't configured
Message-ID: <20070211001509.GA8055@osiris.ibm.com>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com> <45CE0434.30105@gmail.com> <20070210194630.GA13416@osiris.ibm.com> <45CE43B5.2020806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CE43B5.2020806@gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 05:14:13PM -0500, Tejun Heo wrote:
> Heiko Carstens wrote:
> >On Sat, Feb 10, 2007 at 12:43:16PM -0500, Tejun Heo wrote:
> \>> Heiko, how about this?  Does it fix s390?
> >Unfortunately not. Now I get
> >  CC      lib/iomap.o
> >lib/iomap.c: In function 'devm_ioport_map_release':
> >lib/iomap.c:270: warning: implicit declaration of function 'ioport_unmap'
> >lib/iomap.c: In function 'devm_ioport_map':
> >lib/iomap.c:297: warning: implicit declaration of function 'ioport_map'
> >lib/iomap.c:297: warning: assignment makes pointer from integer without a cast
> 
> I think an arch needs to support ioport_map/unmap and noncoherent dma
> (just alias to coherent interface on x86/amd64) interface whether PCI is
> implemented or not.  No?

I sent a patch earlier which "fixes" at least the dma stuff by adding some
more defines to asm-generic/dma-mapping-broken.h
The patch below (on top of your latest one) makes sure s390 builds at
least again until all this got sorted out.
---

Hack to make s390 build again.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/asm-s390/io.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/include/asm-s390/io.h
===================================================================
--- linux-2.6.orig/include/asm-s390/io.h
+++ linux-2.6/include/asm-s390/io.h
@@ -61,6 +61,20 @@ static inline void * ioremap_nocache (un
 extern void iounmap(void *addr);
 
 /*
+ * FIXME: remove ioport stuff asap again.
+ */
+static inline void __iomem *ioport_map(unsigned long port, unsigned int size)
+{
+	BUG();
+	return NULL;
+}
+
+static inline void ioport_unmap(void __iomem *addr)
+{
+	BUG();
+}
+
+/*
  * IO bus memory addresses are also 1:1 with the physical address
  */
 #define virt_to_bus virt_to_phys

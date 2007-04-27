Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXD0Puh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXD0Puh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbXD0Pug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:50:36 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:36865 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbXD0PuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:50:09 -0400
Date: Fri, 27 Apr 2007 16:50:06 +0100
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu fix
Message-ID: <20070427155005.GA20839@skynet.ie>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <200704261724.46027.ak@suse.de> <20070426154518.GG16909@skynet.ie> <200704270239.13895.ak@suse.de> <20070427085958.GA3645@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070427085958.GA3645@skynet.ie>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (27/04/07 09:59), Mel Gorman didst pronounce:
> On (27/04/07 02:39), Andi Kleen didst pronounce:
> > 
> > 
> > > That's vdso.lds.S, not vdso.lds. The VDSO_TEXT_OFFSET is still 0x400.
> > > This is what I should have posted the last time
> > > 
> > > --- build/arch/x86_64/vdso/voffset.h.orig	2007-04-26 08:43:31.523739878 -0700
> > > +++ build/arch/x86_64/vdso/voffset.h	2007-04-26 08:43:38.839579356 -0700
> > > @@ -1 +1 @@
> > > -#define VDSO_TEXT_OFFSET 0x500
> > > +#define VDSO_TEXT_OFFSET 0x400
> > 
> > It's definitely 0x400 here. Is your patch reversed and you want 0x500? 
> > 
> 
> Sorry, that patch is reversed. It's 0x500 it needs to be to work here.
> 

What I should have done in the first place..... Sorry for the noise.

=======

The machine elm3b6 on test.kernel.org had problems with the patch
x86_64-mm-vdso.patch. The fix is two-fold. The first patch fixes a compile
problem by adding -m64.  This patch updates VDSO_TEXT_OFFSET so that the
linker does not complain.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 voffset.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc7-mm2-quilt/arch/x86_64/vdso/voffset.h
===================================================================
--- linux-2.6.21-rc7-mm2-quilt.orig/arch/x86_64/vdso/voffset.h	2007-04-27 10:35:09.000000000 +0100
+++ linux-2.6.21-rc7-mm2-quilt/arch/x86_64/vdso/voffset.h	2007-04-27 10:35:12.000000000 +0100
@@ -1 +1 @@
-#define VDSO_TEXT_OFFSET 0x400
+#define VDSO_TEXT_OFFSET 0x500
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

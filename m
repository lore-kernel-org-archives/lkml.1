Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXDZPpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXDZPpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXDZPpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:45:22 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56081 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbXDZPpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:45:21 -0400
Date: Thu, 26 Apr 2007 16:45:18 +0100
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 VDSO compile error II
Message-ID: <20070426154518.GG16909@skynet.ie>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426143902.GD16909@skynet.ie> <20070426152039.GF16909@skynet.ie> <200704261724.46027.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200704261724.46027.ak@suse.de>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 17:24), Andi Kleen didst pronounce:
> 
> > --- build/arch/x86_64/vdso/vdso.lds-orig	2007-04-26 08:18:19.000000000 -0700
> > +++ build/arch/x86_64/vdso/vdso.lds	2007-04-26 08:18:23.000000000 -0700
> > @@ -33,7 +33,7 @@
> >       For the layouts to match, we need to skip more than enough
> >       space for the dynamic symbol table et al.  If this amount
> >       is insufficient, ld -shared will barf.  Just increase it here.  */
> > -  . = 0xffffffffff700000 + 0x500;
> > +  . = 0xffffffffff700000 + 0x400;
> 
> Hmm, you must have an old version of the patch. in my copy it looks like
> 
>   . = VDSO_PRELINK + VDSO_TEXT_OFFSET;
> 

That's vdso.lds.S, not vdso.lds. The VDSO_TEXT_OFFSET is still 0x400.
This is what I should have posted the last time

--- build/arch/x86_64/vdso/voffset.h.orig	2007-04-26 08:43:31.523739878 -0700
+++ build/arch/x86_64/vdso/voffset.h	2007-04-26 08:43:38.839579356 -0700
@@ -1 +1 @@
-#define VDSO_TEXT_OFFSET 0x500
+#define VDSO_TEXT_OFFSET 0x400

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbXEQKwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbXEQKwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXEQKwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:52:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:42635 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbXEQKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:52:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mebmgFyclP3XfHvw+n16RzVV5Le+80jKzPPfEzfGZ2D1K3cXhC2W9SJhbCEcKfi9LtOrg30mfo3gilrK0pdDMXyUH1hLPuWylLv0sorw6yixzdNEyKp7tAz5sMrLtIqk6/NuJPglOec526pYDyzPt1jVTz8FDTR1/gar7CMwjWE=
Subject: Re: [Linux-fbdev-devel] [PATCH 10/10] [HEADS UP] fbdev: Move
	arch-specific bits to their respective subdirectories
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@osdl.org>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       uClinux list <uclinux-dev@uclinux.org>
In-Reply-To: <Pine.LNX.4.64.0705171140230.20754@anakin>
References: <464B78BC.4080900@gmail.com>
	 <Pine.LNX.4.64.0705171140230.20754@anakin>
Content-Type: text/plain
Date: Thu, 17 May 2007 18:52:32 +0800
Message-Id: <1179399152.4586.13.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 11:43 +0200, Geert Uytterhoeven wrote:
> On Thu, 16 May 2007, Antonino A. Daplas wrote:
> > diff --git a/include/asm-m68k/fb.h b/include/asm-m68k/fb.h
> > new file mode 100644
> > index 0000000..7d4a28f
> > --- /dev/null
> > +++ b/include/asm-m68k/fb.h
> > @@ -0,0 +1,28 @@
> > +#ifndef _ASM_FB_H_
> > +#define _ASM_FB_H_
> > +
> > +#include <linux/fs.h>
> > +#include <asm/page.h>
> > +#include <asm/setup.h>
> > +
> > +#ifdef CONFIG_SUN3
> > +static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	pgprot_val(vma->vm_page_prot) |= SUN3_PAGE_NOCACHE;
> > +}
> > +#elif defined(CONFIG_MMU)
>    ^^^^^^^^^^^^^^^^^^^^^^^^^
> This can be a plain `#else', as m68knommu hasn't been merged with m68k
> (yet :-)
> 
> > +static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
> > +	if (CPU_IS_020_OR_030)
> > +		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE030;
> > +	if (CPU_IS_040_OR_060) {
> > +		pgprot_val(vma->vm_page_prot) &= _CACHEMASK040;
> > +		/* Use no-cache mode, serialized */
> > +		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE_S;
> > +	}
> > +}
> > +#else
>    ^^^^^
> So this branch can go away
> 
> > +#warning What do we have to do here??
> > +#define fb_pgprotect(...) do {} while (0)
> > +#endif /* CONFIG_SUN3 */
> > +
> > +#endif /* _ASM_FB_H_ */
> > diff --git a/include/asm-m68knommu/fb.h b/include/asm-m68knommu/fb.h
> > new file mode 100644
> > index 0000000..dc9d1be
> > --- /dev/null
> > +++ b/include/asm-m68knommu/fb.h
> > @@ -0,0 +1,7 @@
> > +#ifndef _ASM_FB_H_
> > +#define _ASM_FB_H_
> > +
> > +#warning What do we have to do here??
> > +#define fb_pgprotect(...) do {} while (0)
> > +
> > +#endif /* _ASM_FB_H_ */
> 
> If the m68knommu case in fb_mmap() was empty before, it should be empty here
> too, so I guess the warning can go away.

Thanks. It's confusing when there's multiple directories for one
architecture.

Tony



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZFIRaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZFIRaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZFIRaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:30:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZFIRaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:30:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 08/27] score: create head files fb.h fcntl.h fixmap.h ftrace.h futex.h
Date: Tue, 9 Jun 2009 19:30:02 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF7A6C7D8F.B4BC990D-ON482575D0.00236CE1-482575D0.0023DDA8@sunplusct.com>
In-Reply-To: <OF7A6C7D8F.B4BC990D-ON482575D0.00236CE1-482575D0.0023DDA8@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091930.02985.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19kpH3MgUq7bLzWHDt+zs/2kAqSlHybw5tYO8V
 oNIU5MfOOtSZQoUznUiPS9t3fsKfu5bZAhVxzbpe7A2YSQWits
 DiZDF4FYYxzE7X2uhMDZOTNNFuu0clg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:

> diff --git a/arch/score/include/asm/fb.h b/arch/score/include/asm/fb.h
> new file mode 100644
> index 0000000..6bb525e
> --- /dev/null
> +++ b/arch/score/include/asm/fb.h
> @@ -0,0 +1,15 @@
> +#ifndef _ASM_SCORE_FB_H
> +#define _ASM_SCORE_FB_H
> +
> +#include <linux/device.h>
> +
> +static inline void fb_pgprotect(struct file *file, struct vm_area_struct 
> *vma,
> +                               unsigned long off)
> +{}
> +
> +static inline int fb_is_primary_device(struct fb_info *info)
> +{
> +       return 0;
> +}
> +
> +#endif /* _ASM_SCORE_FB_H */

This is the same as the asm-generic version (better actually, because it
doesn't use macros). Just use the existing code here, and maybe add
a patch to fix that one to use an inline function as well ;-)

> index 0000000..ee16766
> --- /dev/null
> +++ b/arch/score/include/asm/fixmap.h
> @@ -0,0 +1,82 @@
> +#ifndef _ASM_SCORE_FIXMAP_H
> +#define _ASM_SCORE_FIXMAP_H

Hmm, I missed that file in my asm-generic series. Your code is 90% shared
with mips, parisc, sh, sparc and um, so it seems like I should put it
on my TODO list for generalization.

	Arnd <><

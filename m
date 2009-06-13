Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZFMGib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZFMGib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZFMGiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:38:22 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:55699 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZFMGiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:38:21 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2009 02:38:20 EDT
In-Reply-To: <200906091907.17042.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 05/27] score: create head files cache.h cacheflush.h checksum.h
 cputime.h current.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF3577968C.E669F4B8-ON482575D4.0023707C-482575D4.0024726F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sat, 13 Jun 2009 14:33:38 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/13 ?? 02:33:38,
	Serialize complete at 2009/06/13 ?? 02:33:38
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5D6dJ54011700

Hi Arnd,

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-06-10 01:07:16:

> On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> > diff --git a/arch/score/include/asm/cacheflush.h 
> > b/arch/score/include/asm/cacheflush.h
> > +extern void (*flush_cache_all)(void);
> > +extern void (*flush_cache_mm)(struct mm_struct *mm);
> > +extern void (*flush_cache_range)(struct vm_area_struct *vma,
> > +                               unsigned long start, unsigned long 
end);
> > +extern void (*flush_cache_page)(struct vm_area_struct *vma,
> > +                               unsigned long page, unsigned long 
pfn);
> > +extern void (*flush_cache_sigtramp)(unsigned long addr);
> > +extern void (*flush_icache_all)(void);
> > +extern void (*flush_icache_range)(unsigned long start, unsigned long 
> > end);
> > +extern void (*flush_data_cache_page)(unsigned long addr);
> 
> This is a somewhat unusual way to express these functions. It seems
> that you only have one implementation for each of them, so I wonder
> why you keep them as function pointers. Do you plan to add more CPUs
> in the future that do these differently?
> 

S+core series have score7 core and score3 core, they use different ISA,
this patch only include score7 code. We will provide score3 code latter.

> > --- /dev/null
> > +++ b/arch/score/include/asm/current.h
> > @@ -0,0 +1,15 @@
> > +#ifndef _ASM_SCORE_CURRENT_H
> > +#define _ASM_SCORE_CURRENT_H
> > +
> > +#include <linux/thread_info.h>
> > +
> > +struct task_struct;
> > +
> > +static inline struct task_struct *get_current(void)
> > +{
> > +       return current_thread_info()->task;
> > +}
> > +
> > +#define current        get_current()
> > +
> > +#endif /* _ASM_SCORE_CURRENT_H */
> 
> This is basically the asm-generic version, so you could just use that
> instead.
> 

Use asm-generic/current.h instead.

Best Regards
Liqin
--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

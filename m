Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbZHaITR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbZHaITR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZHaITQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:19:16 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:54911
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbZHaITP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:19:15 -0400
X-Greylist: delayed 1381 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Aug 2009 04:19:15 EDT
In-Reply-To: <200908271600.37569.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [GIT PULL, v4] S+core architecture (arch/score) support
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF0579E5F2.3B710FBD-ON48257623.002611FB-48257623.002B92AD@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 31 Aug 2009 15:48:33 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/08/31 ?? 03:48:34,
	Serialize complete at 2009/08/31 ?? 03:48:34
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n7V8JY16012551

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-08-27 22:00:37:

> 
> I understand your problem here, and I think it would be good
> to have second opinion from someone else here. The four
> #defines you mention are roughly in reverse order of importance.
> 
> I think you really need to remove __ARCH_WANT_SYSCALL_DEPRECATED
> and get that working. Please tell us if some system call is
> giving you problems and we can find a solution together.
> 
> Removing __ARCH_WANT_SYSCALL_OFF_T should not be too hard, because
> glibc uses the loff_t versions by default anyway. I have not tried
> it though, so it may be more complicated than I thought.
> 

in __ARCH_WANT_SYSCALL_DEPRECATED,
asm-generic/unistd.h haven't define __NR_ipc and __NR__llseek
which used in glibc.

Now we have maintained 3 sets of syscall API code use for glibc.
1: Old syscall interface, which linux/score system work well.
2: New syscall interface, define all 4 macro __ARCH_WANT_SYSCALL_XXX,
        linux/score system work now, but we still debug the glibc code.
3: New syscall interface, without define __ARCH_WANT_SYSCALL_DEPRECATED
        and __ARCH_WANT_SYSCALL_OFF_T, linux/score system couldn't work.
        because glibc have many place need to fix.

Liqin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

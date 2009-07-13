Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZGMGDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZGMGDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZGMGDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:03:09 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58668 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZGMGDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:03:08 -0400
In-Reply-To: <200907101449.45286.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Subject: Re: [PATCH V2] score: add regset support
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF43365008.5559F266-ON482575F2.001F17EE-482575F2.00212259@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 13 Jul 2009 13:56:22 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/07/13 ?? 01:56:23,
	Serialize complete at 2009/07/13 ?? 01:56:23
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6D63aXx000762

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-07-10 20:49:44:

> struct pt_regs {
>        unsigned long pad0[6];
>        unsigned long orig_r4;
>        unsigned long orig_r7;
>        unsigned long regs[32];
> 
>        unsigned long cel;
>        unsigned long ceh;
> 
>        unsigned long sr0;      /* cnt */
>        unsigned long sr1;      /* lcr */
>        unsigned long sr2;      /* scr */
> 
>        unsigned long cp0_epc;
>        unsigned long cp0_ema;
>        unsigned long cp0_psr;
>        unsigned long cp0_ecr;
>        unsigned long cp0_condition;
> 
>        long is_syscall;
> };
> 
> to
> 
> struct pt_regs {
>        unsigned long regs[32];
> 
>        unsigned long cel;
>        unsigned long ceh;
> 
>        unsigned long sr0;      /* cnt */
>        unsigned long sr1;      /* lcr */
>        unsigned long sr2;      /* scr */
> 
>        unsigned long cp0_epc;
>        unsigned long cp0_ema;
>        unsigned long cp0_psr;
>        unsigned long cp0_ecr;
>        unsigned long cp0_condition;
> #ifdef __KERNEL__
>        unsigned long orig_r4;
>        unsigned long orig_r7;
>        long is_syscall;
>        unsigned long pad0[3];
> #else
>        unsigned long pad0[6];
> #endif
> };
> 

unsigned long pad0[6];

was place at the start of pt_regs use 
to hold the arguments from userland.
caller(exception handler) not need to
change stack pointer.

unsigned long orig_r4;
unsigned long orig_r7;
move to end of the pt_regs haven't 
problem.

Thanks,
Liqin

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

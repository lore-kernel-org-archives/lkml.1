Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbZGNCHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbZGNCHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZGNCHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:07:50 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:59060 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZGNCHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:07:49 -0400
X-Greylist: delayed 1152 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 22:07:49 EDT
In-Reply-To: <200907131624.28286.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Subject: Re: [PATCH V2] score: add regset support
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF52BCF60D.13CE2E5B-ON482575F3.000933A6-482575F3.0009E41C@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 14 Jul 2009 09:42:28 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/07/14 ?? 09:42:29,
	Serialize complete at 2009/07/14 ?? 09:42:29
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6E28CXx015934

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-07-13 22:24:28:

> Maybe to get a nicer layout, you can define separate
> structures then:
> 
> struct user_regs_struct {
>         unsigned long regs[32];
> 
>         unsigned long cel;
>         unsigned long ceh;
> 
>         unsigned long sr0;      /* cnt */
>         unsigned long sr1;      /* lcr */
>         unsigned long sr2;      /* scr */
> 
>         unsigned long cp0_epc;
>         unsigned long cp0_ema;
>         unsigned long cp0_psr;
>         unsigned long cp0_ecr;
>         unsigned long cp0_condition;
> 
>    unsigned long reserved[6]; /* future extensions */
> };
> 
> #ifdef __KERNEL__
> struct pt_regs {
>    /* stack arguments */
>         unsigned long pad0[6];
> 
>    /* internal use */
>         unsigned long orig_r4;
>         unsigned long orig_r7;
>         long is_syscall;
> 
>    /* saved registers */
>    struct user_regs_struct uregs;
> };
> #endif
> 
> That would keep the user struct relatively clean.

OK, I will send this patch soon.

Thanks,
liqin

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

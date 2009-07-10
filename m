Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZGJJNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZGJJNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZGJJMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:12:53 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:33769 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZGJJMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:12:52 -0400
In-Reply-To: <20090709210356.B1FD96BA56@magilla.sf.frob.com>
To: Roland McGrath <roland@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Subject: Re: [PATCH] score: add regsets support for score
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OFE8F25211.6F919E29-ON482575EF.0031BE0C-482575EF.00328689@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 10 Jul 2009 17:06:27 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/07/10 ?? 05:06:42,
	Serialize complete at 2009/07/10 ?? 05:06:42
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6A9D3Xx020880

Roland McGrath <roland@redhat.com> Ğ´ÓÚ 2009-07-10 05:03:56:

> > > +       ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> > > +                                 regs->regs,
> > > +                                 offsetof(struct pt_regs, regs),
> > > +                                 end_pos);
> 
> This looks odd to me.  The last two arguments here are offsets into
> the userland ABI format defined by the user_regset layout.  Unless
> offsetof(struct pt_regs, regs) is zero, then you need to precede
> this call with one that fills in the initial stretch of the userland
> format layout from its 0 up to offsetof(struct pt_regs, regs).  If
> in fact offsetof(struct pt_regs, regs) is zero, then it would be far
> less confusing to just write 0 there IMHO.  Using offsetof on
> pt_regs at all here is very confusing to me unless pt_regs describes
> the userland ABI layout (in which case the use here still doesn't
> make sense).

Thanks Roland,

Maybe I misunderstand the arguments meaning of
user_regset_copy(in/out), I rewrite these code,
use userland ABI format the same as score's pt_regs, 
just like sh arch do, maybe it's easy to understand.
It will be sent out latter.

Best Regards
Liqin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

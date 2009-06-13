Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZFMGsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZFMGsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZFMGsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:48:43 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:57496 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZFMGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:48:42 -0400
In-Reply-To: <200906091952.47842.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 22/27] score: create kernel files signal.c sys_score.c time.c
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF3AABEDAD.28BB4A96-ON482575D4.0024BA2D-482575D4.002550FA@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sat, 13 Jun 2009 14:43:08 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/13 ?? 02:43:08,
	Serialize complete at 2009/06/13 ?? 02:43:08
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5D6nQ54011766

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-06-10 01:52:47:

> On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> > +asmlinkage long sys_mmap(unsigned long addr, size_t len,
> > +                       unsigned long prot, unsigned long flags,
> > +                       unsigned long fd, off_t offset)
> > +{
> > +       int err = -EINVAL;
> > +
> > +       if (offset & ~PAGE_MASK) {
> > +               printk(KERN_INFO "no pagemask in mmap\r\n");
> > +               goto out;
> > +       }
> > +
> > +       err = sys_mmap2(addr, len, prot, flags, fd, offset >> 
PAGE_SHIFT);
> > +out:
> > +       return err;
> > +}
> 
> A 32 bit kernel should only need sys_mmap2, not sys_mmap, because it is
> trivial to convert in user space.
> 
> > +
> > +asmlinkage long score_vfork(struct pt_regs *regs)
> > +{
> > +       return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, 
regs->regs[0],
> > +                                               regs, 0, NULL, NULL);
> > +}
> > +
> > +/*
> > + * Fork a new task - this creates a new program thread.
> > + * This is called indirectly via a small wrapper
> > + */
> > +asmlinkage int
> > +score_fork(struct pt_regs *regs)
> > +{
> > +       return do_fork(SIGCHLD, regs->regs[0], regs, 0, NULL, NULL);
> > +}
> 
> Similarly, you should not need vfork and fork any more, because they can
> be handled in user space through clone().
> 

OK, I remove these from my code.

Best Regards
liqin
--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

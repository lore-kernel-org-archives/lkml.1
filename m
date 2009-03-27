Return-Path: <linux-kernel-owner+w=401wt.eu-S1763530AbZC0BuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763530AbZC0BuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763364AbZC0Bt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:49:59 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:45547 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686AbZC0Bt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:49:58 -0400
In-Reply-To: <87a5b0800903250501k3884dfb5qa09c67d209f80a05@mail.gmail.com>
To: Will Newton <will.newton@gmail.com>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 0/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF39905543.8F85F55B-ON48257586.000793DC-48257586.0007F946@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:25:21 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:25:22,
	Serialize complete at 2009/03/27 ?? 09:25:22
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2R1ogqu024609

Will Newton <will.newton@gmail.com> Ğ´ÓÚ 2009-03-25 20:01:02:

> 2009/3/25  <liqin.chen@sunplusct.com>:
> >>
> >> To allow people to more easily review your patches it is recommended
> >> to spit them up into smaller pieces and submit them to the mailing
> >> list.
> >
> > According to the "The linux-kernel mailing list FAQ" and
> > "Documentation/SubmittingPatches",
> > E-mail size exceeds 40 kB, "it is preferred that you store
> > your patch on an Internet-accessibleserver, and provide
> >  instead a URL (link) pointing to your patch."
> > linux/score patch size over 400 kB, so we only provide
> > the URL (link) in mail.
> 
> Yes, that's true. However if you split that up into 10-20 separate
> emails then it's quite manageable. The advantage of posting to the
> list is that many more people will review your code.
> 
> You could also cc the linux-arch mailing list.
> 
> > But if other person or Linus also think we should spit them up
> > into smaller pieces, we will do it.
> >
> >>
> >> Your port looks relatively clean but it looks like it is borrowing
> >> heavily from the mips port and you may have a few leftovers from that
> >> e.g.:
> >>
> >
> > Yes, we use linux/mips as reference for linux/score platform.
> > In order to make the patch clear, we used more C code instead of
> > assembler code. After patch merge to the mainline,
> > we will provide optimized assembler code one by one.
> >
> >> - mentions of o32 (unless S+CORE has an o32 ABI?)
> >> - does SCORE+ have ll/sc instructions or is that another leftover 
from
> > MIPS?
> >
> > No, I had removed these leftover code.
> >
> >> - compatibility syscalls, sys_ipc, old-style signal handling. Are
> >> these really needed for a new arch?
> >
> > Because we use glibc-2.3.6 as base library, LTP and many applications
> > are all running on it. so we leave many old syscall in score code,
> > once we are sure it's not necessary, we will remove these syscall.
> 
> Once code is merged into mainline it becomes a lot harder to justify
> making changes that break backwards compatibility such as removing
> system calls. It's easier in the long term to make sure your system
> call interface is cleaned up now rather than later.
> 
> Have you come across Arnd Bergmann's work on creating a generic arch
> for porting?
> 
> http://lwn.net/Articles/307713/
> 
> It's a good reference to check which system calls are considered
> current and which headers are generic in new ports etc.
> 

Had removed compatibility syscalls from the code.
last patch still placed at
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

> >> - does your port support SMP?
> >
> > No, but we consider todo it next step.
> >
> > We have updated the patch use the same URL(link)
> > 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch
> > if other person think it should be splited into smaller pieces,
> > please let me know.
> >
> > Thanks Will Newton
> > --
> > liqin
> >
> > Will Newton <will.newton@gmail.com> Ğ´ÓÚ 2009-03-24 19:00:05:
> >
> >> On Tue, Mar 24, 2009 at 3:46 AM,  <liqin@sunnorth.com.cn> wrote:
> >> > Hello, Linus and folks,
> >> >
> >> > We have ported Linux to the S+CORE processor, which is a 32-bit 
RISC
> >> > embedded
> >> > microprocessor of Sunplus Core Technology.
> >> >
> >> > SPG29X, SPG300(score core) processor have been used in game 
products.
> >> > and score toolchain have commit to gnu in 2006. We have a team to
> > maintain
> >> > score code for linux kernel.
> >> >
> >> > We would like to release a patch for kernel 2.6.29-rc8.
> >> > This patch include score header files, arch files and serial driver
> > for
> >> > spct6600(score core) platform.
> >> >
> >> > For the other driver patches, I'll send them one by one in
> >> > small size latter. Thanks!
> >> >
> >> > Would you merge them to the stock kernel?
> >> >
> >> > Patch information is slightly bigger, so I placed it on our 
SunplusCT
> > web
> >> > site.
> >> >
> > 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch
> >> >
> >> > Signed off by: Chen Liqin <liqin.chen@sunplusct.com,
> >> > liqin@sunnorth.com.cn>
> >

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

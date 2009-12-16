Return-Path: <linux-kernel-owner+w=401wt.eu-S934550AbZLPCXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbZLPCXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934531AbZLPCXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:23:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48123 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934516AbZLPCXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:23:43 -0500
Date: Wed, 16 Dec 2009 11:23:37 +0900 (JST)
Message-Id: <20091216.112337.193692601.d.hatayama@jp.fujitsu.com>
To: xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Subject: Re: [RFC, PATCH 1/4] cleanup elf_core_dump(): remove
 ELF_CORE_EXTRA_* macro
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <2375c9f90912142358j24cc1bf8p2f696f56537befc6@mail.gmail.com>
References: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com>
	<2375c9f90912142358j24cc1bf8p2f696f56537befc6@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Dec 15, 2009 at 10:41 AM, Daisuke HATAYAMA
> <d.hatayama@jp.fujitsu.com> wrote:
> > elf_core_dump() uses #ifdef and the corresponding macro for hiding
> > _multiline_ logics in functions. This patch removes #ifdef and
> > replaces ELF_CORE_EXTRA_* by corresponding functions. For
> > architectures not implemeonting ELF_CORE_EXTRA_*, we use weak
> > functions in order to reduce a range of modification.
> >
> > This cleanup is for my next patches, but I think this cleanup itself
> > is worth doing regardless of my firnal purpose.
> >
> > Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
> 
> 
> Good patch! I like it!
> 
> Just one problem below.
> 
> 
> > --- /dev/null
> > +++ b/arch/um/sys-i386/elfcore.c
> > @@ -0,0 +1,78 @@
> > +#include <linux/elf.h>
> > +#include <linux/fs.h>
> > +#include <linux/mm.h>
> > +
> > +#include <asm/elf.h>
> > +
> > +static int dump_write(struct file *file, const void *addr, int nr)
> > +{
> > +       return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
> > +}
> 
> We already have the same dump_write() in fs/binfmt_elf.c, can't we
> reuse it? e.g. moving it to a header and make it staic inline.

Thanks for you comment.

I understand what you say.

I think now I will move it to include/linux/elfcore.h.

> 
> Thanks!

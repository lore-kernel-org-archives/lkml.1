Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbZLPEHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbZLPEHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 23:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZLPEHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 23:07:51 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52396 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbZLPEHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 23:07:50 -0500
Date: Wed, 16 Dec 2009 13:07:44 +0900 (JST)
Message-Id: <20091216.130744.183025994.d.hatayama@jp.fujitsu.com>
To: mhiramat@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com
Subject: Re: [RFC, PATCH 1/4] cleanup elf_core_dump(): remove
 ELF_CORE_EXTRA_* macro
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4B27A7CD.1040008@redhat.com>
References: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com>
	<4B27A7CD.1040008@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC, PATCH 1/4] cleanup elf_core_dump(): remove ELF_CORE_EXTRA_* macro
Date: Tue, 15 Dec 2009 10:14:21 -0500

> Daisuke HATAYAMA wrote:
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
> > ---
> >  arch/ia64/kernel/Makefile  |    2 +
> >  arch/ia64/kernel/elfcore.c |   75 ++++++++++++++++++++++++++++++++++++++++++
> >  arch/um/sys-i386/Makefile  |    2 +
> >  arch/um/sys-i386/elfcore.c |   78 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/binfmt_elf.c            |   36 +++++++++++++++-----
> >  include/linux/elf.h        |    2 +
> 

> Hmm, why don't you remove ELF_CORE_EXTRA_* macros too??
> And also, you have to update fs/binfmt_elf_fdpic.c too.
> 
> Thank you,

The reason relates to the fact that elf_core_extra_* functions for
architectures with no extra data are defined as the weak ones. As I've
written in the patch description, they are useful to reduce a range of
modification.

If I modify fs/binfmt_elf.c, I need to prepare another file in order
for binfmt_elf{,_fdpic}.c to share the weak functions. (Now the week
functions are defined in fs/binfmt_elf.c.)

The problem is that I don't know where to put new file elfcore.c for
weak functions. I am not familiar with such convension.

For example, is it right to put fs/elfcore.c or kernel/elfcore.c?

Thanks.

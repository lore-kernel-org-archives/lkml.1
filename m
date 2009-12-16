Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbZLPCYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbZLPCYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934533AbZLPCYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:24:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50193 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556AbZLPCYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:24:11 -0500
Date: Wed, 16 Dec 2009 11:24:02 +0900 (JST)
Message-Id: <20091216.112402.226798335.d.hatayama@jp.fujitsu.com>
To: xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Subject: Re: [RFC, PATCH 4/4] elf_core_dump(): Add extended numbering
 support
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <2375c9f90912150027h2435fad9yc35bc360f743d7a6@mail.gmail.com>
References: <20091215.114149.189724375.d.hatayama@jp.fujitsu.com>
	<2375c9f90912150027h2435fad9yc35bc360f743d7a6@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I agree with two of three cleanup ideas, but the last.

> > @@ -2079,11 +2139,19 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
> >        if (!elf_core_write_extra_data(file, &size, limit))
> >                goto end_coredump;
> >
> > +       if (e_phnum == PN_XNUM) {
> > +               size += sizeof(*shdr4extnum);
> > +               if (size > limit
> > +                   || !dump_write(file, shdr4extnum, sizeof(*shdr4extnum)))
> > +                       goto end_coredump;
> > +       }
> > +
> >  end_coredump:

There are two reasons I wrote like this.

First, the code like

if (size > limit || !dump_write(file, obj, sizeof(*obj)))
   goto end_coredump;

is used as the common idiom in thourghout elf_core_dump().  Not
writing goto only at the last use seems unnatural for me.

Second, there is a possibility that new writing operation for section
header table will be added. If the goto is removed now, the patch
writer must rewrite it again.

Thanks for your comments.

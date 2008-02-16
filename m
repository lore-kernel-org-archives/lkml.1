Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYBPIyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYBPIyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 03:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYBPIym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 03:54:42 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:32063 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYBPIyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 03:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=jI66wFrTej3UmzfXasf9FnzOrSGghkcqdstxNIrIsLAiIH7XW3cbfpSrLX8OTHAgubIcDXqIBQQJfu+Dnb+LcGimSoCZiz8FxM/b7/nKwWvN5/zIiSQRdhL/c6w1DRQTkdslRAFyMa5XPGs+MNaLqKJMXuK3Ko00Iu2UP+uzuwc=
Date: Sat, 16 Feb 2008 16:50:24 +0800 (CST)
Message-Id: <20080216.165024.199372966.xiyou.wangcong@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Fix shadowed variables in fs/binfmt_elf.c
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080215123459.0a675826.akpm@linux-foundation.org>
References: <20080215.215802.139099786.xiyou.wangcong@gmail.com>
	<20080215123459.0a675826.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Fix shadowed variables in fs/binfmt_elf.c
Date: Fri, 15 Feb 2008 12:34:59 -0800
Message-ID: <20080215123459.0a675826.akpm@linux-foundation.org>

> On Fri, 15 Feb 2008 21:58:02 +0800 (CST)
> WANG Cong <xiyou.wangcong@gmail.com> wrote:
> 
> > 
> > Fix these sparse warings:
> > fs/binfmt_elf.c:1749:29: warning: symbol 'tmp' shadows an earlier one
> > fs/binfmt_elf.c:1734:28: originally declared here
> > fs/binfmt_elf.c:2009:26: warning: symbol 'vma' shadows an earlier one
> > fs/binfmt_elf.c:1892:24: originally declared here
> > 
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> > 
> > ---
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index 41a958a..6562563 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -1746,11 +1746,11 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
> >  		while_each_thread(g, p);
> >  		rcu_read_unlock();
> >  		list_for_each(t, &info->thread_list) {
> > -			struct elf_thread_status *tmp;
> > +			struct elf_thread_status *temp;
> >  			int sz;
> >  
> > -			tmp = list_entry(t, struct elf_thread_status, list);
> > -			sz = elf_dump_thread_status(signr, tmp);
> > +			temp = list_entry(t, struct elf_thread_status, list);
> > +			sz = elf_dump_thread_status(signr, temp);
> >  			info->thread_status_size += sz;
> >  		}
> >  	}
> 
> `tmp' is an awful identifier, and renaming it to "temp" hardly improves it.
> Please take any opportunity to fix this sort of thing.
> 
> I chose "ets" which is a bit weird but once one understand what it means,
> it makes the code much easier to follow.
> 
> Also used the same local for both loops.  There seems little point in
> instantiating a second one.

I agree. The first 'tmp' you showed is really not good, 'ets' is better.

Thanks, Andrew!

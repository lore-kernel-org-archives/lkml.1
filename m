Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZG1OlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZG1OlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZG1OlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:41:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33923 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZG1OlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:41:17 -0400
Date: Tue, 28 Jul 2009 16:37:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] task_struct cleanup: move binfmt field to mm_struct
Message-ID: <20090728143734.GA6664@redhat.com>
References: <4A56FEF7.80207@ct.jp.nec.com> <20090722132302.a9889eb3.akpm@linux-foundation.org> <20090722220353.88B2A67B6E@magilla.sf.frob.com> <20090723161806.GA5690@redhat.com> <4A68FD3B.7040606@ct.jp.nec.com> <4A693569.1090009@ct.jp.nec.com> <20090724161449.GA3509@redhat.com> <4A6CF466.9040608@ct.jp.nec.com> <20090727165901.GA8854@redhat.com> <4A6E98DC.5020200@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6E98DC.5020200@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Hiroshi Shimamoto wrote:
>
> Oleg Nesterov wrote:
> > (add Rusty)
> >
> > On 07/27, Hiroshi Shimamoto wrote:
> >>  void set_binfmt(struct linux_binfmt *new)
> >>  {
> >> -	if (current->binfmt)
> >> -		module_put(current->binfmt->module);
> >> +	struct mm_struct *mm = current->mm;
> >> +
> >> +	BUG_ON(!mm);
> >> +	if (mm->binfmt)
> >
> > I am not sure we need this BUG_ON() above. If mm == NULL we will
> > have the same debug info after the crash.
>
> Ah, right. It will crash at accessing mm->binfmt and we'll get the
> same information. I didn't think seriously.
> BTW, now I noticed that it looks similar the security issue with
> NULL page mapping. If the kernel has the page mapping to NULL,
> it causes unstable behavior, no?

The kernel can't have NULL mapped. The task can, but in this case
it must have a valid ->mm != NULL.

IOW, if current->mm == NULL, current uses init_mm and thus NULL
can't be mapped.

Oleg.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbXGJIl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbXGJIl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbXGJIlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:41:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:5756 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbXGJIlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=U+7QodlsMATlUD5z3Rj86YanyfpNAaeDs9Hu6vpIJWcBEne9ELyaFMpZRjC4u2GR+Gs5f+Phhv4IGGfp069cbR7CzlK+3H4xj536YeAEbVAmhhj9T3Td5z2uwOPugjPtw0Wnv1RTpJotDxyhOeLmm1A1WcJ180S6xWA9RrL+DfM=
Message-ID: <661de9470707100141h779e75eev9c09fdb2dfd09b8b@mail.gmail.com>
Date: Tue, 10 Jul 2007 14:11:18 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Subject: Re: [-mm PATCH 4/8] Memory controller memory accounting (v2)
Cc: svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com
In-Reply-To: <20070710072651.C061D1BF77E@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070706052135.11677.28030.sendpatchset@balbir-laptop>
	 <20070710072651.C061D1BF77E@siro.lan>
X-Google-Sender-Auth: 5238e669fdc3a50a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
> hi,
>
> > diff -puN mm/memory.c~mem-control-accounting mm/memory.c
> > --- linux-2.6.22-rc6/mm/memory.c~mem-control-accounting       2007-07-05 13:45:18.000000000 -0700
> > +++ linux-2.6.22-rc6-balbir/mm/memory.c       2007-07-05 13:45:18.000000000 -0700
>
> > @@ -1731,6 +1736,9 @@ gotten:
> >               cow_user_page(new_page, old_page, address, vma);
> >       }
> >
> > +     if (mem_container_charge(new_page, mm))
> > +             goto oom;
> > +
> >       /*
> >        * Re-check the pte - we dropped the lock
> >        */
>
> it seems that the page will be leaked on error.

You mean meta_page right?

>
> > @@ -2188,6 +2196,11 @@ static int do_swap_page(struct mm_struct
> >       }
> >
> >       delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
> > +     if (mem_container_charge(page, mm)) {
> > +             ret = VM_FAULT_OOM;
> > +             goto out;
> > +     }
> > +
> >       mark_page_accessed(page);
> >       lock_page(page);
> >
>
> ditto.
>
> > @@ -2264,6 +2278,9 @@ static int do_anonymous_page(struct mm_s
> >               if (!page)
> >                       goto oom;
> >
> > +             if (mem_container_charge(page, mm))
> > +                     goto oom;
> > +
> >               entry = mk_pte(page, vma->vm_page_prot);
> >               entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> >
>
> ditto.
>
> can you check the rest of the patch by yourself?  thanks.
>

Excellent catch! I'll review the accounting framework and post the
updated version soon

Balbir

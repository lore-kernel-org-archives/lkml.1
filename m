Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbYARKa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbYARKa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYARKaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:30:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:21946 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYARKaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:30:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LZN4GG9tv7iWV9fQj/HHB+tiqVLAuXXAkXSZFNhmYNvNf+3z7tiNHURRH6fzPRueUWO9W42NDQHHMhho5MXUP4QZLHcHgGZTHfRGHSm8au7wIz8lccJVtxelEXXwIHy9f550xftFYtlIReHCvMJZ37Xml1jfBn9ITddC9q5jEU8=
Message-ID: <4df4ef0c0801180230r516085f0s3e6b919c395f33d2@mail.gmail.com>
Date: Fri, 18 Jan 2008 13:30:19 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH -v6 1/2] Massive code cleanup of sys_msync()
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <E1JFnbj-0008SD-57@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <12006091213248-git-send-email-salikhmetov@gmail.com>
	 <E1JFnbj-0008SD-57@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/18, Miklos Szeredi <miklos@szeredi.hu>:
> >       unsigned long end;
> > -     struct mm_struct *mm = current->mm;
> > +     int error, unmapped_error;
> >       struct vm_area_struct *vma;
> > -     int unmapped_error = 0;
> > -     int error = -EINVAL;
> > +     struct mm_struct *mm;
> >
> > +     error = -EINVAL;
>
> I think you may have misunderstood my last comment.  These are OK:
>
>         struct mm_struct *mm = current->mm;
>         int unmapped_error = 0;
>         int error = -EINVAL;
>
> This is not so good:
>
>         int error, unmapped_error;
>
> This is the worst:
>
>         int error = -EINVAL, unmapped_error = 0;
>
> So I think the original code is fine as it is.
>
> Othewise patch looks OK now.

I moved the initialization of the variables to the code where they are needed.

I don't agree that "int a; int b;" is better than "int a, b".

>
> Miklos
>

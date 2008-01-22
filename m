Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbYAVB52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbYAVB52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYAVB5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:57:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:44390 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbYAVB5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:57:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vhiQ2Z/Y57fEIBKemdf23eio4zjqa/P3HczxSHa4JG2qmqN0S4gIbKdk89gV6N0RPsaBKvKbvtjzA6XqFn5AmjOqu9D6fgyGHttyWGRrJ6zgtAACMp7tA7yC3jTJxG/1IYDkGaqGRK3yzwA8vcooGVOcLKFqdjsMCQMo/GPLuwY=
Message-ID: <4df4ef0c0801211757y1f751bbbv4ce4bbf7455a68c@mail.gmail.com>
Date: Tue, 22 Jan 2008 04:57:19 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH -v7 2/2] Update ctime and mtime for memory-mapped files
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, protasnb@gmail.com,
       miklos@szeredi.hu, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <9a8748490801211754t51cbc65bg20dea2f8cf6d4516@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12009619562023-git-send-email-salikhmetov@gmail.com>
	 <12009619584168-git-send-email-salikhmetov@gmail.com>
	 <9a8748490801211740r5c764f6ev9c331479f63ef362@mail.gmail.com>
	 <4df4ef0c0801211751w39d7b9e5ne2e8b788051d3e3a@mail.gmail.com>
	 <9a8748490801211754t51cbc65bg20dea2f8cf6d4516@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/22, Jesper Juhl <jesper.juhl@gmail.com>:
> On 22/01/2008, Anton Salikhmetov <salikhmetov@gmail.com> wrote:
> > 2008/1/22, Jesper Juhl <jesper.juhl@gmail.com>:
> > > Some very pedantic nitpicking below;
> > >
> > > On 22/01/2008, Anton Salikhmetov <salikhmetov@gmail.com> wrote:
> ...
> > > > +               if (file && (vma->vm_flags & VM_SHARED)) {
> > > > +                       if (flags & MS_ASYNC)
> > > > +                               vma_wrprotect(vma);
> > > > +                       if (flags & MS_SYNC) {
> > >
> > > "else if" ??
> >
> > The MS_ASYNC and MS_SYNC flags are mutually exclusive, that is why I
> > did not use the "else-if" here. Moreover, this function itself checks
> > that they never come together.
> >
>
> I would say that them being mutually exclusive would be a reason *for*
> using "else-if" here.

This check is performed by the sys_msync() function itself in its very
beginning.

We don't need to check it later.

>
> --
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
>

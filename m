Return-Path: <linux-kernel-owner+w=401wt.eu-S966572AbXEHRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966572AbXEHRN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934424AbXEHRNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:13:55 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:13455 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934225AbXEHRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bQ3WhnRbWCqNmgLXumuFPzUyFlvAY3/QzwW8zfSRLd0FTp4wgMmJpf4Kg3rSmNCUAvfeacCzWStXdaoefPf21flejtNQw+bPC5bxUgTbGsLF5DiRp1LD40dt4jZbi2gj5FlU7FvBFI3xUtM6zI8XdWSqAuDYHVLEnVkdPNlLypk=
Message-ID: <a781481a0705081013q7b54906dsdf28d922e198a463@mail.gmail.com>
Date: Tue, 8 May 2007 10:13:52 -0700
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [KJ PATCH] Replacing memset(<addr>,0,PAGE_SIZE) with clear_page() in kernel/kexec.c
Cc: "Michael Tokarev" <mjt@tls.msk.ru>,
       "Shani Moideen" <shani.moideen@wipro.com>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
In-Reply-To: <84144f020705080521k6d75d9f8m33e25585735e4f7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178621444.3598.15.camel@shani-win>
	 <46405AB6.6040901@msgid.tls.msk.ru>
	 <84144f020705080521k6d75d9f8m33e25585735e4f7e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Shani Moideen wrote:
> > >                 ptr = kmap(page);
> > > -               memset(ptr, 0, PAGE_SIZE);
> > > +               clear_page(ptr);
>
> On 5/8/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
> > I wonder if it's worth to invent kzmap() or something like that... ;)
>
> I am counting 59 kmap + memset pairs in the kernel, so perhaps it is
> worth it to reduce kernel text size.

Stuff of the sort already exists. Look for clear_highpage(),
clear_user_highpage() and memclear_highpage_flush (recently renamed to
zero_user_page, see -mm). But they all use kmap_atomic() -- kmap()
variants would have to be added. Also, they're all inlines, so I'm not
sure you'd be able to cut down text size, but still getting rid of
open-coding is always good.

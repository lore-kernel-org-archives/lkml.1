Return-Path: <linux-kernel-owner+w=401wt.eu-S932656AbXIETro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbXIETro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbXIETrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:47:36 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:60708 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbXIETrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jyItUvpAY5gV4d4Zr+HNRz3rx38VbewBXT91fZxhGCqDA1Ie1AELRu6EI1/SmZ+axWCJwvwI2GyCehma5N5pEIpoXiyA5fLfiQeA4h/Atr8Od6s7obnuKTkBBYfM5CCua23npCH+JzAqCuEWk/OmK5a980T7gY15TL8TboUMO/k=
Message-ID: <dda83e780709051247u447d9f0eg5033bd88fb4ee83f@mail.gmail.com>
Date: Wed, 5 Sep 2007 12:47:33 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: nfs4 hang regression
Cc: linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
In-Reply-To: <20070905085120.bc90ffe2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780708221541x4fabd27er64e6ecaa33ddccbf@mail.gmail.com>
	 <20070905085120.bc90ffe2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/5/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 22 Aug 2007 15:41:18 -0700 "Bret Towe" <magnade@gmail.com> wrote:
>
> More than two weeks, you've bisected it and there's no sign of any action?
>
> I don't see this on Michal's list so perhaps it already got fixed in a different
> thread.  Have you tested current mainline?

It's been fixed, this thread was never replied to since I replied to
another thread
someone else started that was the same issue

Thanks for keeping watch tho :)

> > as of commit 3d39c691ff486142dd9aaeac12f553f4476b7a62
> > I got a hang on my clients after something around 26 minutes of uptime
> > the keyboard would stop accepting input
> > mouse would work still, plugging in a spare usb keyboard made no difference
> > another couple odd bits is shutting down would hang, below is a trace
> > of that hang
> > also if your logged into that machine via ssh when you log out it would hang
> > and would require a force terminate
> >
> > I'm seeing this on 2 machines 1 a g4 mac mini and 2 a athlon64
> > both have a home directory mounted via nfs4
> > reverting the commit above found via bisecting on both machines allows me
> > to use the computers for several hours with no issues
> >
> > and here is the trace from the athlon64 taken during its hang on shutdown
> > as you can tell from the dates in the trace ive been a bit busy and just
> > now got around to sending this email
> > I'm surprised tho I hadn't seen anyone hitting it
> > let me know what else is needed I'll do what I can and get it out quickly
> >
> > Aug 12 17:06:35 ghoststar kernel: [ 4791.801262] SysRq : Show State
> > Aug 12 17:06:35 ghoststar kernel: [ 4791.801325]   task
> >         PC stack   pid father
> > Aug 12 17:06:35 ghoststar kernel: [ 4791.801327] init          S
> > 00000000ffffffff     0     1      0
> > Aug 12 17:06:35 ghoststar kernel: [ 4791.801331]  ffff81003ff879b8
> > 0000000000000086 0000000000000008 ffff81003ff84000
>
> I really wish that hadn't been wordwrapped.
>
> As a random stab-in-the-dark, does this help?
>
> --- a/fs/nfs/nfs4renewd.c~a
> +++ a/fs/nfs/nfs4renewd.c
> @@ -133,9 +133,7 @@ nfs4_renewd_prepare_shutdown(struct nfs_
>  void
>  nfs4_kill_renewd(struct nfs_client *clp)
>  {
> -       down_read(&clp->cl_sem);
>         cancel_delayed_work_sync(&clp->cl_renewd);
> -       up_read(&clp->cl_sem);
>  }
>
>  /*
> _
>
>

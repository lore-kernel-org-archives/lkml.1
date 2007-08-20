Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbXHTO0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbXHTO0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759051AbXHTO0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:26:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:49869 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbXHTO0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:26:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q3ThGW+w3idthwNXhgZTqcasauM3g+BmLCga4rfnntnKH1kj99OuOHl9X/nAC5yrR8XtogQRBe8KS/24M6/vR2DT0Zs/Y9zvHUPsWM+U4THK2kF0l6ESMUDMDkEHg4VPZP9qjmeJwpLxVjIY+6uRWfz7w3q2yTxoxK+raPzakZQ=
Message-ID: <25ae38200708200726tdf097b1kcd0269cf11c53bf3@mail.gmail.com>
Date: Mon, 20 Aug 2007 19:56:00 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: Fork Bombing Patch
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m3lkcbu3ps.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	 <m3lkcbu3ps.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
  I think Its not worth to make it configurable just for one printk
statement. am i missing something?

anand

On 8/16/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Anand Jahagirdar" <anandjigar@gmail.com> writes:
>
> > +++ linux-2.6.17/kernel/fork.c
> > +        /*
> > +         * following code does not allow Non Root User to cross its process
> > +         * limit and it alerts administrator about user Nearing the process limit.
> > +         */
> > +
> >               if (atomic_read(&p->user->processes) >= p->signal->rlim[RLIMIT_NPROC].rlim_cur)
> >               if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
> > -                             p->user != &root_user)
> > +                             p->user != &root_user)  {
> > +                        if (printk_ratelimit())
> > +                                printk(KERN_WARNING "User with uid %u is Nearing the process limit\n",p->user->uid);
> > +
> >                        goto bad_fork_free;
>
> At least make that configurable - on some systems users are allowed
> 50 processes or so and I'm sure admins don't really want to know
> which particular users are currently close to limits.
>
> I don't really find the above useful. Perhaps we should warn when users
> try to write to R/O files or execute root-only commands etc?
> --
> Krzysztof Halasa
>

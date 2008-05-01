Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbYEAPRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbYEAPRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYEAPRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:17:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:58466 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYEAPRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j6y37tbQhkOAq8YpnzomGi4SC8NfReQP2VAGZ5XFYxUPteSe8W7ADR4UohbpDoAkSs9NUMhClIeoajQF72pUTat9L5OhJAcbYYJKWp8CRuh2/fQWyCpU7nVZV3+jHVORFuAV/bAviCjKXNAwh3juXiWN+q5Rj+JUmCFSz2dQ8po=
Message-ID: <6101e8c40805010817p33cc9bb3v8d80ab857af967b9@mail.gmail.com>
Date: Thu, 1 May 2008 17:17:03 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: [OP] v2.6.22.22-op1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6101e8c40805010814rf64d402l1a9da0c3e22b9668@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <db9953cd52eb63e471f5fcdcb83b299b@zipernowsky.hu>
	 <x49fxt2axns.fsf@segfault.boston.devel.redhat.com>
	 <6101e8c40805010814rf64d402l1a9da0c3e22b9668@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sure, bad branch see I

On 5/1/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> On 5/1/08, Jeff Moyer <jmoyer@redhat.com> wrote:
> > <oliver@zipernowsky.hu> writes:
> >
> > > I announced the v2.6.22.22-op1 "stable" kernel.
> >
> > >  fs/aio.c                    |   23 ++++++++++++-----------
> >
> > > Jeff Moyer (1):
> > >       aio: account I/O wait time properly
> >
> > This version of the patch introduced a regression for UML.  It was
> > seeing 100% iowait time when it wasn't waiting on any I/O.  There was a
> > follow-up patch which did the io_schedule conditionally, see commit id:
> >
> >   e00ba3dae077f54cfd2af42e939a618caa7a3bca
> >
> > Cheers,
> >
> > Jeff
> >
> > > diff --git a/fs/aio.c b/fs/aio.c
> > > index dbe699e..b3419c5 100644
> > > --- a/fs/aio.c
> > > +++ b/fs/aio.c
> > > @@ -1170,7 +1171,7 @@ retry:
> > >  			ret = 0;
> > >  			if (to.timed_out)	/* Only check after read evt */
> > >  				break;
> > > -			schedule();
> > > +			io_schedule();
> > >  			if (signal_pending(tsk)) {
> > >  				ret = -EINTR;
> > >  				break;
> >
>
>
> hmm, this is the relevant code in 2.6.22:
> ----8<-------------->8-----
>                         if (min_nr <= i)
>                                 break;
>                         ret = 0;
>                         if (to.timed_out)       /* Only check after read evt
> */
>                                 break;
>                         schedule(); <-----------
>                         if (signal_pending(tsk)) {
>                                 ret = -EINTR;
>                                 break;
>                         }
>                         /*ret = aio_read_evt(ctx, &ent);*/
> ----8<-------------->8-----
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver

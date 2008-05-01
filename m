Return-Path: <linux-kernel-owner+w=401wt.eu-S1761111AbYEAO44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761111AbYEAO44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbYEAO4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:56:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:16709 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbYEAO4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tOFCagr55BLXiCTcG0L6nvqpDO5FjIAsm4oh24CPi96MDHPlwigmK3hz9NVfHkuXs9JsysQM4MoT3MhiZcgH4s9CeeKAMUAaAVzA0q1NSlKIPXws5OTEQO5H33ZvEq/CywTIMFEdMycwLOY8k9ORAZBOGC/ND15jJUREH9Oq0r0=
Message-ID: <6101e8c40805010756m3a2418f8qde57458481b014a2@mail.gmail.com>
Date: Thu, 1 May 2008 16:56:41 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: [OP] v2.6.22.22-op1
Cc: linux-kernel@vger.kernel.org, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Badari Pulavarty" <pbadari@us.ibm.com>,
       "Benjamin LaHaise" <bcrl@kvack.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Hugh Dickins" <hugh@veritas.com>, "James Morris" <jmorris@namei.org>,
       "Jan Kara" <jack@ucw.cz>, "Jeff Garzik" <jeff@garzik.org>,
       "Jeff Roberson" <jroberson@chesapeake.net>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Johann Felix Soden" <johfel@users.sourceforge.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Patrick McHardy" <kaber@trash.net>,
       "Robert Love" <rlove@google.com>, "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>, "Willy Tarreau" <w@1wt.eu>,
       "Yan Zheng" <yanzheng@21cn.com>, "Zach Brown" <zach.brown@oracle.com>
In-Reply-To: <x49fxt2axns.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <db9953cd52eb63e471f5fcdcb83b299b@zipernowsky.hu>
	 <x49fxt2axns.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff!

thanks, then fixed it

On 5/1/08, Jeff Moyer <jmoyer@redhat.com> wrote:
> <oliver@zipernowsky.hu> writes:
>
> > I announced the v2.6.22.22-op1 "stable" kernel.
>
> >  fs/aio.c                    |   23 ++++++++++++-----------
>
> > Jeff Moyer (1):
> >       aio: account I/O wait time properly
>
> This version of the patch introduced a regression for UML.  It was
> seeing 100% iowait time when it wasn't waiting on any I/O.  There was a
> follow-up patch which did the io_schedule conditionally, see commit id:
>
>   e00ba3dae077f54cfd2af42e939a618caa7a3bca
>
> Cheers,
>
> Jeff
>
> > diff --git a/fs/aio.c b/fs/aio.c
> > index dbe699e..b3419c5 100644
> > --- a/fs/aio.c
> > +++ b/fs/aio.c
> > @@ -1170,7 +1171,7 @@ retry:
> >  			ret = 0;
> >  			if (to.timed_out)	/* Only check after read evt */
> >  				break;
> > -			schedule();
> > +			io_schedule();
> >  			if (signal_pending(tsk)) {
> >  				ret = -EINTR;
> >  				break;
>


-- 
Thanks,
Oliver

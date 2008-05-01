Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbYEAO5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbYEAO5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 10:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbYEAO5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 10:57:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbYEAO5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 10:57:39 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: oliver.pntr@gmail.com
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Chris Wright <chrisw@sous-sol.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "David S. Miller" <davem@davemloft.net>,
       Grant Grundler <grundler@parisc-linux.org>,
       Hugh Dickins <hugh@veritas.com>, James Morris <jmorris@namei.org>,
       Jan Kara <jack@ucw.cz>, Jeff Garzik <jeff@garzik.org>,
       Jeff Roberson <jroberson@chesapeake.net>,
       Jens Axboe <jens.axboe@oracle.com>,
       Johann Felix Soden <johfel@users.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Patrick McHardy <kaber@trash.net>,
       Robert Love <rlove@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Suparna Bhattacharya <suparna@in.ibm.com>, Willy Tarreau <w@1wt.eu>,
       Yan Zheng <yanzheng@21cn.com>, Zach Brown <zach.brown@oracle.com>
Subject: Re: [OP] v2.6.22.22-op1
References: <db9953cd52eb63e471f5fcdcb83b299b@zipernowsky.hu>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 01 May 2008 10:47:51 -0400
In-Reply-To: <db9953cd52eb63e471f5fcdcb83b299b@zipernowsky.hu>
	(oliver@zipernowsky.hu's message of "Thu, 01 May 2008 16:32:01 +0200")
Message-ID: <x49fxt2axns.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<oliver@zipernowsky.hu> writes:

> I announced the v2.6.22.22-op1 "stable" kernel.

>  fs/aio.c                    |   23 ++++++++++++-----------

> Jeff Moyer (1):
>       aio: account I/O wait time properly

This version of the patch introduced a regression for UML.  It was
seeing 100% iowait time when it wasn't waiting on any I/O.  There was a
follow-up patch which did the io_schedule conditionally, see commit id:

  e00ba3dae077f54cfd2af42e939a618caa7a3bca

Cheers,

Jeff

> diff --git a/fs/aio.c b/fs/aio.c
> index dbe699e..b3419c5 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1170,7 +1171,7 @@ retry:
>  			ret = 0;
>  			if (to.timed_out)	/* Only check after read evt */
>  				break;
> -			schedule();
> +			io_schedule();
>  			if (signal_pending(tsk)) {
>  				ret = -EINTR;
>  				break;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZAVIfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZAVIfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbZAVIfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:35:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:45756 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750788AbZAVIfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:35:11 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19V52l+gLRVqymurvgnVmoAWumX9QQNZXNBYv8Sm+
	Wq1AVUAuJ2USvT
Date: Thu, 22 Jan 2009 09:35:06 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Pavel Machek <pavel@suse.cz>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       npiggin@yahoo.com.au, xfs@oss.sgi.com
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122083506.GA5870@alice>
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed> <200901211503.07308.nickpiggin@yahoo.com.au> <20090122043747.GU10158@disturbed> <20090122061158.GA31104@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090122061158.GA31104@infradead.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 09:34:40 up 33 min,  8 users,  load average: 2.64, 2.19, 1.79
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> >  xfs_buf_t *
> >  xlog_get_bp(
> >  	xlog_t		*log,
> > -	int		num_bblks)
> > +	int		nbblks)
> 
> Any reason for reanming this variable?  That causes quite a bit of
> churn.
> 
> >  {
> > -	ASSERT(num_bblks > 0);
> > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> 
> And doesn't prevent this line from needing a linebreak to stay under 80
> characters :)
> 
> Except for these nitpicks it looks fine to me.

Just want to report that it fixes the issue for me. Thanks,
i will continue xfs testing.

Greetings, Eric

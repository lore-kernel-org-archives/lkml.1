Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbXFAFmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbXFAFmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 01:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXFAFmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 01:42:31 -0400
Received: from brick.kernel.dk ([80.160.20.94]:24069 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbXFAFma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 01:42:30 -0400
Date: Fri, 1 Jun 2007 07:41:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070601054120.GI32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465F9BEF.20504@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, H. Peter Anvin wrote:
> Jens Axboe wrote:
> >>   
> >>> -	retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
> >>> +	fl = 0;
> >>> +	if (in_file->f_flags & O_NONBLOCK)
> >>> +		fl = SPLICE_F_NONBLOCK;
> >>> +
> >>> +	retval = do_splice_direct(in_file, ppos, out_file, count, fl);
> >> I like this, but are you sure it wont break user land ?
> >>
> >> Some applications might react badly if sendfile() returns EAGAIN ?
> > 
> > Yeah, I didn't actually intend for that to sneak in. I'd think that
> > userspace should handle it if they opened the file O_NONBLOCK (or used
> > fcntl()), but it's a change in behaviour none the less and probably not
> > a good idea.
> > 
> 
> I would personally argue that sendfile() blocking on an O_NONBLOCK
> desriptor, as opposed to returning EAGAIN, is a bug, and a fairly
> serious such.

I agree, but it's still a change in behaviour. Even if we consider the
app buggy (it is), can we potentially break it?

-- 
Jens Axboe


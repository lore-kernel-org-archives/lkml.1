Return-Path: <linux-kernel-owner+w=401wt.eu-S1030734AbXDJOh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030734AbXDJOh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030746AbXDJOh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:37:58 -0400
Received: from pat.uio.no ([129.240.10.15]:34835 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030734AbXDJOh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:37:57 -0400
Subject: Re: If not readdir() then what?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Theodore Tso <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
In-Reply-To: <20070410135641.GG13650@thunk.org>
References: <20070407233037.GA16508@infradead.org>
	 <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
	 <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org>
	 <1176121897.6210.8.camel@heimdal.trondhjem.org>
	 <20070409131918.GC18580@thunk.org>
	 <1176127395.6210.34.camel@heimdal.trondhjem.org>
	 <20070410135641.GG13650@thunk.org>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 10:37:16 -0400
Message-Id: <1176215836.14442.37.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.097)
X-UiO-Scanned: B7B4BA71B3A254778804CC403AE87CEA23003A33
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1228 total 965384 max/h 7466 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 09:56 -0400, Theodore Tso wrote:


> That might work.  But if in the long term we want to separate out what
> we can send back via telldir/seekdir, and some future new Posix
> interface, I wonder if we might be better off defining a formal
> interface which can be used by NFSv2 and NFSv3/v4 that isn't
> necessarily tied to f_pos.

Note: POSIX does not mandate telldir/seekdir. The latter are only
mandated by the XSI extensions (that are part of the Single Unix spec).

Also note that SuSv3 states

        One of the perceived problems of implementation is that
        returning to a given point in a directory is quite difficult to
        describe formally, in spite of its intuitive appeal, when
        systems that use B-trees, hashing functions, or other similar
        mechanisms to order their directories are considered. The
        definition of seekdir() and telldir() does not specify whether,
        when using these interfaces, a given directory entry will be
        seen at all, or more than once.

So whereas collisions are not supported, it does appear that the SuSv3
does not mandate that you should be able to replay the exact same
stream.

NFS, OTOH, simply could not work without that requirement, since there
exists no file pointer to tell you where you are in a stream beyond
whatever the server manages to encode inside the opaque cookie+verifier.

> But the fact of the matter is that if NFS protocols demands that a
> per-directory entry cookie can be uniquely and permanently (including
> across server reboots) identified with a small integer number, it's
> dreaming.  Filesystem authors will cheat one way or another, because
> there's nothing else for them to do.  

Few people in the NFS community would disagree that the design of
READDIR sucks (personally, I consider it to be one of the biggest
scalability issues we have).
The problem is that it is extremely hard to come up with an alternative
that doesn't impose new conditions on what filesystems you can support.

Cheers
  Trond


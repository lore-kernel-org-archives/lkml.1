Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbXDIRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbXDIRBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXDIRBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:01:19 -0400
Received: from pat.uio.no ([129.240.10.15]:52756 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbXDIRBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:01:18 -0400
Subject: Re: If not readdir() then what?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
In-Reply-To: <Pine.LNX.4.61.0704091829240.21426@yvahk01.tjqt.qr>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	 <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org>
	 <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
	 <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org>
	 <1176121897.6210.8.camel@heimdal.trondhjem.org>
	 <20070409131918.GC18580@thunk.org>
	 <1176127395.6210.34.camel@heimdal.trondhjem.org>
	 <Pine.LNX.4.61.0704091829240.21426@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 13:00:51 -0400
Message-Id: <1176138051.6210.48.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.022)
X-UiO-Scanned: AE233D0536B602C65704487F76612E9BDB1BA66F
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 14 total 940130 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 18:34 +0200, Jan Engelhardt wrote:
> On Apr 9 2007 10:03, Trond Myklebust wrote:
> 
> >In practice, though, this sort of behaviour has to be managed carefully
> >by the server. Forcing a client to re-read the entire contents of the
> >directory doesn't really scale too well...
> 
> What does the spec (readdir, and NFS READDIR) say about duplicate entries,
> and what's done in practice?
> Actually, I'd be more concerned about code that does
> 
> while(d = readdir(...))
>     append_a_line_to(d);
> 
> (which would be not-so-good on duplicate entries), rather than
> bad scaling.

>From SuSv3:

        If a file is removed from or added to the directory after the
        most recent call to opendir() or rewinddir(), whether a
        subsequent call to readdir() returns an entry for that file is
        unspecified.

For NFS, the results in the above case would be governed by the caching
rules: the client is not strictly required to revalidate the cache
except on opendir(). However if the client itself is the one changing
the directory, it will in practice cause the cache to be invalidated,
and the directory contents to be read in again from scratch.

Cheers
  Trond


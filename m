Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbXDJV7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbXDJV7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXDJV7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:59:44 -0400
Received: from pat.uio.no ([129.240.10.15]:33750 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbXDJV7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:59:42 -0400
Subject: Re: If not readdir() then what?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Neil Brown <neilb@suse.de>
Cc: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <17948.916.464492.881283@notabene.brown>
References: <20070407233037.GA16508@infradead.org>
	 <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
	 <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org>
	 <1176121897.6210.8.camel@heimdal.trondhjem.org>
	 <20070409131918.GC18580@thunk.org>
	 <1176127395.6210.34.camel@heimdal.trondhjem.org>
	 <20070410135641.GG13650@thunk.org>
	 <1176215836.14442.37.camel@heimdal.trondhjem.org>
	 <17947.64947.649081.411561@notabene.brown>
	 <1176239914.309.54.camel@heimdal.trondhjem.org>
	 <17948.916.464492.881283@notabene.brown>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 17:59:24 -0400
Message-Id: <1176242364.309.69.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.3, required=12.0, autolearn=disabled, AWL=-0.300)
X-UiO-Scanned: 419EE0F7EE2F59DB394EA64218A290E3C5C0A98F
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -2 maxlevel 200 minaction 2 bait 0 mail/h: 694 total 972734 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 07:37 +1000, Neil Brown wrote:
> On Tuesday April 10, trond.myklebust@fys.uio.no wrote:
> > On Wed, 2007-04-11 at 07:12 +1000, Neil Brown wrote:
> > > 
> > > Is there something that makes that interface problematic?
> > 
> > File deletions...
> 
> How are they a problem ?
> 
> There are only two ways to organise a directory.
> 1/ Unsorted linear list of entries in which no repacking is ever done.
> 2/ Some data structure using an ordered search key that is based on
>   the filename (e.g. a B-tree with a search key that is a hash of the
>   filename). 
> 
> In the first case, you just use a fixed opaque cookie for location in
> a directory.
> In the second you use the filename.  If the file has been deleted,
> that shouldn't stop you finding the place where it would have been in
> the overall sort order.

I beg to differ. RAMFS is an instance of a filesystem which uses an
unsorted linear list of entries which is automatically repacked when you
delete a file.

You may also have filesystems which are only partially sorted. The
dcache is for instance organised as a hashtable with multiple entries
per bucket...

Cheers
  Trond


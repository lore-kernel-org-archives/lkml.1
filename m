Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbXDJVhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbXDJVhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXDJVhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:37:33 -0400
Received: from mail.suse.de ([195.135.220.2]:44735 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbXDJVha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:37:30 -0400
From: Neil Brown <neilb@suse.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Date: Wed, 11 Apr 2007 07:37:24 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17948.916.464492.881283@notabene.brown>
Cc: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from Trond Myklebust on Tuesday April 10
References: <20070407233037.GA16508@infradead.org>
	<46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<20070408191955.GD29180@thunk.org>
	<46194260.3050900@zytor.com>
	<20070409014426.GA18580@thunk.org>
	<20070409110927.GA23240@lazybastard.org>
	<1176121897.6210.8.camel@heimdal.trondhjem.org>
	<20070409131918.GC18580@thunk.org>
	<1176127395.6210.34.camel@heimdal.trondhjem.org>
	<20070410135641.GG13650@thunk.org>
	<1176215836.14442.37.camel@heimdal.trondhjem.org>
	<17947.64947.649081.411561@notabene.brown>
	<1176239914.309.54.camel@heimdal.trondhjem.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday April 10, trond.myklebust@fys.uio.no wrote:
> On Wed, 2007-04-11 at 07:12 +1000, Neil Brown wrote:
> > 
> > Is there something that makes that interface problematic?
> 
> File deletions...

How are they a problem ?

There are only two ways to organise a directory.
1/ Unsorted linear list of entries in which no repacking is ever done.
2/ Some data structure using an ordered search key that is based on
  the filename (e.g. a B-tree with a search key that is a hash of the
  filename). 

In the first case, you just use a fixed opaque cookie for location in
a directory.
In the second you use the filename.  If the file has been deleted,
that shouldn't stop you finding the place where it would have been in
the overall sort order.

NeilBrown

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbXIJDqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbXIJDqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 23:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbXIJDqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 23:46:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60018 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbXIJDqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 23:46:46 -0400
Date: Mon, 10 Sep 2007 09:16:24 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC] Union Mount: Readdir approaches
Message-ID: <20070910034624.GA6415@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070907054618.GD1692@in.ibm.com> <E1ITYJK-0000xP-8h@jroun> <20070907075855.GG1692@in.ibm.com> <20070907173941.GB20360@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907173941.GB20360@filer.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 01:39:41PM -0400, Josef 'Jeff' Sipek wrote:
> On Fri, Sep 07, 2007 at 01:28:55PM +0530, Bharata B Rao wrote:
> > On Fri, Sep 07, 2007 at 04:31:26PM +0900, hooanon05@yahoo.co.jp wrote:
> > > 
> > > When the first readdir is issued:
> > > - call vfs_readdir for every underlying opened dir (file) object.
> > > - store every entry to either the hash table for the result or the
> > >   whiteout, when the same-named entry didn't exist in the tables.
> > > - to improvement the performance, the allocated memory for the hash
> > >   tables are managed in a pointer array. and the elements are
> > >   concatinated logically by the pointer.
> > > - the pointer for the result-table, the version, and the currect jiffies
> > >   are set to vdir, which is a cache in an inode.
> > > - all cache are copied to a member in a file object.
> > > - the index of the cache memory block and the offset in an array is
> > >   handled as the seek position.
> > 
> > Ok, interesting approach. So you define the seek behaviour on your
> > directory cache rather than allowing the underlying filesystems to
> > interpret the seek. I guess we can do something similar with Union
> > Mounts also.
> 
> Unless I missunderstood something, Unionfs uses the same approach. Even

But in the version of unionfs present in -mm, lseek on directories is
still limited in functionality as it allows seeking to only the
beginning and to the current position.

> Unionfs's ODF branch does the same thing. The major difference is that we
> keep the cache in a file on a disk.

And as Erez explained, it is ODF which is allowing you to have a
complete lseek behaviour.

Regards,
Bharata.

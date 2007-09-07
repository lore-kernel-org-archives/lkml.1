Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbXIGRk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbXIGRk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 13:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965415AbXIGRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 13:40:13 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51650 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbXIGRkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 13:40:11 -0400
Date: Fri, 7 Sep 2007 13:39:41 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC] Union Mount: Readdir approaches
Message-ID: <20070907173941.GB20360@filer.fsl.cs.sunysb.edu>
References: <20070907054618.GD1692@in.ibm.com> <E1ITYJK-0000xP-8h@jroun> <20070907075855.GG1692@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907075855.GG1692@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 01:28:55PM +0530, Bharata B Rao wrote:
> On Fri, Sep 07, 2007 at 04:31:26PM +0900, hooanon05@yahoo.co.jp wrote:
> > 
> > When the first readdir is issued:
> > - call vfs_readdir for every underlying opened dir (file) object.
> > - store every entry to either the hash table for the result or the
> >   whiteout, when the same-named entry didn't exist in the tables.
> > - to improvement the performance, the allocated memory for the hash
> >   tables are managed in a pointer array. and the elements are
> >   concatinated logically by the pointer.
> > - the pointer for the result-table, the version, and the currect jiffies
> >   are set to vdir, which is a cache in an inode.
> > - all cache are copied to a member in a file object.
> > - the index of the cache memory block and the offset in an array is
> >   handled as the seek position.
> 
> Ok, interesting approach. So you define the seek behaviour on your
> directory cache rather than allowing the underlying filesystems to
> interpret the seek. I guess we can do something similar with Union
> Mounts also.

Unless I missunderstood something, Unionfs uses the same approach. Even
Unionfs's ODF branch does the same thing. The major difference is that we
keep the cache in a file on a disk.

Josef 'Jeff' Sipek. 

-- 
Evolution, n.:
  A hypothetical process whereby infinitely improbable events occur with
  alarming frequency, order arises from chaos, and no one is given credit.

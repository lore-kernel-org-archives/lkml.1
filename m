Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXDWUxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXDWUxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 16:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbXDWUxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 16:53:37 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:40285 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXDWUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 16:53:35 -0400
Date: Mon, 23 Apr 2007 14:53:33 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@linsyssoft.com>
Cc: Karuna sagar K <karunasagark@gmail.com>, Amit Gud <gud@ksu.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ChunkFS - measuring cross-chunk references
Message-ID: <20070423205333.GZ5967@schatzie.adilger.int>
Mail-Followup-To: Kalpak Shah <kalpak@linsyssoft.com>,
	Karuna sagar K <karunasagark@gmail.com>, Amit Gud <gud@ksu.edu>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com> <462B8D0C.7020509@ksu.edu> <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com> <1177320876.23226.7.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177320876.23226.7.camel@garfield>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 23, 2007  15:04 +0530, Kalpak Shah wrote:
> On Mon, 2007-04-23 at 12:49 +0530, Karuna sagar K wrote:
> > The tool estimates the cross-chunk references from an extt2/3 file
> > system. It considers a block group as one chunk and calcuates how many
> > block groups does a file span across. So, the block group size gives
> > the estimate of chunk size.
> > 
> > The file systems were aged for about 3-4 months on a developers laptop.
> 
> With a blocksize of 4KB, a block group would be 128 MB. In the original
> Chunkfs paper, Valh had mentioned 1GB chunks and I believe it will be
> possible to use 2GB, 4GB or 8GB chunks in the future. As the chunk size
> increases the number of cross-chunk references will reduce and hence it
> might be a good idea to present these statistics considering different
> chunk sizes starting from 512MB upto 2GB.

Also, given that cross-chunk references will be more expensive to fix, I
can imagine the allocation policy for chunkfs will try to avoid this if
possible, further reducing the number of cross-chunk inodes.  I guess it
should be more clear whether the cross-chunk references are due to inode
block references, or because of e.g. directories referencing inodes in
another chunk.

Also, is it considered a cross-chunk reference if a directory entry is
referencing an inode in another group?  Should there be a continuation
inode in the local group, or is the directory entry itself enough?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


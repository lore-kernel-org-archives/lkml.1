Return-Path: <linux-kernel-owner+w=401wt.eu-S1030811AbXDYKQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811AbXDYKQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030829AbXDYKQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:16:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55628 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030811AbXDYKQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:16:20 -0400
Date: Wed, 25 Apr 2007 15:53:42 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: "Karuna sagar K" <karunasagark@gmail.com>
Cc: "Theodore Tso" <tytso@mit.edu>, "Kalpak Shah" <kalpak@linsyssoft.com>,
       "Amit Gud" <gud@ksu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ChunkFS - measuring cross-chunk references
Message-ID: <20070425102342.GA26179@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com> <462B8D0C.7020509@ksu.edu> <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com> <1177320876.23226.7.camel@garfield> <20070423205333.GZ5967@schatzie.adilger.int> <20070424001306.GB1663@thunk.org> <2e4afe1e0704241717l6e6ec72by898727b5973c221@mail.gmail.com> <2e4afe1e0704241720q3eb54e24gcd10b2026759333@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e4afe1e0704241720q3eb54e24gcd10b2026759333@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 05:50:55AM +0530, Karuna sagar K wrote:
> On 4/24/07, Theodore Tso <tytso@mit.edu> wrote:
> >On Mon, Apr 23, 2007 at 02:53:33PM -0600, Andreas Dilger wrote:
> .........
> >It would also be good to distinguish between directories referencing
> >files in another chunk, and directories referencing subdirectories in
> >another chunk (which would be simpler to handle, given the topological
> >restrictions on directories, as compared to files and hard links).
> >
> 
> Modified the tool to distinguish between
> 1. cross references between directories and files
> 2. cross references between directories and sub directories
> 3. cross references within a file (due to huge file size)

One more set of numbers to calculate would be an estimate of cross-references
across chunks of block groups -- 1 (=128MB), 2 (=256MB), 4 (=512MB), 8(=1GB)
as suggested by Kalpak.

Once we have that, it would be nice if we can get data on results with
the tool from other people, especially with larger filesystem sizes.

Regards
Suparna

> 
> Below is the result from / partition of ext3 file system:
> 
> Number of files = 221794
> Number of directories = 24457
> Total size = 8193116 KB
> Total data stored = 7187392 KB
> Size of block groups = 131072 KB
> Number of inodes per block group = 16288
> No. of cross references between directories and sub-directories = 7791
> No. of cross references between directories and file = 657
> Total no. of cross references = 62018 (dir ref = 8448, file ref = 53570)
> 
> Thanks for the suggestions.
> 
> >There may also be special things we will need to do to handle
> >scenarios such as BackupPC, where if it looks like a directory
> >contains a huge number of hard links to a particular chunk, we'll need
> >to make sure that directory is either created in the right chunk
> >(possibly with hints from the application) or migrated to the right
> >chunk (but this might cause the inode number of the directory to
> >change --- maybe we allow this as long as the directory has never been
> >stat'ed, so that the inode number has never been observed).
> >
> >The other thing which we should consider is that chunkfs really
> >requires a 64-bit inode number space, which means either we only allow
> >it on 64-bit systems, or we need to consider a migration so that even
> >on 32-bit platforms, stat() functions like stat64(), insofar that it
> >uses a stat structure which returns a 64-bit ino_t.
> >
> >                                               - Ted
> >
> 
> 
> Thanks,
> Karuna



-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India


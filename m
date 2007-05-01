Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbXEAR1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbXEAR1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbXEAR1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:27:06 -0400
Received: from mga06.intel.com ([134.134.136.21]:4103 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754951AbXEAR1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:27:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,475,1170662400"; 
   d="scan'208";a="237366965"
Date: Tue, 1 May 2007 10:26:46 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070501172643.GB29848@nifty>
References: <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz> <17967.15531.450627.972572@gargle.gargle.HOWL> <20070425224710.GB16129@nifty> <20070426141455.GA6155@c2.user-mode-linux.org> <4630CAEC.2050909@ksu.edu> <20070426160504.GA7970@c2.user-mode-linux.org> <20070427045824.GB20286@nifty> <20070427150647.GA6019@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427150647.GA6019@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 11:06:47AM -0400, Jeff Dike wrote:
> On Thu, Apr 26, 2007 at 09:58:25PM -0700, Valerie Henson wrote:
> > Here's an example, spelled out:
> > 
> > Allocate file 1 in chunk A.
> > Grow file 1.
> > Chunk A fills up.
> > Allocate continuation inode for file 1 in chunk B.
> > Chunk A gets some free space.
> > Chunk B fills up.
> > Pick chunk A for allocating next block of file 1.
> > Try to look up a continuation inode for file 1 in chunk A.
> > Continuation inode for file 1 found in chunk A!
> > Attach newly allocated block to existing inode for file 1 in chunk A.
> 
> So far, so good (and the slides are helpful, tx!).  What happens when
> file 1 keeps growing and chunk A fills up (and chunk B is still full)?
> Can the same continuation inode also point at chunk C, where the file
> is going to grow to?

You allocate a new continuation inode in chunk C.  The rule is that
only inodes inside a chunk can point to blocks inside the chunk, so
you need an inode in C if you want to allocate blocks from C.

-VAL

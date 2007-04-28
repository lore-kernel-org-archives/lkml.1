Return-Path: <linux-kernel-owner+w=401wt.eu-S1161221AbXD1GuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161221AbXD1GuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161206AbXD1GuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:50:21 -0400
Received: from mga06.intel.com ([134.134.136.21]:35088 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161199AbXD1GuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:50:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,464,1170662400"; 
   d="scan'208";a="235494593"
Date: Fri, 27 Apr 2007 23:50:06 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: J??rn Engel <joern@lazybastard.org>
Cc: Jan Kara <jack@suse.cz>, David Chinner <dgc@sgi.com>,
       Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070428065006.GA21945@nifty>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425230344.GC16129@nifty> <20070426084738.GA21666@atrey.karlin.mff.cuni.cz> <20070427050742.GC20286@nifty> <20070427105334.GB22949@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427105334.GB22949@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 12:53:34PM +0200, J??rn Engel wrote:
> 
> All this would get easier if continuation inodes were known to be rare.
> You can ditch the doubly-linked list in favor of a pointer to the main
> inode then - traversing the list again is cheap, after all.  And you can
> just try to read the same block once for every continuation inode.
> 
> If those lists can get long and you need a mapping from offset to
> continuation inode on the medium, you are basically fscked.  Storing the
> mapping requires space.  You need the mapping only when space (in some
> chunk) gets tight and you allocate continuation inodes.  So either you
> don't need the mapping or you don't have a good place to put it.

Any mapping structure will have to be pre-allocated.

> Having a mapping in memory is also questionable.  Either you scan the
> whole file on first access and spend a long time for large files.  Or
> you create the mapping on the fly.  In that case the page cache will
> already give you a 90% solution for free.

So in my secret heart of hearts, I do indeed hope that cnodes are rare
enough that we don't actually have to do anything smart to make them
go fast.  Either having no fast lookup structure or creating it in
memory as needed would be the nicest solution.  However, since I can't
guarantee this will be the case, it's nice to have some idea of what
we'll do if this does become important.

> You should spend a lot of effort trying to minimize cnodes. ;)

Yep.  It's much better to optimize away most cnodes instead of trying
to make the go fast.

-VAL

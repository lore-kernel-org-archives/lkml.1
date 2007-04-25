Return-Path: <linux-kernel-owner+w=401wt.eu-S1423394AbXDYWnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423394AbXDYWnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423392AbXDYWnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:43:53 -0400
Received: from mga07.intel.com ([143.182.124.22]:19242 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423390AbXDYWnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:43:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,452,1170662400"; 
   d="scan'208";a="219411207"
Date: Wed, 25 Apr 2007 15:43:50 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: Nikita Danilov <nikita@clusterfs.com>
Cc: David Lang <david.lang@digitalinsight.com>, Amit Gud <gud@cis.ksu.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com,
       gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070425224349.GA16129@nifty>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17966.23512.363955.141489@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 11:34:48PM +0400, Nikita Danilov wrote:
> 
> Maybe I failed to describe the problem presicely.
> 
> Suppose that all chunks have been checked. After that, for every inode
> I0 having continuations I1, I2, ... In, one has to check that every
> logical block is presented in at most one of these inodes. For this one
> has to read I0, with all its indirect (double-indirect, triple-indirect)
> blocks, then read I1 with all its indirect blocks, etc. And to repeat
> this for every inode with continuations.
> 
> In the worst case (every inode has a continuation in every chunk) this
> obviously is as bad as un-chunked fsck. But even in the average case,
> total amount of io necessary for this operation is proportional to the
> _total_ file system size, rather than to the chunk size.

Fsck in chunkfs is still going to have an element that is proportional
to the file system size for certain cases.  However, that element will
be a great deal smaller than in a regular file system, except in the
most pathological cases.  If those pathological cases happen often,
then it's back to the drawing board.  My hunch is that they won't be
common.

-VAL

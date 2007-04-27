Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbXD0FHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbXD0FHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbXD0FHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:07:45 -0400
Received: from mga06.intel.com ([134.134.136.21]:10983 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755325AbXD0FHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:07:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,454,1170662400"; 
   d="scan'208";a="234876513"
Date: Thu, 26 Apr 2007 22:07:43 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: David Chinner <dgc@sgi.com>, Amit Gud <gud@ksu.edu>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070427050742.GC20286@nifty>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425230344.GC16129@nifty> <20070426084738.GA21666@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426084738.GA21666@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 10:47:38AM +0200, Jan Kara wrote:
>   Do I get it right that you just have in each cnode a pointer to the
> previous & next cnode? But then if two consecutive cnodes get corrupted,
> you have no way to connect the chain, do you? If each cnode contained
> some unique identifier of the file and a number identifying position of
> cnode,  then there would be at least some way (through expensive) to
> link them together correctly...

You're right, it's easy to add a little more redundancy that would
make it possible to recover from two consecutive nodes being
corrupted.  Keeping a parent inode id in each continuation inode is
definitely a smart thing to do.

Some minor side notes: Continuation inodes aren't really in any
defined order - if you look at Jeff's ping-pong chunk allocation
example, you'll see that the data in each continuation inode won't be
in linearly increasing order.  Also, while the current implementation
is a simple doubly-linked list, this may not be the best solution
long-term.  What's important is that each continuation inode have a
back pointer to the parent and that there is some structure for
quickly looking up the continuation inode for a given file offset.
Suggestions for data structures that work well in this situation are
welcome. :)

-VAL

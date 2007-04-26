Return-Path: <linux-kernel-owner+w=401wt.eu-S1030619AbXDZOWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030619AbXDZOWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030628AbXDZOWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:22:36 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48289 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030619AbXDZOWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:22:35 -0400
Date: Thu, 26 Apr 2007 10:14:55 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>, Amit Gud <gud@cis.ksu.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com,
       gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070426141455.GA6155@c2.user-mode-linux.org>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz> <17967.15531.450627.972572@gargle.gargle.HOWL> <20070425224710.GB16129@nifty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425224710.GB16129@nifty>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 03:47:10PM -0700, Valerie Henson wrote:
> Actually, there is an upper limit on the number of continuation
> inodes.  Each file can have a maximum of one continuation inode per
> chunk. (This is why we need to support sparse files.)

How about this case:

	Growing file starts in chunk A.
	Overflows into chunk B.
	Delete file in chunk A.
	Growing file overflows chunk B and spots new free space in
chunk A (and nothing anywhere else)
	Overflows into chunk A
	Delete file in chunk B.
	Overflow into chunk B again.

Maybe this is not realistic, but in the absence of a mechanism to pull
data back from an overflow chunk, it seems at least a theoretical
possibility that there could be > 1 continuation inodes per file per
chunk.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

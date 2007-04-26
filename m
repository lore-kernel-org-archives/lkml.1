Return-Path: <linux-kernel-owner+w=401wt.eu-S1031318AbXDZQLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031318AbXDZQLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031317AbXDZQLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:11:38 -0400
Received: from [198.99.130.12] ([198.99.130.12]:48788 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031318AbXDZQLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:11:37 -0400
Date: Thu, 26 Apr 2007 12:05:04 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Amit Gud <gud@ksu.edu>
Cc: Valerie Henson <val_henson@linux.intel.com>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070426160504.GA7970@c2.user-mode-linux.org>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz> <17967.15531.450627.972572@gargle.gargle.HOWL> <20070425224710.GB16129@nifty> <20070426141455.GA6155@c2.user-mode-linux.org> <4630CAEC.2050909@ksu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630CAEC.2050909@ksu.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 10:53:16AM -0500, Amit Gud wrote:
> Jeff Dike wrote:
> >How about this case:
> >
> >	Growing file starts in chunk A.
> >	Overflows into chunk B.
> >	Delete file in chunk A.
> >	Growing file overflows chunk B and spots new free space in
> >chunk A (and nothing anywhere else)
> >	Overflows into chunk A
> >	Delete file in chunk B.
> >	Overflow into chunk B again.
> >
> >Maybe this is not realistic, but in the absence of a mechanism to pull
> >data back from an overflow chunk, it seems at least a theoretical
> >possibility that there could be > 1 continuation inodes per file per
> >chunk.
> >
> 
> Preventive measures are taken to limit only one continuation inode per 
> file per chunk. This can be done easily in the chunk allocation 
> algorithm for disk space. Although I'm not quite sure what you mean by 
> "Delete file in chunk A". If you are referring to same file thats 
> growing, then deletion is not possible, because individual parts of any 
> file in any chunk cannot be deleted.

No, I'm referring to a different file.  The scenario is that you have
a growing file in a nearly full disk with files being deleted (and
thus space being freed) such that allocations for the growing file
bounce back and forth between chunks.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

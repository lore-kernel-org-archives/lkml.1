Return-Path: <linux-kernel-owner+w=401wt.eu-S1031296AbXDZPys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031296AbXDZPys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031293AbXDZPys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:54:48 -0400
Received: from smtp1.cc.ksu.edu ([129.130.7.15]:43336 "EHLO smtp1.cc.ksu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031294AbXDZPyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:54:45 -0400
Message-ID: <4630CAEC.2050909@ksu.edu>
Date: Thu, 26 Apr 2007 10:53:16 -0500
From: Amit Gud <gud@ksu.edu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Valerie Henson <val_henson@linux.intel.com>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz> <17967.15531.450627.972572@gargle.gargle.HOWL> <20070425224710.GB16129@nifty> <20070426141455.GA6155@c2.user-mode-linux.org>
In-Reply-To: <20070426141455.GA6155@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> How about this case:
> 
> 	Growing file starts in chunk A.
> 	Overflows into chunk B.
> 	Delete file in chunk A.
> 	Growing file overflows chunk B and spots new free space in
> chunk A (and nothing anywhere else)
> 	Overflows into chunk A
> 	Delete file in chunk B.
> 	Overflow into chunk B again.
> 
> Maybe this is not realistic, but in the absence of a mechanism to pull
> data back from an overflow chunk, it seems at least a theoretical
> possibility that there could be > 1 continuation inodes per file per
> chunk.
> 

Preventive measures are taken to limit only one continuation inode per 
file per chunk. This can be done easily in the chunk allocation 
algorithm for disk space. Although I'm not quite sure what you mean by 
"Delete file in chunk A". If you are referring to same file thats 
growing, then deletion is not possible, because individual parts of any 
file in any chunk cannot be deleted.


AG
-- 
May the source be with you.
http://www.cis.ksu.edu/~gud


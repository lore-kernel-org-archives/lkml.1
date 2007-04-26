Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXDZQqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXDZQqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXDZQqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:46:24 -0400
Received: from smtp2.cc.ksu.edu ([129.130.7.16]:51357 "EHLO smtp2.cc.ksu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbXDZQqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:46:22 -0400
Message-ID: <4630D703.6060602@ksu.edu>
Date: Thu, 26 Apr 2007 11:44:51 -0500
From: Amit Gud <gud@ksu.edu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Dike <jdike@addtoit.com>, Valerie Henson <val_henson@linux.intel.com>,
       Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>	<17965.60841.900376.524639@gargle.gargle.HOWL>	<Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz>	<17966.23512.363955.141489@gargle.gargle.HOWL>	<Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz>	<17967.15531.450627.972572@gargle.gargle.HOWL>	<20070425224710.GB16129@nifty>	<20070426141455.GA6155@c2.user-mode-linux.org>	<4630CAEC.2050909@ksu.edu> <20070426171134.5ce3bb6a@the-village.bc.nu>
In-Reply-To: <20070426171134.5ce3bb6a@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Preventive measures are taken to limit only one continuation inode per 
>> file per chunk. This can be done easily in the chunk allocation 
>> algorithm for disk space. Although I'm not quite sure what you mean by 
> 
> How are you handling the allocation in this situation, are you assuming
> that a chunk is "out of bounds" because part of a file already lives on
> it or simply keeping a single inode per chunk which has multiple sparse
> pieces of the file on it ?
> 
> ie if I write 0-8MB to chunk A and then 8-16 to chunk B can I write
> 16-24MB to chunk A producing a single inode of 0-8 16-24, or does it have
> to find another chunk to use ?

Hello Alan,

You re-use the same inode with multiple sparse pieces.

This way you avoid hopping around continuation inodes and coming back to 
same chunk with which you started but this time on a different 
continuation inode. This may not be I/O intensive for successive 
traversals if the continuation inodes are pinned in the memory, but it 
certainly is a waste of resource - inodes. Not allowing this would make 
worst case of every file having a continuation inode in every chunk, 
even worse; may be like only single file exist in the file system and 
rest all inodes in all chunks (including file's own chunk) are 
continuation inodes.


AG
-- 
May the source be with you.
http://www.cis.ksu.edu/~gud


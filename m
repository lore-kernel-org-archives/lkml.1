Return-Path: <linux-kernel-owner+w=401wt.eu-S1423348AbXDYRxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423348AbXDYRxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423351AbXDYRxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:53:50 -0400
Received: from smtp2.cc.ksu.edu ([129.130.7.16]:40972 "EHLO smtp2.cc.ksu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423350AbXDYRxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:53:49 -0400
Message-ID: <462F9559.3050403@ksu.edu>
Date: Wed, 25 Apr 2007 12:52:25 -0500
From: Amit Gud <gud@ksu.edu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       val_henson@linux.intel.com, riel@surriel.com, zab@zabbo.net,
       arjan@infradead.org, suparna@in.ibm.com, brandon@ifup.org,
       karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <462E7C47.8080604@ksu.edu> <20070425105434.GX32602149@melbourne.sgi.com> <20070425113834.GT5967@schatzie.adilger.int>
In-Reply-To: <20070425113834.GT5967@schatzie.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
>> How do you recover if fsfuzzer takes out a cnode in the chain? The
>> chunk is marked clean, but clearly corrupted and needs fixing and
>> you don't know what it was pointing at.  Hence you have a pointer to
>> a trashed cnode *somewhere* that you need to find and fix, and a
>> bunch of orphaned cnodes that nobody points to *somewhere else* in
>> the filesystem that you have to find. That's a full scan fsck case,
>> isn't?
> 
> Presumably, the cnodes in the other chunks contain forward and back
> references.  Those need to contain at minimum inode + generation + chunk
> to avoid problem of pointing to a _different_ inode after such corruption
> caused the old inode to be deleted and a new one allocated in its place.
> 
> If the cnode in each chunk is more than just a singly-linked list, the
> file as a whole could survive multiple chunk corruptions, though there
> would now be holes in the file.
> 
>> It seems that any sort of damage to the underlying storage (e.g.
>> media error, I/O error or user brain explosion) results in the need
>> to do a full fsck and hence chunkfs gives you no benefit in this
>> case.
> 

Yes, what originated from discussions on #linuxfs is that redundancy is 
required for cnodes, in order to avoid checking the entire file system 
in search of a dangling cnode reference or for "parent" of a cnode.

If corruption, due to any reason, occurs in any other part of the file 
system, it would be localized for that chunk. Even if entire fsck is 
needed, chances of which are rare, full fsck of chunked file system is 
no worse than fsck of non-chunked file system. Passes 3, 4, and 5 of 
fsck take only 10-15% of total fsck run time and almost no-I/O Pass 6 
for chunkfs wouldn't add whole lot.


AG
-- 
May the source be with you.
http://www.cis.ksu.edu/~gud


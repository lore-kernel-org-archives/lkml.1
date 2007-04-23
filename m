Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXDWQVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXDWQVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 12:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965095AbXDWQVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 12:21:51 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47137 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbXDWQVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 12:21:49 -0400
Date: Mon, 23 Apr 2007 21:58:49 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Amit Gud <gud@cis.ksu.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       val_henson@linux.intel.com, riel@surriel.com, zab@zabbo.net,
       arjan@infradead.org, brandon@ifup.org, karunasagark@gmail.com,
       gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070423162849.GB14113@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 06:21:34AM -0500, Amit Gud wrote:
> 
> This is an initial implementation of ChunkFS technique, briefly discussed
> at: http://lwn.net/Articles/190222 and 
> http://cis.ksu.edu/~gud/docs/chunkfs-hotdep-val-arjan-gud-zach.pdf
> 
> This implementation is done within ext2 driver. Every chunk is an 
> independent ext2 file system. The knowledge about chunks is kept within 
> ext2 and 'continuation inodes', which are used to allow files and 
> directories span across multiple chunks, are managed within ext2.
> 
> At mount time, super blocks for all the chunks are created and linked with 
> the global super_blocks list maintained by VFS. This allows independent 
> behavior or individual chunks and also helps writebacks to happen 
> seamlessly.
> 
> Apart from this, chunkfs code in ext2 effectively only provides knowledge 
> of:
> 
> - what inode's which block number to look for, for a given file's logical 
> block number
> - in which chunk to allocate next inode / block
> - number of inodes to scan when a directory is being read
> 
> To maintain the ext2's inode number uniqueness property, 8 msb bits of 
> inode number are used to indicate the chunk number in which it resides.
> 
> As said, this is a preliminary implementation and lots of changes are 
> expected before this code is even sanely usable. Some known issues and 
> obvious optimizations are listed in the TODO file in the chunkfs patch.
> 
> http://cis.ksu.edu/~gud/patches/chunkfs-v0.0.8.patch
> - one big patch
> - applies to 2.6.18


Could you send this out as a patch to ext2 codebase, so we can just look
at the changes for chunkfs ? That might also make it small enough
to inline your patch in email for review. 

What kind of results are you planning to gather to evaluate/optimize this ?

Regards
Suparna

> 
> Attached - ext2-chunkfs-diff.patch.gz
> - since the code is a spin-off of ext2, this patch explains better what
>   has changed from the ext2.
> 
> git://cislinux.cis.ksu.edu/chunkfs-tools
> - mkfs, and fsck for chunkfs.
> 
> http://cis.ksu.edu/~gud/patches/config-chunkfs-2.6.18-uml
> - config file used; tested mostly on UML with loopback file systems.
> 
> NOTE: No xattrs and xips yet, CONFIG_EXT2_FS_XATTR and CONFIG_EXT2_FS_XIP 
> should be "no" for clean compile.
> 
> 
> Please comment, suggest, criticize. Patches most welcome.
> 
> 
> Best,
> AG
> --
> May the source be with you.
> http://www.cis.ksu.edu/~gud



-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India


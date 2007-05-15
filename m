Return-Path: <linux-kernel-owner+w=401wt.eu-S1030293AbXEOGbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbXEOGbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759880AbXEOGbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:31:24 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:54997 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759653AbXEOGbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:31:23 -0400
Date: Tue, 15 May 2007 00:31:21 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 0/5][TAKE2] fallocate system call
Message-ID: <20070515063120.GI5286@schatzie.adilger.int>
Mail-Followup-To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@osdl.org, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
	cmm@us.ibm.com
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070514132926.GA30768@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514132926.GA30768@amitarora.in.ibm.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 14, 2007  18:59 +0530, Amit K. Arora wrote:
>  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> fd: The descriptor of the open file.
> 
> mode*: This specifies the behavior of the system call. Currently the
>   system call supports two modes - FA_ALLOCATE and FA_DEALLOCATE.
>   FA_ALLOCATE: Applications can use this mode to preallocate blocks to
>     a given file (specified by fd). This mode changes the file size if
>     the preallocation is done beyond the EOF. It also updates the
>     ctime/mtime in the inode of the corresponding file, marking a
>     successfull allocation.
>   FA_DEALLOCATE: This mode can be used by applications to deallocate the
>     previously preallocated blocks. This also may change the file size
>     and the ctime/mtime.
> * New modes might get added in future. One such new mode which is
>   already under discussion is FA_PREALLOCATE, which when used will
>   preallocate space but will not change the filesize and [cm]time.
>   Since the semantics of this new mode is not clear and agreed upon yet,
>   this patchset does not implement it currently.
> 
> offset: This is the offset in bytes, from where the preallocation should
>   start.
> 
> len: This is the number of bytes requested for preallocation (from
>   offset).

What is the return value?  I'd hope it is the number of bytes preallocated,
in case of interrupted preallocation for whatever reason (interrupt, out of
space, etc) like a regular write(2) call.  In this case the return type needs
to also be an loff_t to match @len.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


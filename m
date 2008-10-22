Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYJVUCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYJVUCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYJVUCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:02:04 -0400
Received: from exhub016-1.exch016.msoutlookonline.net ([207.5.72.163]:52861
	"EHLO EXHUB016-1.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbYJVUCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:02:03 -0400
Message-ID: <48FF86AC.6060802@cfl.rr.com>
Date: Wed, 22 Oct 2008 16:01:48 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Phillip Susi <psusi@cfl.rr.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Yea old defrag
References: <48FF506F.6060701@cfl.rr.com> <20081022180342.GA26257@mit.edu>
In-Reply-To: <20081022180342.GA26257@mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> The problem with the defrag code has always been that I haven't had
> time to give it proper love and attention, and it needs a *lot* of
> work before I would be willing to stand behind it as a useful and
> "safe" tool to use.  Basically, I don't want to get the hate mail from
> people who lose their data due to bugs or other potential failures
> from e2defrag.

Indeed, it rightly should be covered with warnings about it possibly 
munching your data and should only be used on fully backed up 
filesystems.  As far as I know currently though, it works properly and 
I'm willing to use what free time I have to fix any bugs that are found, 
but I need to decide where to house the source in a proper VCS instead 
of just continuing to add dpatches to the ubuntu source package.

> I have a vague memory it doesn't even work if the filesystem blocksize
> is greater than 1k, but I'm not 100% certain that is still true.

I have an active 110 gig ext3 root fs ( that is only about 8% used ) 
that I tested on with no errors ( after removing one disk from the 
mirror and using that to test with ).  It uses 4k blocks, has_journal, 
resize_inode, dir_index, filetype, sparse_super, large_file.  I think it 
won't support blocks larger than 4k, but I don't think the kernel will 
either.  I also verified the md5sums of all files on the disk after the 
defrag.

> There is also an on-line defragmetter that requires kernel support
> that some folks from NEC are working on for ext4 (which can also
> support ext3 filesystems).  My thinking is that it's more worthwhile
> to focus my attentions on helping Akira Fujita and Takashi Sato finish
> theiron-line ext4 defragmentation patches than to worry about
> e2defrag.  Of course, if you'd like to give some love and attention to
> e2defrag, that's great.  But e2defrag doesn't use the ext2fs
> libraries, and it would be a huge amount of work to make sure it
> supports things like extended attributes and other newer format
> enhancements that have been made to the ext3 filesystem.

I've been reading a lot in the last few hours about the proposed online 
defragmenter, and while it seems quite interesting, it appears to not be 
ready yet, whereas e2defrag is readily available.  It will be 
interesting to compare the two approaches.

I have been trying to identify any new features that cause problems and 
fix any that arise.  Aren't extended attributes stored in the extra 
space of large inodes?  If so, I would need to format a new fs using 
large inodes to test.  I don't think e2defrag currently supports large 
inodes, but it shouldn't be too hard to add support.  Other than being 
aware of the correct size of the inodes, I don't see anything special it 
would need to do to support extended attributes if they are just extra 
data in the inode, or can they be stored in data blocks and so it would 
need to understand the block pointers in the inode?

Are there any other ext3 features that might cause trouble?  I know 
there are plenty in ext4, but I want to make sure everything works well 
in ext3 first.

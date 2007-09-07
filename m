Return-Path: <linux-kernel-owner+w=401wt.eu-S965076AbXIGH7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076AbXIGH7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 03:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964902AbXIGH7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 03:59:15 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48736 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964939AbXIGH7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 03:59:14 -0400
Date: Fri, 7 Sep 2007 13:28:55 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC] Union Mount: Readdir approaches
Message-ID: <20070907075855.GG1692@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070907054618.GD1692@in.ibm.com> <E1ITYJK-0000xP-8h@jroun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ITYJK-0000xP-8h@jroun>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 04:31:26PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> When the first readdir is issued:
> - call vfs_readdir for every underlying opened dir (file) object.
> - store every entry to either the hash table for the result or the
>   whiteout, when the same-named entry didn't exist in the tables.
> - to improvement the performance, the allocated memory for the hash
>   tables are managed in a pointer array. and the elements are
>   concatinated logically by the pointer.
> - the pointer for the result-table, the version, and the currect jiffies
>   are set to vdir, which is a cache in an inode.
> - all cache are copied to a member in a file object.
> - the index of the cache memory block and the offset in an array is
>   handled as the seek position.

Ok, interesting approach. So you define the seek behaviour on your
directory cache rather than allowing the underlying filesystems to
interpret the seek. I guess we can do something similar with Union
Mounts also.

> If you are interested in this approach, please refer to
> http://aufs.sf.net. It is working and used by several people.

Will look at it. And thanks Junjiro for your detailed explanation of
the aufs approach.

Regards,
Bharata.

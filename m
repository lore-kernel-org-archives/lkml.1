Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZDBStY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZDBStY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbZDBStB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:49:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49645 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbZDBStA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:49:00 -0400
Message-ID: <49D50898.8020802@redhat.com>
Date: Thu, 02 Apr 2009 14:48:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of
 data	to an inode [ver #46]
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230515.28177.73948.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230515.28177.73948.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Add an address space operation to write one single page of data to an inode at
> a page-aligned location (thus permitting the implementation to be highly
> optimised).  The data source is a single page.
>   
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index b43b955..5d17070 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -817,6 +817,8 @@ const struct address_space_operations ext2_nobh_aops = {
>  	.direct_IO		= ext2_direct_IO,
>  	.writepages		= ext2_writepages,
>  	.migratepage		= buffer_migrate_page,
> +	.write_one_page		= generic_file_buffered_write_one_page,
> +	.write_one_page		= generic_file_buffered_write_one_page
Adding the same function pointer twice seems a bit excessive.

Other than that, the patch looks good :)


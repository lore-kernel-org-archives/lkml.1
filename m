Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbZDCNmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbZDCNmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbZDCNmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:42:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39196 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbZDCNmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:42:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29524.1238696291@redhat.com>
References: <29524.1238696291@redhat.com> <20090402165505.GA21859@infradead.org> <200904030100.05741.nickpiggin@yahoo.com.au> <200904030232.59355.nickpiggin@yahoo.com.au> <20090402163712.GA25177@infradead.org> <200904030347.21470.nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Fri, 03 Apr 2009 14:41:48 +0100
Message-ID: <10789.1238766108@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> +			data = kmap(page);
> +			old_fs = get_fs();
> +			set_fs(KERNEL_DS);
> +			ret = file->f_op->write(
> +				file, (const void __user *) data, PAGE_SIZE,
> +				&pos);
> +			set_fs(old_fs);
> +			kunmap(page);

Hmmm...  Now I've thought about it some more, I'm not sure this is a good
idea.  Can this run a system out of kmap() resources?  These are run by a
dynamic thread pool, where each thread in the pool can do a kmap and issue a
write, but the write may get delayed for a significant amount of time for a
number of reasons - such as block allocation, data fetching and memory
allocation.

David

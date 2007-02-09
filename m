Return-Path: <linux-kernel-owner+w=401wt.eu-S1946132AbXBIFw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946132AbXBIFw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 00:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946134AbXBIFw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 00:52:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56954 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946132AbXBIFw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 00:52:56 -0500
Date: Thu, 8 Feb 2007 21:52:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>, <suparna@in.ibm.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
Subject: Re: [PATCH] aio: fix kernel bug when page is  temporally busy
Message-Id: <20070208215237.e5a48659.akpm@linux-foundation.org>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC8048E2@mssmsx411>
References: <20070208203507.347cff98.akpm@linux-foundation.org>
	<B41635854730A14CA71C92B36EC22AAC8048E2@mssmsx411>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 08:41:41 +0300 "Ananiev, Leonid I" <leonid.i.ananiev@intel.com> wrote:

> 
> > invalidate_inode_pages2() has other callers.  I suspect with this
> change
> > we'll end up leaking EIOCBRETRY back to userspace.
> 
> EIOCBRETRY is used and caught already in do_sync_read() and
> do_sync_readv_writev().

To pick one example:

	nfs_follow_link
	->nfs_revalidate_mapping_nolock
	  ->nfs_invalidate_mapping_nolock
	    ->invalidate_inode_pages2

so that, I assume, affects open(), unlink(), etc.


> Below fixed patch against kernel 2.6.20.

The tab->spaces issue is fixed, but it's still all wordwrapped.


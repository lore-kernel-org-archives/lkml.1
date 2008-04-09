Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYDIIYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYDIIYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYDIIYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:24:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYDIIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:24:13 -0400
Date: Wed, 9 Apr 2008 04:24:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] Please pull NFS client fixes against linux-2.6.25-rc8
Message-ID: <20080409082408.GA17458@infradead.org>
References: <1207703414.21370.1.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207703414.21370.1.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_MMU
>  	.mmap		= nfs_file_mmap,
> +#else
> +	.mmap		= generic_file_mmap,
> +#endif

This is with almost 100% chance wrong.  It might get you a kernel that
compiles but none where mmap actually works.  Just disable mmap on nfs
for mmu-less systems until someone hacks up a proper mmu-less mmap
method for nfs.

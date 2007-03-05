Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbXCENS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbXCENS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933467AbXCENS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:18:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47047 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbXCENS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:18:57 -0500
Date: Mon, 5 Mar 2007 13:18:42 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070305131842.GC1312@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703032345.33137.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 11:45:32PM +0100, Arnd Bergmann wrote:
> > I'd be more happy to have the write out zeroes loop in glibc. ?And
> > glibc needs to have it anyway, for older kernels.
> 
> A generic_fallocate makes sense to me iff we can do it in the kernel
> more significantly more efficiently than in glibc, e.g. by using only
> a single page in page cache instead of one for each page to be preallocated.

We can't do that with the current page cache interfaces.  But what
might make sense is to have a block_dump_prealloc that takes a get_block
callback to do what you propose.  It still wouldn't be entirely generic,
but would allow block based filesystems to do a not entirely dumb
implementation.

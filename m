Return-Path: <linux-kernel-owner+w=401wt.eu-S1161258AbXCAXi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161258AbXCAXi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161257AbXCAXiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:38:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54737 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161132AbXCAXiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:38:24 -0500
Date: Thu, 1 Mar 2007 23:38:19 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070301233819.GB31072@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172789056.11165.42.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172789056.11165.42.camel@kleikamp.austin.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 10:44:16PM +0000, Dave Kleikamp wrote:
> Would EINVAL (or whatever) make it back to the caller of
> posix_fallocate(), or would glibc fall back to its current
> implementation?
> 
> Forgive me if I haven't put enough thought into it, but would it be
> useful to create a generic_fallocate() that writes zeroed pages for any
> non-existent pages in the range?  I don't know how glibc currently
> implements posix_fallocate(), but maybe the kernel could do it more
> efficiently, even in generic code.  Maybe we don't care, since the major
> file systems can probably do something better in their own code.

I'd be more happy to have the write out zeroes loop in glibc.  And
glibc needs to have it anyway, for older kernels.

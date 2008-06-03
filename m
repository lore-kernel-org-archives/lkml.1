Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbYFCW7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbYFCW7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYFCW7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:59:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:50925 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbYFCW7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:59:12 -0400
Date: Wed, 4 Jun 2008 07:58:31 +0900
To: paulus@samba.org
Cc: penberg@cs.helsinki.fi, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] clean up duplicated alloc/free_thread_info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <18500.59345.230174.727316@cargo.ozlabs.ibm.com>
References: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
	<84144f020806022306h236a48cbv32b82cfa83fe4ee6@mail.gmail.com>
	<18500.59345.230174.727316@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080604080135N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 16:42:25 +1000
Paul Mackerras <paulus@samba.org> wrote:

> Pekka Enberg writes:
> 
> > Yeah, I too have wondered why some architectures use kmalloc() whereas
> > others use the page allocator. Is THREAD_SIZE significantly smaller
> > than PAGE_SIZE for those?
> 
> 64-bit powerpc uses 16k kernel stacks and either 4k or 64k page size.
> If the page size is 64k then we don't want to allocate a whole page
> for a kernel stack.

On powerpc, the patch defines __HAVE_ARCH_THREAD_INFO_ALLOCATOR on the
THREAD_SHIFT < PAGE_SHIFT case so it doesn't change anything.

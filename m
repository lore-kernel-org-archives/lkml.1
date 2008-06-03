Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYFCGyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYFCGyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYFCGyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:54:13 -0400
Received: from ozlabs.org ([203.10.76.45]:44673 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYFCGyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:54:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18500.59345.230174.727316@cargo.ozlabs.ibm.com>
Date: Tue, 3 Jun 2008 16:42:25 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] clean up duplicated alloc/free_thread_info
In-Reply-To: <84144f020806022306h236a48cbv32b82cfa83fe4ee6@mail.gmail.com>
References: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
	<84144f020806022306h236a48cbv32b82cfa83fe4ee6@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg writes:

> Yeah, I too have wondered why some architectures use kmalloc() whereas
> others use the page allocator. Is THREAD_SIZE significantly smaller
> than PAGE_SIZE for those?

64-bit powerpc uses 16k kernel stacks and either 4k or 64k page size.
If the page size is 64k then we don't want to allocate a whole page
for a kernel stack.

Paul.

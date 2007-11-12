Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbXKLRQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbXKLRQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbXKLRQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:16:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759313AbXKLRQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:16:04 -0500
Message-ID: <473889C7.7000909@redhat.com>
Date: Mon, 12 Nov 2007 12:13:43 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Yoav Artzi <yoavar@checkpoint.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
References: <473865BE.2070806@checkpoint.com>
In-Reply-To: <473865BE.2070806@checkpoint.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoav Artzi wrote:
> According to my knowledge the PAGE_SIZE on 32bit architectures in 4KB. 
> Logically, the PAGE_SIZE on 64bit architectures should be 8KB. That's at 
> least the way I understand it. However, looking at the kernel code of 
> x86_64, I see the PAGE_SIZE is 4KB.
> 
> 
> Can anyone explain to me what am I missing here?

PAGE_SIZE is highly architecture-dependent.  While it is true that 4K pages are 
typical on 32-bit architectures, and 64-bit architectures have historically 
introduced 8K pages, this is by no means a requirement.  x86_64 uses the same 
page sizes that are available on i686+PAE, so you get 4K base pages.  alpha and 
sparc64 typically use 8K base pages, though they have other options as well. 
ia64 defaults to 16K, though it can do 4K, 8K, and a bunch of larger base sizes. 
  ppc64 does 4K and 64K.  s390 uses 4K base pages in both 31-bit and 64-bit 
kernels.  If x86_64 processors are released with TLBs that can handle 8K pages, 
it'll be straightforward to add that feature, but otherwise it would require 
faking it in software, which has lots of pitfalls and does nothing to improve 
TLB efficiency.

	-- Chris

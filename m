Return-Path: <linux-kernel-owner+w=401wt.eu-S1761493AbYCXTKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493AbYCXTKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbYCXTKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:10:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:57134 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbYCXTKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YZ3xdZMshrt75xrA1bY+vwcEfjpuxNUVlHBcu2yYj2sweLZJIYE0pqZvZe6SoEJMYBPTEd7ATMSYBhYxzEFQ/mWgzI9m2Yhy90ssp49jDSO8jHiOH7n2ploK/0ytlkXCXz3dN2GKex/7ZI8D95AvixmYznI+z5ps04ONOFGfxsc=
Message-ID: <4cefeab80803241210o16c83b49w4f23023cba95ca7c@mail.gmail.com>
Date: Tue, 25 Mar 2008 00:40:31 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/6] compcache: TLSF Allocator interface
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1206385013.6437.140.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242034.24264.nitingupta910@gmail.com>
	 <1206377777.6437.123.camel@lappy>
	 <4cefeab80803241034m6f62c01fq669129db9959f47f@mail.gmail.com>
	 <1206385013.6437.140.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 12:26 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Mon, 2008-03-24 at 23:04 +0530, Nitin Gupta wrote:
>  > On Mon, Mar 24, 2008 at 10:26 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  > > On Mon, 2008-03-24 at 20:34 +0530, Nitin Gupta wrote:
>  > >  > Two Level Segregate Fit (TLSF) Allocator is used to allocate memory for
>  > >  > variable size compressed pages. Its fast and gives low fragmentation.
>  > >  > Following links give details on this allocator:
>  > >  >  - http://rtportal.upv.es/rtmalloc/files/tlsf_paper_spe_2007.pdf
>  > >  >  - http://code.google.com/p/compcache/wiki/TLSFAllocator
>  > >  >
>  > >  > This kernel port of TLSF (v2.3.2) introduces several changes but underlying
>  > >  > algorithm remains the same.
>  > >  >
>  > >  > Changelog TLSF v2.3.2 vs this kernel port
>  > >  >  - Pool now dynamically expands/shrinks.
>  > >  >    It is collection of contiguous memory regions.
>  > >  >  - Changes to pool create interface as a result of above change.
>  > >  >  - Collect and export stats (/proc/tlsfinfo)
>  > >  >  - Cleanups: kernel coding style, added comments, macros -> static inline, etc.
>  > >
>  > >  Can you explain why you need this allocator, why don't the current
>  > >  kernel allocators work for you?
>  > >
>  > >
>  >
>  > kmalloc() allocates one of pre-defined sizes (as defined in
>  > kmalloc_sizes.h). This will surely cause severe fragmentation with
>  > these variable sized compressed pages.
>  >
>  > Whereas, TLSF maintains very fine grained size lists. In all the
>  > workloads I tested, it showed <5% fragmentation. Also, its very simple
>  > as just ~700 LOC.
>
>  Yeah, it also suffers from a horrible coding style, can use excessive
>  amounts of vmalloc space, isn't hooked into the reclaim process as an
>  allocator should be and has a severe lack of per-cpu data making it a
>  pretty big bottleneck on anything with more than a few cores.
>
>  Now, it might be needed, might work better, and the scalability issue
>  might not be a problem when used for swap, but still, you don't treat
>  any of these points in your changelog.

Currently, this TLSF implementation is not scalable at all (and thats
why it depends on EMBEDDED).

>
>  FWIW, please split up the patches in a sane way. This series looks like
>  it wants to be 2 or 3 patches. The first introducing all of TLSF (this
>  split per file is horrible). The second doing all of the block device,
>  and a possible last doing documentation and such.
>
>  Also, how bad was kmalloc() compared to this TLSF, we need numbers :-)
>
>

Ok, I will get them and present here.

Thanks,
Nitin

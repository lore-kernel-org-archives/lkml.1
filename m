Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYCXRed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYCXRed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYCXReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:34:23 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:64164 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYCXReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UeWflHOPkyxDUGy7zKC5gigr8PxJTe+ADfyoi/I5G8HgR3opUGsL1EWzeQJoOMvg++8ggZFkZn14OwAMnq4Zt4T9E+OKMudHEFYT8q23jn0OJMQQG2QERqK1fKp1Dx9yT1Dm3XLYTu8B2CAmFe1gCpKzDmTW7QU1wYJEXrGLctk=
Message-ID: <4cefeab80803241034m6f62c01fq669129db9959f47f@mail.gmail.com>
Date: Mon, 24 Mar 2008 23:04:18 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/6] compcache: TLSF Allocator interface
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1206377777.6437.123.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242034.24264.nitingupta910@gmail.com>
	 <1206377777.6437.123.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 10:26 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2008-03-24 at 20:34 +0530, Nitin Gupta wrote:
>  > Two Level Segregate Fit (TLSF) Allocator is used to allocate memory for
>  > variable size compressed pages. Its fast and gives low fragmentation.
>  > Following links give details on this allocator:
>  >  - http://rtportal.upv.es/rtmalloc/files/tlsf_paper_spe_2007.pdf
>  >  - http://code.google.com/p/compcache/wiki/TLSFAllocator
>  >
>  > This kernel port of TLSF (v2.3.2) introduces several changes but underlying
>  > algorithm remains the same.
>  >
>  > Changelog TLSF v2.3.2 vs this kernel port
>  >  - Pool now dynamically expands/shrinks.
>  >    It is collection of contiguous memory regions.
>  >  - Changes to pool create interface as a result of above change.
>  >  - Collect and export stats (/proc/tlsfinfo)
>  >  - Cleanups: kernel coding style, added comments, macros -> static inline, etc.
>
>  Can you explain why you need this allocator, why don't the current
>  kernel allocators work for you?
>
>

kmalloc() allocates one of pre-defined sizes (as defined in
kmalloc_sizes.h). This will surely cause severe fragmentation with
these variable sized compressed pages.

Whereas, TLSF maintains very fine grained size lists. In all the
workloads I tested, it showed <5% fragmentation. Also, its very simple
as just ~700 LOC.

- Nitin

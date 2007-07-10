Return-Path: <linux-kernel-owner+w=401wt.eu-S1763684AbXGJJB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763684AbXGJJB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763176AbXGJJBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:01:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:60738 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762566AbXGJJBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cD0SWz3oXej2WyRCvS78qh2rOILBq1/bmXXe9w2JwJPtCQ91toHbVKFEeUHm0b7CYj/zEwGWTOPZ93z2OeDG5pZSe2PJmmlq/MX7MW++cFGxtpHilN7eRHYnjiolKQ+xFODlT5pArVv26HdBIRfTk2cETnRgqu5/ui6RUgEi60E=
Message-ID: <1defaf580707100201y3c2d21c5lc38165eedaa9be73@mail.gmail.com>
Date: Tue, 10 Jul 2007 11:01:43 +0200
From: "=?ISO-8859-1?Q?H=E5vard_Skinnemoen?=" <hskinnemoen@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       "Erik Andersen" <andersen@codepoet.org>
In-Reply-To: <20070710083212.GG11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070708075119.GA16631@elte.hu> <4691A415.6040208@yahoo.com.au>
	 <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
	 <20070709095116.c2ea700f.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
	 <4692E44E.6000606@yahoo.com.au>
	 <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
	 <4692E8B5.3030404@yahoo.com.au>
	 <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
	 <20070710083212.GG11115@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Matt Mackall <mpm@selenic.com> wrote:
> The only remaining known bug is arguably a problem in nommu that SLOB
> shouldn't be papering over.

I've got another one for you: SLOB ignores ARCH_KMALLOC_MINALIGN so
using SLOB in combination with DMA and non-coherent architectures
causes data corruption.

That said, there are currently very few architectures that define
ARCH_KMALLOC_MINALIGN, so I guess it might be something I'm doing
wrong on avr32. But I'd really like to know how other non-coherent
architectures handle DMA to buffers sharing cachelines with unrelated
data...

Håvard

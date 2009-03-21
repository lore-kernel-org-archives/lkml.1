Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZCUK2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZCUK2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZCUK1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:27:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105AbZCUK1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:27:50 -0400
Date: Sat, 21 Mar 2009 03:21:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ngupta@vflare.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, cl@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
Message-Id: <20090321032137.8dc113e8.akpm@linux-foundation.org>
In-Reply-To: <49C3F1EE.90903@vflare.org>
References: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>
	<49C3F1EE.90903@vflare.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 01:13:42 +0530 Nitin Gupta <ngupta@vflare.org> wrote:

> Pekka Enberg wrote:
> > On 3/20/2009, "Christoph Lameter" <cl@linux-foundation.org> wrote:
> >>> I think, with a bit playing around with interfaces, it can be turned into
> >>> general purpose allocator (this will most probably lack highmem support).
> >> Then it would need to implement the SLAB api (see include/linux/slab.h).
> >> Thus we are getting slab allocator #5.
> > 
> > I do not see the point in that. As I suggested earlier, you should
> > probably just move this into drivers/block/ and make it a private
> > compcache allocator.
> > 
> 
> Your wish. But, really, we should not dismiss an O(1) allocator with great
> space-efficiency so easily. I think it will be great at least for embedded
> devices (its counterpart, SLOB is simply funny).
> 
> Just to add to this, Xen recently included a variant of TLSF allocator
> which was used in earlier versions of compcache. TLSF is allocator on
> which xvmalloc is based.
> http://xenbits.xensource.com/xen-unstable.hg?file/0477f9061c8a/xen/common/xmalloc_tlsf.c
> (Though I do not know which parts of xen depend on this allocator).
> 
> and xvmalloc vs tlsf arguments are here:
> http://code.google.com/p/compcache/wiki/xvMalloc
> 
> tlsf:
> http://rtportal.upv.es/rtmalloc/

Well, xvmalloc may or may not be a good thing and we can discuss that
separately.

But what is regrettable is that xvmalloc appears to be tied to
compressed-swap in some manner.  Is it not possible to split these two
initiatives apart so that neither is dependent upon the other?  Or is
compressed-swap hopelessly crippled without xvmalloc?

(compcache is a terrible name, btw - it isn't a "compressed cache" at all!)

> Anyways, I will move it to drivers/block.

This sounds like it might be a backward step.

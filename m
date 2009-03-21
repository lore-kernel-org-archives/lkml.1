Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZCUMa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZCUMa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZCUMaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:30:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807AbZCUMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:30:10 -0400
Date: Sat, 21 Mar 2009 05:24:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, cl@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
Message-Id: <20090321052416.6eb38759.akpm@linux-foundation.org>
In-Reply-To: <49C4D9C4.1030103@vflare.org>
References: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>
	<49C3F1EE.90903@vflare.org>
	<20090321032137.8dc113e8.akpm@linux-foundation.org>
	<49C4D9C4.1030103@vflare.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 17:42:52 +0530 Nitin Gupta <nitingupta910@gmail.com> wrote:

> Andrew Morton wrote:
> > On Sat, 21 Mar 2009 01:13:42 +0530 Nitin Gupta <ngupta@vflare.org> wrote:
> 
> > But what is regrettable is that xvmalloc appears to be tied to
> > compressed-swap in some manner.  Is it not possible to split these two
> > initiatives apart so that neither is dependent upon the other?  Or is
> > compressed-swap hopelessly crippled without xvmalloc?
> 
> xvmalloc itself is completely independent of compressed-swap. Infact, its
> loaded as separate kernel module (xvmalloc.ko)

That sounds good.

> However, this compression project is almost useless without this specialized
> allocator.

Why?  Important information!!

See, being told all this helps us understand why xvmalloc exists.  Plus
once we have a good description of _why_ xvmalloc is needed, perhaps we can
come up with alternatives which are more palatable than merging a whole new
allocator.  Such as enhancing an existing one.

> > 
> > (compcache is a terrible name, btw - it isn't a "compressed cache" at all!)
> > 
> 
> I have now heard this many times and my conscious is beginning to hurt now :)
> I will change it to match name of its block device: ramzswap   sounds better?

Is there anything swap-specific about it?  It's a block device, yes?  I
should be able to run mkfs.ext2 on it and mount the thing?

> >> Anyways, I will move it to drivers/block.
> > 
> > This sounds like it might be a backward step.
> 
> 
> I'm bit confused here. Last thing I want to do is block mainline merge
> because of such issues. Its real pain to maintain these things separately.

This is why I tell myself to never use the word "it" in an email message.

I assumed that you were referring to moving xvmalloc() down into
drivers/block.  That would be bad, because then xvmalloc() will _never_ be
usable by anything other than ramzblock <new name!>?



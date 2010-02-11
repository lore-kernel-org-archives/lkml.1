Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0BKNBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:01:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57065 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0BKNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:01:31 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B73FE96.2080707@kernel.org> (message from Tejun Heo on Thu, 11
	Feb 2010 21:56:54 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org>
Message-Id: <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 14:01:23 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Tejun Heo wrote:
> > And playing with ->vm_pgoff is *not* a valid thing to do for the
> > client, at least not on "normal" mmaps.
> 
> That's the requirement coming from allowing the server to determine
> how these mmaps are served, not from the fact that the management is
> done via server side mmaps or the server maps those regions into its
> process address space.  No matter how you do it, if you want to mix
> and match client mmap requests, the SHMLBA alignment will be visible.

Can you give an example?

> I suppose you're talking about not allowing offsets to be adjusted at
> all but I don't think that's a restriction we would want to have at
> the kernel API level because offset might encode different things for
> device mmaps.

Possibly.  But there's some confusion about offsets again.  This
offset is not the same as the one currently returned in fuse_mmap_out.

And neither is the SHMLBA alignment requirement so clear:

You say, that ossp ignores the client mmap offset.  So basically it
resets the offset to zero, whatever it was, no?  That sounds fine, but
then you are adjusting the offset by something not necessarily a
multiple of SHMLBA.

So there are different offsets:

 a) vma->vm_pgoff (which may mean anything, but usually means b)
 b) the offset at which the pages of the mapping are located
 c) the offset at which the server side mmap is located

Thanks,
Miklos

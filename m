Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0BKOkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:40:11 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56055 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab0BKOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:40:09 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B740CFB.7060409@kernel.org> (message from Tejun Heo on Thu, 11
	Feb 2010 22:58:19 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org> <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu> <4B74065D.2000707@kernel.org> <E1NfZHO-0003FY-8E@pomaz-ex.szeredi.hu> <4B740CFB.7060409@kernel.org>
Message-Id: <E1NfaD3-0003MQ-Du@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 15:40:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Tejun Heo wrote:
> >> There are three offsets.
> >>
> >> a) the offset a client requested
> >>
> >> b) the offset into dmmap AS, a client mmap region is mapped to.  This
> >>    could be different from a) by multiple of SHMLBA / PAGE_SIZE.
> > 
> > No, it could be different from a) by an arbitrary value.
> 
> Then, sharing those pages would cause aliasing issues.

You said a few mails up:

  "There are device mmap() implementations which simply ignore @offset
   because offsetting doesn't make any sense at all"

Which means a) doesn't necessarily matter, so it's not something that
determines aliasing issues.

> >> c) the offset into dmmap AS, a server mmap region is mapped to, where
> >>    collection of these mmaps define the dmmap AS.
> >>
> >> The offsets used in b) and c) are the same offsets.
> > 
> > Why are they the same?
> 
> I meant they point into the same space.  If they're the same value,
> they point to the same page.

I'm beginning to undestand what you mean by "dmmap AS".

The thing is, I'm still not sure if or how this kind of mmap makes
sense outside of the CUSE context.  Which makes designing the API
difficult.

So, for now maybe it's best to go with your implementation, fix issues
with the offsets and make it CUSE only for the moment.

The alternative is for me to start implementing a coherent distributed
filesystem, so I can see what the actual requirements for a direct
mmap would be.  That would be fun, but it would

  a) delay direct mmap for CUSE by an unknown amount of time
  b) delay everything else that I have in the pipeline ;)

Thanks,
Miklos

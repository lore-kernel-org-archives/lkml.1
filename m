Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0BKMqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:46:51 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56839 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab0BKMqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:46:50 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B73FCF2.3020108@kernel.org> (message from Tejun Heo on Thu, 11
	Feb 2010 21:49:54 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <E1NfVho-0002nJ-V2@pomaz-ex.szeredi.hu> <4B73F006.7090706@kernel.org> <E1NfY6X-00032f-42@pomaz-ex.szeredi.hu> <4B73FCF2.3020108@kernel.org>
Message-Id: <E1NfYRH-00035s-4h@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 13:46:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Tejun Heo wrote:
> Hello, Miklos.
> 
> On 02/11/2010 09:25 PM, Miklos Szeredi wrote:
> >> If the server wants the two regions to be separate, it can map it to
> >> say 5-11 and returnt he offset of 5.  If it wants them to be shared,
> >> it will have to mmap 1-2 and 6-7 and return offset of 1.
> > 
> > What if region 6-7 is already occupied (e.g. because a separate region
> > was put there)?
> 
> Allocating and managing the address space ranges are the server's
> responsibility.  If it expects the region to grow, it shouldn't
> colocate those regions.  The kernel is just giving the server an
> address space to manage and letting it redirect mmaps to arbitrary
> (sans the SHMLBA alignment restriction) part of it.  The rest is upto
> the server.

The problem with that is you simply can't determine in advance where
the region will grow.  Okay, you can leave space according to the size
of the file, but the size of the file can grow too.

*This* is the complexity that I want to get rid of.

Thanks,
Miklos

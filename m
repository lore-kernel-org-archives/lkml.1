Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0BKMZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:25:21 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40486 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0BKMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:25:20 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B73F006.7090706@kernel.org> (message from Tejun Heo on Thu, 11
	Feb 2010 20:54:46 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <E1NfVho-0002nJ-V2@pomaz-ex.szeredi.hu> <4B73F006.7090706@kernel.org>
Message-Id: <E1NfY6X-00032f-42@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 13:25:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Tejun Heo wrote:
> > And there's a weakness in the current server side mmap interface, for
> > example:
> > 
> >  1) user mmaps region 3-5 (in page index)
> >       server maps this region at 3-5
> > 
> >  2) user mmaps region 1-7
> >      server can't tell kernel that it wants to reuse region 3-5 but
> >      wants to create two other regions
> > 
> > What happens in that case?
> 
> If the server wants the two regions to be separate, it can map it to
> say 5-11 and returnt he offset of 5.  If it wants them to be shared,
> it will have to mmap 1-2 and 6-7 and return offset of 1.

What if region 6-7 is already occupied (e.g. because a separate region
was put there)?

Thanks,
Miklos

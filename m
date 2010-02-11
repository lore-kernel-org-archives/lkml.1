Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0BKNIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:08:25 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51846 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0BKNIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:08:24 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B7400A7.5070105@kernel.org> (message from Tejun Heo on Thu, 11
	Feb 2010 22:05:43 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <E1NfVho-0002nJ-V2@pomaz-ex.szeredi.hu> <4B73F006.7090706@kernel.org> <E1NfY6X-00032f-42@pomaz-ex.szeredi.hu> <4B73FCF2.3020108@kernel.org> <E1NfYRH-00035s-4h@pomaz-ex.szeredi.hu> <4B7400A7.5070105@kernel.org>
Message-Id: <E1NfYmD-0003Aj-N9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 14:08:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Tejun Heo wrote:
> Hello,
> 
> On 02/11/2010 09:46 PM, Miklos Szeredi wrote:
> > The problem with that is you simply can't determine in advance where
> > the region will grow.  Okay, you can leave space according to the size
> > of the file, but the size of the file can grow too.
> > 
> > *This* is the complexity that I want to get rid of.
> 
> Alright, then let's talk about that, not SHMLBA which doesn't really
> have much to do with this.  So, you're basically saying that you want
> multiple address spaces.  In that case, the only logical abstraction
> for that are files.  ie. We need to be passing file descriptors to the
> server and asking the server which descriptor it would want to use,
> which was the previous implementation, which you objected mentioning
> that this type of direct mmap would probably be useful only for device
> mmap implementations.

No, I don't want to pass file descriptors (early fuse did use that for
readdir and it was a mistake).

Global address space for server side maps are OK.  What I mind is that
in the *absence* of server side maps the filesystem still has to deal
with the global address space (with all its quirks).  This is totally
unnecessary.

Thanks,
Miklos

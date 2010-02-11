Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0BKM7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:59:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:50127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0BKM7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:59:38 -0500
Message-ID: <4B7400A7.5070105@kernel.org>
Date: Thu, 11 Feb 2010 22:05:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <E1NfVho-0002nJ-V2@pomaz-ex.szeredi.hu> <4B73F006.7090706@kernel.org> <E1NfY6X-00032f-42@pomaz-ex.szeredi.hu> <4B73FCF2.3020108@kernel.org> <E1NfYRH-00035s-4h@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfYRH-00035s-4h@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 12:58:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 09:46 PM, Miklos Szeredi wrote:
> The problem with that is you simply can't determine in advance where
> the region will grow.  Okay, you can leave space according to the size
> of the file, but the size of the file can grow too.
> 
> *This* is the complexity that I want to get rid of.

Alright, then let's talk about that, not SHMLBA which doesn't really
have much to do with this.  So, you're basically saying that you want
multiple address spaces.  In that case, the only logical abstraction
for that are files.  ie. We need to be passing file descriptors to the
server and asking the server which descriptor it would want to use,
which was the previous implementation, which you objected mentioning
that this type of direct mmap would probably be useful only for device
mmap implementations.

The address space provided for dmmap is huge.  It's any range which
pgoff_t can address.  I really can't imagine managing allocation from
that space causing problems.  If you want to use it for multiple huge
mappings, we can't use the simple implementation w/ pinned pages
anyway.  We'll have to borrow anonymous file implementation or
implement private swap backing.

Thanks.

-- 
tejun

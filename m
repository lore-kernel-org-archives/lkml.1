Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab0BLRtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:49:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:49934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756494Ab0BLRtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:49:21 -0500
Message-ID: <4B759635.1080908@kernel.org>
Date: Sat, 13 Feb 2010 02:56:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org> <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu> <4B74065D.2000707@kernel.org> <E1NfZHO-0003FY-8E@pomaz-ex.szeredi.hu> <4B740CFB.7060409@kernel.org> <E1NfaD3-0003MQ-Du@pomaz-ex.szeredi.hu> <4B749BDF.8000807@kernel.org> <E1NfsEw-0005AW-Nl@pomaz-ex.szeredi.hu> <4B7558C1.2060405@kernel.org> <E1NfvxX-0005UA-8P@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfvxX-0005UA-8P@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 17:48:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/12/2010 10:53 PM, Miklos Szeredi wrote:
> That dev_offset value is used as an offset into the server side mmap
> address space.  And yes, vma->vm_pgoff and dev_offset should be SHMLBA
> multiples apart.

Alright.

> But don't call that _adjustment_.  That's totally confusing, these are
> *two* *different* *offsets*.

At this point, we're completely in the realm of the babel tower.
Unless we define all the terms explicitly, I don't think using or not
using a single word would make much difference.  Working with FUSE
gets a bit confusing regarding which term means what but with
multiple process address spaces and the dmmap address space and all
the offsets, it's getting pretty ridiculous.

> There's an alignment requirement but that's all.  If they are the
> same that is pure coincidence.
>
> And dev_offset (which points into the dmmap address space) is only
> required if the filesystem/CUSE driver needs server side mmap.

Hmmm... w/o the dev_offset how would the server designate which area
to use for the client?

Thanks.

-- 
tejun

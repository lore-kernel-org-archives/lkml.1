Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0BKMu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:50:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:33971 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab0BKMu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:50:26 -0500
Message-ID: <4B73FE96.2080707@kernel.org>
Date: Thu, 11 Feb 2010 21:56:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 12:49:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 09:34 PM, Miklos Szeredi wrote:
> On Thu, 11 Feb 2010, Tejun Heo wrote:
>> It's not like it's something completely foreign.  It's a limitation
>> which can also be found in shared memory and the server side mmap
>> doesn't really have much to do with it.  It's also necessary to avoid
>> aliasing issues among clients.
> 
> What aliasing issues among clients?  That's a job for the arch
> dependent part of mmap.  And as you said, there's not a lot the driver
> can do (except play with ->vm_pgoff) to influence the address
> selection.
>
> And playing with ->vm_pgoff is *not* a valid thing to do for the
> client, at least not on "normal" mmaps.

That's the requirement coming from allowing the server to determine
how these mmaps are served, not from the fact that the management is
done via server side mmaps or the server maps those regions into its
process address space.  No matter how you do it, if you want to mix
and match client mmap requests, the SHMLBA alignment will be visible.
I suppose you're talking about not allowing offsets to be adjusted at
all but I don't think that's a restriction we would want to have at
the kernel API level because offset might encode different things for
device mmaps.

Thanks.

-- 
tejun

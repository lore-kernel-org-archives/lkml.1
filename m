Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbZGHXQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbZGHXQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 19:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbZGHXQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 19:16:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:57764 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204AbZGHXQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 19:16:26 -0400
Message-ID: <4A55286A.6040202@kernel.org>
Date: Thu, 09 Jul 2009 08:14:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-5-git-send-email-tj@kernel.org> <E1MJPmn-0001Q6-Fj@pomaz-ex.szeredi.hu> <4A48EEDC.807@kernel.org> <E1MMMgq-0002R2-FO@pomaz-ex.szeredi.hu> <4A4F3998.5020805@kernel.org> <E1MNmZM-0001ZB-GR@pomaz-ex.szeredi.hu>
In-Reply-To: <E1MNmZM-0001ZB-GR@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Jul 2009 23:14:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

Miklos Szeredi wrote:
> On Sat, 04 Jul 2009, Tejun Heo wrote:
>>> Afaics sound drivers now map the dma memory with remap_pfn_range().
>>> Similary we could allocate a chunk of non-swapabble kernel memory on
>>> request from the userspace server and map its pages using this trick
>>> to both the server's and the client's address space.
>>>
>>> This is still sort of OSSP specific, I don't see clearly how it could
>>> be made more generic.
>> Using non-swappable memory would be fine for most device emulations
>> but mapping large amount of pages would be problematic.  Hmmm... this
>> is difficult.  It's a compromise among flexibility, scalability and
>> code complexity.
> 
> What's the difficulty?

The desire to avoid pinning all the mapped pages.  :-)

> Allocating pages, giving them an ID and mapping them into various page
> tables seems simple in contrast to trying to make a tmpfs file be a
> fuse file at the same time, which the VM is really not prepared for.

If pinning all the pages are okay, the above should work fine.

Thanks.

-- 
tejun

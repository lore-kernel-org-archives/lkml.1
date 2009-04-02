Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZDBEnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZDBEnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZDBEnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:43:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:55088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbZDBEnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:43:03 -0400
Message-ID: <49D44251.4000606@kernel.org>
Date: Thu, 02 Apr 2009 13:42:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: More problems in setup_pcpu_remap()
References: <20090401.213112.96144152.davem@davemloft.net>
In-Reply-To: <20090401.213112.96144152.davem@davemloft.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 04:43:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

David Miller wrote:
> The way this code is currently designed, it can exhaust all of the
> VMALLOC address space on both x86 and x86_64, and then some.
> 
> It allocates PMD_SIZE * num_possible_cpus() of vmalloc space.
> 
> PMD_SIZE is 2MB, num_possible_cpus() can be up to 4096....
> which can easily exceed (VMALLOC_END - VMALLOC_START)
> 
> Initially I had set out to implement sparc64 support for the new
> per-cpu stuff, but it looks like I'm stuck finding bugs in the x86
> implementation instead :-)

Eh... sorry about that.  :-)

I guess we'll have to put a cap on how high possible cpus can be for
remap allocator.  e.g. if single chunk size is over 20% of the whole
vmalloc area, don't use remap.  Does anyone have a good random %
number on mind?

Thanks.

-- 
tejun

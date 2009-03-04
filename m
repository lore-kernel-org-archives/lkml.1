Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZCDKEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZCDKEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZCDKEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:04:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:32752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZCDKEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:04:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,299,1233561600"; 
   d="scan'208";a="116586447"
Date: Wed, 4 Mar 2009 18:04:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Markus <M4rkusXXL@web.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: drop_caches ...
Message-ID: <20090304100420.GA16859@localhost>
References: <200903041057.34072.M4rkusXXL@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903041057.34072.M4rkusXXL@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

On Wed, Mar 04, 2009 at 10:57:33AM +0100, Markus wrote:
> Hello!
> 
> I have a small problem. Maybe its just a misunderstanding but I cant 
> solve it.
> 
> I think that writing "3" to drop_caches should drop all buffers and 
> caches which are already written. So its recommended to put a "sync" 
> infront of it.
> So I did "free -m ; sync ; echo 3 > /proc/sys/vm/drop_caches ; free -m"
> And it gave me:
>              total       used       free     shared    buffers     
> cached
> Mem:          3950       3922         28          0          1        
> 879
> -/+ buffers/cache:       3041        909
> Swap:         5342        205       5136
>              total       used       free     shared    buffers     
> cached
> Mem:          3950       3907         43          0          0        
> 864
> -/+ buffers/cache:       3041        908
> Swap:         5341        206       5135
> 
> So the buffer was 1 and is 0 afterthat. But cached is at 879 MB before 
> and is still 864 MB (!!!) after that!
> 
> I am at swappiness=0 and when I remove and readd one swap-partition 
> after another (so there is always swap). It will keep the cached and 
> put the swapped memory on other swaps?!
> 
> I _think_ thats not the way it should go?
> 
> It would be really kind if someone could explain that issue and 
> what "cached" is at all!

The memory mapped pages won't be dropped in this way.
"cat /proc/meminfo" will show you the number of mapped pages.

Thanks,
Fengguang

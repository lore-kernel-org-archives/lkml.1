Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYKMDPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYKMDPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYKMDPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:15:18 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:44476 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbYKMDPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:15:15 -0500
Message-ID: <491B9BB3.6010701@linux.vnet.ibm.com>
Date: Thu, 13 Nov 2008 08:44:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, nishimura@mxp.nes.nec.co.jp,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH 1/6] memcg: free all at rmdir
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com> <20081112122656.c6e56248.kamezawa.hiroyu@jp.fujitsu.com> <20081112160758.3dca0b22.akpm@linux-foundation.org> <20081113114908.42a6a8a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081113114908.42a6a8a7.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 12 Nov 2008 16:07:58 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>> If we do this then we can make the above "keep" behaviour non-optional,
>> and the operator gets to choose whether or not to drop the caches
>> before doing the rmdir.
>>
>> Plus, we get a new per-memcg drop_caches capability.  And it's a nicer
>> interface, and it doesn't have the obvious races which on_rmdir has,
>> etc.
>>
>> hm?
>>
> 
> Balbir, how would you want to do ?
> 
> I planned to post shrink_uage patch later (it's easy to be implemented) regardless
> of acceptance of this patch.
> 
> So, I think we should add shrink_usage now and drop this is a way to go.

I am a bit concerned about dropping stuff at will later. Ubuntu 8.10 has memory
controller enabled and we exposed memory.force_empty interface there and now
we've dropped it (bad on our part). I think we should have deprecated it and
dropped it later.

> I think I can prepare patch soon. But I'd like to push handle-swap-cache patch
> before introducing shrink_usage. 
> 
> Then, posting following 2 patch for this week is my current intention.
>  [1/2] handle swap cache
>  [2/2] shrink_usage patch (instead of this patch)
> 
> Objection ?

No.. just be wary of breaking API, please!

-- 
	Balbir

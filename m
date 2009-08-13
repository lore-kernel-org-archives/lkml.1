Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZHMQN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZHMQN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 12:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZHMQN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 12:13:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:19218 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZHMQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 12:13:24 -0400
Message-ID: <4A843B96.3010200@vflare.org>
Date: Thu, 13 Aug 2009 21:43:10 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
References: <200908122007.43522.ngupta@vflare.org> <Pine.LNX.4.64.0908122312380.25501@sister.anvils> <20090813151312.GA13559@linux.intel.com>
In-Reply-To: <20090813151312.GA13559@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 08:43 PM, Matthew Wilcox wrote:

>
> I am planning a complete overhaul of the discard work.  Users can send
> down discard requests as frequently as they like.  The block layer will
> cache them, and invalidate them if writes come through.  Periodically,
> the block layer will send down a TRIM or an UNMAP (depending on the
> underlying device) and get rid of the blocks that have remained unwanted
> in the interim.
>

This batching of discard requests is still sub-optimal for compcache. 
The optimal solution in this case is to get callback *as soon as* a swap 
slot becomes free and this is what this patch does.

I see that it will be difficult to accept this patch since compcache 
seems to be the only user for now. However, this little addition makes a 
*big* difference for the project. Currently, much of memory is wasted to 
store all the stale data.

I will be posting compcache patches for review in next merge window. So, 
maybe this patch can be included now as the first step? The revised 
patch is ready which addresses issues raised during the first review -- 
will post it soon.

Thanks,
Nitin

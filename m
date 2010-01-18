Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144Ab0ARL04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0ARL04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927Ab0ARL0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:26:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:39547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab0ARL0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:26:54 -0500
Message-ID: <4B5444FD.4050500@kernel.org>
Date: Mon, 18 Jan 2010 20:24:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 39/40] gfs2: use workqueue instead of slow-work
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-40-git-send-email-tj@kernel.org> <1263807959.2715.4.camel@localhost>
In-Reply-To: <1263807959.2715.4.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 11:24:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 06:45 PM, Steven Whitehouse wrote:
> Hi,
> 
> On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
>> Workqueue can now handle high concurrency.  Use system_long_wq instead
>> of slow-work.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Steven Whitehouse <swhiteho@redhat.com>
> 
> Acked-by: Steven Whitehouse <swhiteho@redhat.com> on two conditions:
> 
>  i) That scheduling work on this new workqueue will not require any
> GFP_KERNEL allocations (even hidden ones such as starting new threads)
> before the work runs. This is required since the recovery code must not
> call into the fs until after its recovered.

Oh, if that's the case, it needs its own wq with a rescuer.  I thought
the recovery path wasn't invoked during allocation.  slow-work didn't
guarantee such thing either.  Anyways, changing that is pretty easy.

Thanks.

-- 
tejun

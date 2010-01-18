Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225Ab0ARL1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0ARL1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276Ab0ARL12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:27:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:39568 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab0ARL10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:27:26 -0500
Message-ID: <4B544571.7020609@kernel.org>
Date: Mon, 18 Jan 2010 20:26:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 01/40] sched: consult online mask instead of active in
 select_fallback_rq()
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-2-git-send-email-tj@kernel.org> <1263809620.4283.173.camel@laptop>
In-Reply-To: <1263809620.4283.173.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 11:26:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/18/2010 07:13 PM, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
>> If called after sched_class chooses a CPU which isn't in a task's
>> cpus_allowed mask,
> 
> I can only see this happening when you're changing cpus_allowed after
> starting to take down the cpu. IOW you're moving a thread to a dying
> cpu.
> 
> This is because you're spawning workqueue threads while we're going
> down?

It got triggered by the hotplug callback creating the trustee kthread
and kthread_bind()ing it to the target cpu during CPU_DOWN_PREPARE.

Thanks.

-- 
tejun

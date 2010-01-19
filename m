Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619Ab0ASBCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0ASBCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295Ab0ASBCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:02:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:54565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab0ASBCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:02:32 -0500
Message-ID: <4B5505E2.4080203@kernel.org>
Date: Tue, 19 Jan 2010 10:07:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 04/40] sched: implement __set_cpus_allowed()
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-5-git-send-email-tj@kernel.org>	 <1263808570.4283.149.camel@laptop>  <4B54445E.302@kernel.org> <1263814869.4283.296.camel@laptop>
In-Reply-To: <1263814869.4283.296.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 01:01:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/18/2010 08:41 PM, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 20:22 +0900, Tejun Heo wrote:
>> These part haven't changed at all since the last posting so if you
>> disliked it before it's kind of expected you still do so.
> 
> You could at least have augmented the changelog with the why.. my memory
> thinks it had to so with that silly move back on up story.
>
>> Anyways, I'm not the greatest fan of this patch either.  Let's see how
>> the whole series fares out first and try to make this better.  What do
>> you think about doing what's described in the NOTE?
> 
> I'm still not sure we need any of this. For new threads we have the
> stopped state and kthread_bind() should work in its current form (except
> you need patch 1 in your series when you're creating new threads when
> the cpu is currently going down).

It's also necessary to guarantee forward progress during CPU_DOWN.
The problem with kthread_bind() is that it's not synchronized against
CPU hotplug operations.  It needs outer synchronization like calling
it directly from CPU_DOWN_PREP.  I guess it's doable but I think it
would be better to simply share the backend implementation between
set_cpus_allowed_ptr() and kthread_bind().

Thanks.

-- 
tejun

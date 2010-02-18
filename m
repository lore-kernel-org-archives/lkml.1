Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab0BRM2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:28:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:59446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463Ab0BRM2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:28:32 -0500
Message-ID: <4B7D338C.7020008@kernel.org>
Date: Thu, 18 Feb 2010 21:33:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 35/40] fscache: convert object to use workqueue instead
 of slow-work
References: <4B7B2F4E.5090803@kernel.org> <4B7A13C6.4060402@kernel.org> <4B763C17.5080707@kernel.org> <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org> <24913.1265997809@redhat.com> <27102.1266246296@redhat.com> <28151.1266343557@redhat.com> <26902.1266493816@redhat.com>
In-Reply-To: <26902.1266493816@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Feb 2010 12:24:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On 02/18/2010 08:50 PM, David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
>> The waiting workers are woken up in slow_work_enqueue() when a new
>> work is enqueued regardless of how many workers are currently in use,
>> right?  So, it ends up yielding on any queue activity rather than only
>> under resource pressure.
> 
> It depends how you define resource pressure, I suppose.  There's someone now
> waiting for the resource, and there's someone blocking that resource who can
> yield it as they're waiting on something else.  The question is if it's
> cheaper to create a new thread, assuming we're under the limit, or if it's
> cheaper to steal someone else's thread?

Initially I was thinking about adding the hook to global cmwq events
in which case yielding on queueing wouldn't make much sense as it will
always yield very quickly.  I'll think more about it but will try to
preserve the current behavior.  I'll go ahead and update the patchset.

Thanks for reviewing.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZLRPBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZLRPBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZLRPBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:01:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:32569 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbZLRPBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:01:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,418,1257148800"; 
   d="scan'208";a="580220070"
Message-ID: <4B2B9949.1000608@linux.intel.com>
Date: Fri, 18 Dec 2009 07:01:29 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
       torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box>
In-Reply-To: <20091218135033.GB8678@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2009 5:50, Andi Kleen wrote:
>> The only way something can be not cpu intensive and long 'running' is if
>> it got blocked that long, and the right solution is to fix that
>> contention, things should not be blocked for seconds.
>
> Work queue items shouldn't be blocking for seconds in the normal case, but it might
> always happen in the exceptional case (e.g. handling some error condition).
> In this case it would be good if the other jobs wouldn't be too
> disrupted and the whole setup degrades gracefully.

in addition, threads are cheap. Linux has no technical problem with running 100's of kernel threads
(if not 1000s); they cost basically a task struct and a stack (2 pages) each and that's about it.
making an elaborate-and-thus-fragile design to save a few kernel threads is likely a bad design direction...

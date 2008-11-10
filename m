Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYKJSpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYKJSpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYKJSpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:45:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47791 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbYKJSpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:45:39 -0500
Message-ID: <4918812C.2020405@redhat.com>
Date: Mon, 10 Nov 2008 13:45:00 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
References: <490F468B.4040602@redhat.com> <1225762877.27266.22.camel@yhuang-dev.sh.intel.com> <20081110163135.616E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081110163135.616E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>>> As far as I know, barriers don't cause changes to be visible on other
>>>> CPUs faster too. It just guarantees corresponding operations after will
>>>> not get executed until that before have finished. And, I don't think we
>>>> need make changes to be visible on other CPUs faster.
>>> You're correct that barrier() has no impact on other CPUs.  wmb() and rmb() do. 
>>>   If we don't need to make changes visible any faster, what's the point in using 
>>> atomic_set()?  It's not any less racy.  atomic_inc() and atomic_dec() would be 
>>> less racy, but you're not using those.
>> In default bust_spinlocks() implementation in lib/bust_spinlocks.c,
>> atomic_inc() and atomic_dec_and_test() is used. Which is used by x86
>> too. In some other architecture, atomic_set() is used to replace
>> "oops_in_progress = <xxx>". So this patch fixes architectures which use
>> default bust_spinlocks(), other architectures can be fixed by
>> corresponding architecture developers.
> 
> I think Chris is right.
> So, I reccomend to read Documentation/memory-barriers.txt
> 
> Almost architecture gurantee atomic_inc cause barrier implicitly.
> but not _all_ architecture.

The rmb() before atomic_read() is even more critical, since that's a 
non-barrier operation on nearly all platforms.

-- Chris

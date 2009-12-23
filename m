Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbZLWDqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbZLWDqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 22:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZLWDqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 22:46:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:49225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZLWDqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 22:46:35 -0500
Message-ID: <4B319323.5030704@kernel.org>
Date: Wed, 23 Dec 2009 12:48:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org>	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>	 <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org>	 <1261405604.4314.154.camel@laptop>  <4B3009DC.7020407@kernel.org> <1261479857.4937.18.camel@laptop>
In-Reply-To: <1261479857.4937.18.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/22/2009 08:04 PM, Peter Zijlstra wrote:
> On Tue, 2009-12-22 at 08:50 +0900, Tejun Heo wrote:
>>> Also, I think that whole move tasks back on online stuff is utter crazy,
>>> just move then to another cpu and leave them there.
>>
>> Can you be more specific?  Why is it crazy when moving to online but
>> !active cpu is necessary anyway? 
> 
> because its extra (and above all ugly code) that serves no purpose what
> so ever.

The forward progress guarantee requires rescuers to migrate to online
but !active CPUs during CPU_DOWN_PREPARE, so the only extra code
necessary for migrating back remaining workers when a CPU comes back
online is the code to actually do that.  That's only a couple tens of
lines of code in the trustee thread.

Now, the other option would to leave those unbound workers alone and
make sure they don't take up new works once new CPUs come online which
would require code in hotter path and results in less consistent
behavior.  The tradeoff seems pretty obvious to me.  Doesn't it?

Thanks.

-- 
tejun

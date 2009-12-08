Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZLHIlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZLHIlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbZLHIlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:41:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:39021 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZLHIlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:41:03 -0500
Message-ID: <4B1E1130.9050108@kernel.org>
Date: Tue, 08 Dec 2009 17:41:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop> <4B1CE1E8.2070803@kernel.org>
In-Reply-To: <4B1CE1E8.2070803@kernel.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/07/2009 08:07 PM, Tejun Heo wrote:
> On 12/07/2009 07:54 PM, Peter Zijlstra wrote:
>> So we seem to do cleanup_workqueue_thread() from CPU_POST_DEAD, but at
>> that time any thread that might still be around will most certainly not
>> be running on the offlined cpu anymore.
>>
>> If you really want to ensure you remain on the cpu, you have to complete
>> from CPU_DOWN_PREPARE.
>>
>> We're not running things from offline CPUs.
> 
> Oh, no, we're not doing that.  We can't do that.  What we're doing is
> to continue to process works which were queued on the now offline cpu
> unless it has been flushed/cancled from one of the cpu down
> notifications and the reason why we need to be able to fork after
> active is clear is to guarantee those flush/cancels don't deadlock.

Does my explanation justify the patch?

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZLHLzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZLHLzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZLHLzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:55:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:41413 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbZLHLzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:55:46 -0500
Message-ID: <4B1E3EE0.7030001@kernel.org>
Date: Tue, 08 Dec 2009 20:56:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>	 <1260268453.3935.1106.camel@laptop>  <4B1E378A.5050101@kernel.org> <1260272885.3935.1189.camel@laptop>
In-Reply-To: <1260272885.3935.1189.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2009 08:48 PM, Peter Zijlstra wrote:
> Why bother with that?
> 
> workqueue's CPU_POST_DEAD will flush the workqueue and destroy all
> threads under cpu_add_remove_lock, which excludes the cpu from coming
> back up before its fully destroyed.
> 
> So there's no remaining tasks to be migrated back.
> 
> Changing that semantics is not worthwhile.

It is worthwhile because the goal is to unify all worker pool
mechanisms.  So, slow_work or whatnot (scsi EHs, FS specific worker
pools, async workers used for parallel probing) will all be converted
to use workqueue instead and with that we can't afford to wait for all
works to flush to down a cpu.  All that's necessary to implement that
is migrating back the unbound workers which can be implemented as a
separate piece of code apart from regular operation.  It would even
benefit the current implementation as it makes cpu up/down operations
much more deterministic.

Thanks.

-- 
tejun

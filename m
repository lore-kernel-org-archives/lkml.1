Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbZJTN5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbZJTN5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 09:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbZJTN5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 09:57:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:42605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZJTN5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 09:57:32 -0400
Message-ID: <4ADDC1FC.8010903@kernel.org>
Date: Tue, 20 Oct 2009 22:58:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeff Mahoney <jeffm@suse.com>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <20091020061557.GE8550@elte.hu> <alpine.LSU.2.00.0910200820500.8582@wotan.suse.de> <20091020063555.GJ8550@elte.hu> <4ADDB640.4020707@suse.com> <20091020134308.GA3930@elte.hu> <4ADDC1C6.9090305@kernel.org>
In-Reply-To: <4ADDC1C6.9090305@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 20 Oct 2009 13:57:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course I forgot to actually cc.  Cc'ing and quoting whole body.
Sorry.

Tejun Heo wrote:
> Ingo Molnar wrote:
>> IA64 should be fixed really - we can get past the 64K of percpu data 
>> limit anytime we add a few more pages of per-cpu data to the kernel - 
>> the scheduler just happened to be the one to cross it this time.
> 
> Christoph (cc'd hi!) was talking about re-purposing one of reserved
> generic registers (for current or something, I don't remember the
> details) for percpu base and just getting the original one via percpu
> access.  With that we should be able to lift the limitation without
> much performance penalty.
> 
>> Saying that all static percpu data must be below 64K, which will only be 
>> noticed once IA64 gets its testing act together months after it's been 
>> created is silly. If you want to enforce such a limit make it testable 
>> in a _timely_ fashion. Or fix the limit really.
> 
> Yeah, the problem probably was that it only pushes the perpcu area
> very slightly over the limit depending on configuration so it's not
> too surprising that it didn't get reported for some time.  Also, the
> linker script thing is a sanity check which is intentionally put there
> to trigger when this happens so that it can be found out clearly
> during build time.
> 
> In the long term, it will be a good idea to lift that restriction.
> That said, I really don't think we should be adding NR_CPUS sized
> array to percpu area either.  Things like that quickly become very
> scary with N*1024 cpu configurations.


-- 
tejun

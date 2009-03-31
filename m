Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbZCaIIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbZCaIIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZCaIHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:07:37 -0400
Received: from mga07.intel.com ([143.182.124.22]:46321 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756077AbZCaIHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,451,1233561600"; 
   d="scan'208";a="126010809"
Message-ID: <49D1CF60.5020107@linux.intel.com>
Date: Tue, 31 Mar 2009 10:08:00 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <20090328120825.GB14464@elte.hu> <49D093F4.2080202@linux.intel.com> <49D183BA.5020007@jp.fujitsu.com>
In-Reply-To: <49D183BA.5020007@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Andi Kleen wrote:
>> To turn it off you would need to disable the CMCI enable bit
>> completely.
> 
> mce_threshold=0 discourages CMCI initialization.
> The CMCI enable bits are kept in off states in this case.

True, I missed that earlier. Still a different option would be better.


> 
>> However I expect that this will be not a good idea to ever use on Nehalem
>> class systems  at least because without CMCI the machine check code cannot
>> handle shared banks correctly and you'll get duplicated events from them.
>> And on non Nehalem systems there is no CMCI anyways, so it'll be always
>> off.
> 
> One question is that even if one clears record in a shared bank, others
> sharing the bank still can retrieve same record?  Or the duplication of
> recored only happens if a shared bank is polled by multiple cpu in parallel
> at same time?

Only when multiple CPUs poll (or machine check) at the same time.

> 
> So old kernel without CMCI support running on new Nehalem class system will
> make duplicated records, right?

Occasionally when it races yes.

> Doesn't it impact to current distro like RHEL5?

Yes, somewhat. The bigger problem there is actually lack of broadcast handling,
that often leads to incorrect reporting of fatal MCEs.

-Andi

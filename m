Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYKEByV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYKEByV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 20:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYKEByN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 20:54:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51619 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbYKEByN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 20:54:13 -0500
Message-ID: <4910FC18.50305@cn.fujitsu.com>
Date: Wed, 05 Nov 2008 09:51:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
References: <4910070C.8010807@cn.fujitsu.com> <20081104091556.GG23790@elte.hu>
In-Reply-To: <20081104091556.GG23790@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> this fix will increase about several hundred bytes to the kernel 
>> text for rcuclassic.
> 
> hm, why is that, and is it true for the full vmlinux as well, for a 
> reasonably large .config?
> 
> Do you get the size increase even if these two are enabled:
> 
>  CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>  CONFIG_OPTIMIZE_INLINING=y
> 
> ?

almost the same, a half of bytes added to kernel text is from this line:
EXPORT_SYMBOL_GPL(synchronize_sched);

> 
> i'd expect the opposite or same-size: given that an ugly 
> quasi-inlining macro is replaced with a shared, out of line function.
> 
> 	Ingo
> 
> 
> 




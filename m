Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbYKJDZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbYKJDZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 22:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYKJDZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 22:25:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49656 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbYKJDZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 22:25:37 -0500
Message-ID: <4917A8E7.8060801@cn.fujitsu.com>
Date: Mon, 10 Nov 2008 11:22:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
 V2
References: <49129310.5000903@cn.fujitsu.com> <20081109005159.GM6917@linux.vnet.ibm.com>
In-Reply-To: <20081109005159.GM6917@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Nov 06, 2008 at 02:47:44PM +0800, Lai Jiangshan wrote:
>> this fix remove ugly macro, and increase readability for rcupdate codes
>>
>> changed from v1:
>> use HAVE_SPECIAL_RCU_BH/SCHED instead of define duplicate version of
>> synchronize_sched().
> 
> Hello, Jiangshan!
> 
> I very much like getting rid of the ugly macro.  I of course like the
> kernel-doc fixes.  ;-)
> 
> I am not yet convinced of the HAVE_SPECIAL_RCU_BH and
> HAVE_SPECIAL_RCU_SCHED pieces.  It is not clear to me that this approach
> is simpler than the current approach of simply providing the appropriate
> definitions for the symbols in the implementation-specific rcuxxx.h
> file.
> 
> Am I missing something?
> 
> 							Thanx, Paul
> 

I think:

RCU_BH is not required, we can used RCU instead. so HAVE_SPECIAL_RCU_BH
will help for implementation which has not RCU_BH.

HAVE_SPECIAL_RCU_SCHED is a little different, RCU and RCU_SCHED are both
required for the kernel. But I think, in an implementation,
if rcu_read_lock_sched() implies rcu_read_lock(), we may not need implement
RCU_SCHED too(sometimes we may implement RCU_SCHED for performance).
so HAVE_SPECIAL_RCU_SCHED will help.

Thanx, Lai.



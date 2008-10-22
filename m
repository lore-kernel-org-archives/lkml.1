Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbYJVSj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbYJVSj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYJVSjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:39:20 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:29422 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJVSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:39:19 -0400
Message-ID: <48FF73C7.90709@colorfullife.com>
Date: Wed, 22 Oct 2008 20:41:11 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
References: <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com> <20081015011143.GE6874@linux.vnet.ibm.com> <48F5A638.8020003@colorfullife.com> <20081015152637.GA6739@linux.vnet.ibm.com>
In-Reply-To: <20081015152637.GA6739@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Only once per such CPU every grace period -- seems in the noise to me.
> But I should revisit, as I have changed things quite a bit since I
> made that decision many weeks ago.  ;-)
>
>   
Another small point:
Does your implementation support rcu_check_callbacks() with cpu != 
smp_processor_id()?
I don't think my locking would support it properly.
Thus:
- cpu != smp_processor_id() doesn't work.
- stack space for a useless parameter.
- the explicit cpu parameter prevents the rcu code from using get_cpu_var().

What about modifying the rcu_check_callbacks() prototype? I'd propose to 
remove the cpu parameter.

--
    Manfred

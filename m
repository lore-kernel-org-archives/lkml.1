Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYKNBGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYKNBGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYKNBG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:06:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYKNBGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:06:25 -0500
Message-ID: <491CCE58.1040701@cn.fujitsu.com>
Date: Fri, 14 Nov 2008 09:03:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       corbet@lwn.net
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
 V2
References: <49129310.5000903@cn.fujitsu.com> <20081109005159.GM6917@linux.vnet.ibm.com> <4917A8E7.8060801@cn.fujitsu.com> <20081110184520.GC6685@linux.vnet.ibm.com> <4918D7E4.9030107@cn.fujitsu.com> <20081111010331.GF6685@linux.vnet.ibm.com> <491B9581.2080201@cn.fujitsu.com> <20081113173114.GA6788@linux.vnet.ibm.com>
In-Reply-To: <20081113173114.GA6788@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Nov 13, 2008 at 10:48:33AM +0800, Lai Jiangshan wrote:
>> Hi, Paul,
>>
>> Could you add a RCU document about unloadable modules for kernel?
> 
> You thinking in terms of an ASCII version of
> http://lwn.net/Articles/217484/?
> 
> If so, please see attached patch and let me know what you think.
> Being too lazy to convert the cartoon to ASCII graphics, I simply
> left a URL to the .jpg on the LWN website.  Thus we need an ack/nack
> from Jon Corbet (CCed).

Hi, Paul

Thank you. it's a very good document.

I found several modules which need rcu_barrier(). So I'm going to
do some cleanup for them. A document for rcu_barrier() will help
these cleanup patches be accepted easily by maintainers.

Lai.

> 
> Of course, an alternative is to simply include the URL of the original
> LWN article in 00-INDEX.  Thoughts?
> 
> 							Thanx, Paul
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

> +The code for rcu_barrier() is as follows:
> +
> + 1 void rcu_barrier(void)
> + 2 {
> + 3   BUG_ON(in_interrupt());
> + 4   /* Take cpucontrol mutex to protect against CPU hotplug */
> + 5   mutex_lock(&rcu_barrier_mutex);
> + 6   init_completion(&rcu_barrier_completion);
> + 7   atomic_set(&rcu_barrier_cpu_count, 0);
> + 8   on_each_cpu(rcu_barrier_func, NULL, 0, 1);
> + 9   wait_for_completion(&rcu_barrier_completion);
> +10   mutex_unlock(&rcu_barrier_mutex);
> +11 }
> +

this is a little old.

> +
> +Quick Quiz #2: Why is there no rcu_barrier_bh()?
> +
> +Answer: Because no one has needed it yet. As soon as someone needs to
> +	use call_rcu_bh() from within an unloadable module, they will
> +	need an rcu_barrier_bh().
> +

add here.


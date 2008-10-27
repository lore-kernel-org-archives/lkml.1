Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYJ0No0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYJ0No0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYJ0NoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:44:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:40564 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYJ0NoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:44:17 -0400
Cc: David Miller <davem@davemloft.net>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       torvalds@osdl.org, maxk@qualcomm.com, tglx@linutronix.de
Message-Id: <8440180C-A3B1-4436-9CDF-C6BA9A01F8CD@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: benh@kernel.crashing.org
In-Reply-To: <1225002815.7654.487.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] genirq: Set initial default irq affinity to just CPU0
Date: Mon, 27 Oct 2008 08:43:11 -0500
References: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org> <20081024.161813.193686281.davem@davemloft.net> <1224970389.7654.473.camel@pasglop> <20081025.210412.206011121.davem@davemloft.net> <1225002815.7654.487.camel@pasglop>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 26, 2008, at 1:33 AM, Benjamin Herrenschmidt wrote:

> On Sat, 2008-10-25 at 21:04 -0700, David Miller wrote:
>> But back to my original wonder, since I've always tipped off of this
>> generic IRQ layer cpu mask, when was it ever defaulting to zero
>> and causing the behvaior your powerpc guys actually want? :-)
>
> Well, I'm not sure what Kumar wants. Most powerpc SMP setups actually
> want to spread interrupts to all CPUs, and those who can't tend to  
> just
> not implement set_affinity... So Kumar must have a special case of  
> MPIC
> usage here on FSL platforms.
>
> In any case, the platform limitations should be dealt with there or  
> the
> user could break it by manipulating affinity via /proc anyway.
>
> By yeah, I do expect default affinity to be all CPUs and in fact, I  
> even
> have an -OLD- comment in the code that says
>
> 	/* let the mpic know we want intrs. default affinitya is  
> 0xffffffff ...

While we have the comment the code appears not to really follow it.   
We appear to write 1 << hard_smp_processor_id().

- k

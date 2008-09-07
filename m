Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYIGLER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYIGLER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 07:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYIGLEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 07:04:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34743 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYIGLEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 07:04:04 -0400
Date: Sun, 7 Sep 2008 13:07:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org
Subject: Re: [RFC, PATCH] Add a CPU_STARTING notifier (was: Re: [PATCH, RFC] v4 scalable classic RCU implementation)
Message-ID: <20080907110729.GA26079@one.firstfloor.org>
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <48C3AA6A.3060402@colorfullife.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C3AA6A.3060402@colorfullife.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about introducing a CPU_STARTING notifier call, similar to CPU_DYING:
> - called with disabled interrupts
> - called before interrupts are enabled
> - must not sleep
> - called on the new cpu.
> 
> This might also be useful for something like kvm. I'm not sure if it's 
> guaranteed that hardware_enable() runs early enough.

I would find that useful too. I had several cases where i had 
to add smp_call_function_single() with a second callback to the CPU_UP 
notifier, which always seemed ugly.

-Andi
-- 
ak@linux.intel.com

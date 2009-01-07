Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbZAGOVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbZAGOVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZAGOUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:20:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:60207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZAGOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:20:54 -0500
Subject: Re: SMP timer issue
From: Peter Zijlstra <peterz@infradead.org>
To: melwyn lobo <linux.melwyn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <121039230901062108s7312343cwaf81feebfcf8d734@mail.gmail.com>
References: <121039230901062108s7312343cwaf81feebfcf8d734@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Jan 2009 15:20:51 +0100
Message-Id: <1231338051.11687.293.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 10:38 +0530, melwyn lobo wrote:
> Hello All,
> Following reply from Russell on the ARM mailing list, I have posted my
> question on this list.
> 
> We have ported the arm kernel 2.6.24 to ARM Cortex dual core
> processor. My question is regarding timer optimization.
> At present we have three timers for the two cores as follows;
> 1. MTU which provides the system tick and in the absence of local
> timers provides IPI_TIMER messages to other processors.
> 2. Localtimer for CPU0
> 3. Localtimer for CPU1
> 
> So presently (when local timers are enabled) there are 3 interrupts
> for every tick. I want to optimize the logic performed by MTU into the
> local timer of CPU0 so that this one serves as the system tick. Thus
> there would be no need for MTU interrupts and it would serve only as a
> clock source.
> 
> My question in particular:
> 1. Is there some platform which has already done this ?
> 2. Is this possible without modifying existing kernel framework?
> 3. How to update jiffies during boot when localtimer has not yet been setup?
> 
> Eagerly awaiting for some advice/comments.

There is plenty code in the hrtimer stuff to make the cpu local timers
(which I presume are used to implement hrtimer clockevents) do the
jiffie tick.

I've no idea how to hook all that up, but added some folks who might
know to the CC.

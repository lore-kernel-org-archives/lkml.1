Return-Path: <linux-kernel-owner+w=401wt.eu-S1760719AbYDYIbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760719AbYDYIbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbYDYIbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:31:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54043
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbYDYIa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:30:59 -0400
Date: Fri, 25 Apr 2008 01:30:59 -0700 (PDT)
Message-Id: <20080425.013059.252814513.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, tglx@linutronix.de
Subject: Re: [git pull] scheduler/misc fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209111858.7115.405.camel@twins>
References: <1209109710.7115.400.camel@twins>
	<20080425.005738.114887644.davem@davemloft.net>
	<1209111858.7115.405.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 25 Apr 2008 10:24:18 +0200

> FWIW I do think this is a valid 'bug' fix in that the called user func()
> can now see its from interrupt context. in_interrupt() would have
> reported false due to the missing irq_enter()/irq_exit() - not sure if
> any smp_call_function() relies on it though.

Understood.

I thought a bit and I remember that I did notice long ago that x86 did
these irq_enter() calls in SMP call function processing, but it seemed
like pure overhead at the time and wasn't actually needed.

Anyways, Peter can you give your state machine thing another shot?
Maybe it will help us see what is wrong either in the sparc64 code
or in the NOHZ/sched bits.


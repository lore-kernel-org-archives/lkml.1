Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbYCXOWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbYCXOWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYCXOWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 10:22:04 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:43838 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbYCXOWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:22:03 -0400
Subject: Re: [PATCH 2/2] time: xtime lock vs printk
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080324123922.087515000@chello.nl>
References: <20080324122424.671168000@chello.nl>
	 <20080324123922.087515000@chello.nl>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 07:21:55 -0700
Message-Id: <1206368515.10894.246.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-24 at 13:24 +0100, Peter Zijlstra wrote:
> -       printk(KERN_INFO "Time: %s clocksource has been installed.\n",
> +       /*
> +        * We're holding xtime lock and waking up klogd would deadlock
> +        * us on enqueue. Print without waking.
> +        */
> +       printk_nowakeup(KERN_INFO "Time: %s clocksource has been
> installed.\n",
>                clock->name);

It doesn't seem like there is a lot of potential for more xtime write
lock holders to do printk's .. We could just remove this line, or move
this printk into an __init ..

Daniel


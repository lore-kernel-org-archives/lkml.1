Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbYB1TVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbYB1TVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYB1TVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:21:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41689
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755022AbYB1TVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:21:42 -0500
Date: Thu, 28 Feb 2008 11:21:41 -0800 (PST)
Message-Id: <20080228.112141.261415906.davem@davemloft.net>
To: alexey.zaytsev@gmail.com
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Date: Thu, 28 Feb 2008 17:26:38 +0300

> commit d713f519332e029d43eca8462629314eee1ded86
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jan 25 21:07:58 2008 +0100
> 
>     sched: fix CONFIG_PRINT_TIME's reliance on sched_clock()
> 
>     Stefano Brivio reported weird printk timestamp behavior during
>     CPU frequency changes:
> 
>       http://bugzilla.kernel.org/show_bug.cgi?id=9475
> 
>     fix CONFIG_PRINT_TIME's reliance on sched_clock() and use cpu_clock()
>     instead.
> 
>     Reported-and-bisected-by: Stefano Brivio <stefano.brivio@polimi.it>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> which sound like "happy debugging, losers" to me. ;)
> 
> Anything else I can do?

FWIW, I've been seeing jumping printk timestamps ever since this
change on SMP sparc64 as well.  Especially on my Niagara boxes.

The timestamp base seem to be dependant upon which cpu prints the
message.  I guess the per-runqueue timestamps this new scheme is using
are all differently based.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbYBMNDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbYBMNDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYBMNDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:03:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51408
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761606AbYBMNDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:03:09 -0500
Date: Wed, 13 Feb 2008 05:03:40 -0800 (PST)
Message-Id: <20080213.050340.64342037.davem@davemloft.net>
To: mingo@elte.hu
Cc: rdreier@cisco.com, linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213125725.GC6344@elte.hu>
References: <adazlu5tlve.fsf@cisco.com>
	<20080212.230156.33759433.davem@davemloft.net>
	<20080213125725.GC6344@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 13 Feb 2008 13:57:25 +0100

> so .. how about the patch below? Note that we already had an "early 
> bootup" special (the rq->idle check), it's now just made explicit via 
> the scheduler_running flag.

I don't see what the problem is.

It is legal to access per-cpu data as early as you like,
it just evaluates to the static copy in the per-cpu section
of the kernel image until the per-cpu areas are setup.

rq->idle should also be zero this early as well, that's
also legal to rely upon

I see nothing illegal in what cpu_clock() is doing, that's
why I fixed the sparc64 per-cpu problem I ran into since
sparc64 was doing the wrong thing when booted on a non-zero
cpu.

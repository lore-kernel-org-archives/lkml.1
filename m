Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbXHQSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbXHQSyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 14:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXHQSyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 14:54:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756897AbXHQSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 14:54:19 -0400
Date: Fri, 17 Aug 2007 11:53:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: bunk@kernel.org, josh@kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] Make rcutorture RNG use temporal entropy
Message-Id: <20070817115356.cb201e42.akpm@linux-foundation.org>
In-Reply-To: <20070816024904.GA5312@linux.vnet.ibm.com>
References: <20070816024904.GA5312@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007 19:49:04 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Repost of http://lkml.org/lkml/2007/8/10/472 made available by request.
> 
> The locking used by get_random_bytes() can conflict with the
> preempt_disable() and synchronize_sched() form of RCU.  This patch changes
> rcutorture's RNG to gather entropy from the new cpu_clock() interface
> (relying on interrupts, preemption, daemons, and rcutorture's reader
> thread's rock-bottom scheduling priority to provide useful entropy),
> and also adds and EXPORT_SYMBOL_GPL() to make that interface available
> to GPLed kernel modules such as rcutorture.
> 
> Passes several hours of rcutorture.

Please explain what "conflict with" means so that I can work out if
this is a needed-in-2.6.23 change, thanks.

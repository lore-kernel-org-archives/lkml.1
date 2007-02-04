Return-Path: <linux-kernel-owner+w=401wt.eu-S1752236AbXBDKSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752236AbXBDKSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 05:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXBDKSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 05:18:45 -0500
Received: from gockel.physik3.uni-rostock.de ([139.30.44.16]:14829 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbXBDKSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 05:18:44 -0500
Date: Sun, 4 Feb 2007 11:18:43 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] kernel/time/clocksource.c needs struct task_struct on
 m68k
In-Reply-To: <20070204062211.GA10674@Krystal>
Message-ID: <Pine.LNX.4.63.0702041112560.8256@gockel.physik3.uni-rostock.de>
References: <20070204062211.GA10674@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007, Mathieu Desnoyers wrote:

> kernel/time/clocksource.c needs struct task_struct on m68k.
> 
> Because it uses spin_unlock_irq(), which, on m68k, uses hardirq_count(), which
> uses preempt_count(), which needs to dereference struct task_struct, we
> have to include sched.h. Because it would cause a loop inclusion, we
> cannot include sched.h in any other of asm-m68k/system.h,
> linux/thread_info.h, linux/hardirq.h, which leaves this ugly include in
> a C file as the only simple solution.

This indeed sounds quite ugly. If there really is no other simple way to 
resolve this, this case seems to provide the missing incentive to create a 
task_struct.h header file.

Unfortunately, I currently cannot foresee when I will have time to do so.

Tim

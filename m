Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbXJEQml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbXJEQml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXJEQmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:42:32 -0400
Received: from www.tglx.de ([62.245.132.106]:38096 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbXJEQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:42:31 -0400
Date: Fri, 5 Oct 2007 18:41:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.hu, rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] RT: Optionally allow IRQF_NODELAY on serial
 console
In-Reply-To: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
Message-ID: <alpine.LRH.0.999.0710051831000.10191@www.tglx.de>
References: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Gregory Haskins wrote:
> This series may help debugging certain circumstances where the serial
> console is unreponsive (e.g. RT51+ spinner, or scheduler problem).  It changes
> the serial8250 driver to use IRQF_NODELAY so that interrupts execute in irq
> context instead of a kthread.
> 
> It works pretty well on this end, though it is admitted not fully baked.  For
> instance, a few paths in sysrq can still call into non-raw spinlocks
> (sched_debug_show, for instance) which will cause subsequent errors.  Also,
> if you use KDB, be sure to convert the kdb_printf_lock to raw as well.  I may
> send a KDB related patch seperately.
> 
> I am sending this out now in case it is helpful to someone.

The simple non-patch solution is to up the priority of the serial 
console irq to maximum. That's usually sufficient to catch runnaway tasks 
etc. It does not interfere with the system in normal operation as long as 
you do not hit keys in your minicom.

I doubt that your patch has a chance to survive lockdep and anything which 
is not a sysrq.

	tglx

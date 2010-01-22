Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885Ab0AVWA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0AVWA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880Ab0AVWAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 17:00:23 -0500
Received: from www.tglx.de ([62.245.132.106]:44803 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872Ab0AVWAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 17:00:22 -0500
Date: Fri, 22 Jan 2010 23:00:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ivan Novick <novickivan@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: sys_rt_sigreturn calling sys_futex?
In-Reply-To: <619ad6271001221346j19c9038bx8013e5b560d0c138@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001222257480.2906@localhost.localdomain>
References: <619ad6271001221346j19c9038bx8013e5b560d0c138@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010, Ivan Novick wrote:
> Hello,
> 
> I have a userspace app that I profiled using SystemTap.
> 
> It says there are frequent calls to sys_futex which come from sys_rt_sigreturn.
> 
> It is true, that my app has many signal handler calls due to
> frequently set timers in the code.
> 
> I had a look at the source for my kernel: Suse: linux-2.6.27.39-0.3
> but I don't see any calls to futex from inside sys_rt_sigreturn.
> 
> Do you know if sys_rt_sigreturn is somehow calling sys_futex?

Well, it is not calling sys_futex, it is resuming the sys_futex
syscall which was interrupted by the signal. When the signal handler
returns it returns to the system call automatically.
 
Thanks,

	tglx

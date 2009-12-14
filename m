Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbZLNU0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbZLNU0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbZLNU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:26:09 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38481 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbZLNU0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:26:06 -0500
Date: Mon, 14 Dec 2009 12:25:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: RCU detected CPU 0 stall after panic on sparc64
Message-ID: <20091214202556.GC6679@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.SOC.1.00.0912121049030.26625@math.ut.ee> <20091212.014002.173528710.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212.014002.173528710.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 01:40:02AM -0800, David Miller wrote:
> From: Meelis Roos <mroos@linux.ee>
> Date: Sat, 12 Dec 2009 10:54:19 +0200 (EET)
> 
> > I tried 2.6.32 git gaad3bf0 on a SMP sparc64 machine (Ultra Enterprise 
> > 250). For some reason my disks were not found (not important in this 
> > bugreport) and this resulted in panic (cannnot mount root). However, the 
> > machine kept going and got the below messages (RCU detected CPU 0 stall 
> > (t=1000 jiffies)) from timer interrupts.
> > 
> > This seems to be like a bug in RCU vs panic.
> 
> It's normal actually.  A panic() just loops forever and the cpu never
> goes through an RCU grace period again as a result, and this triggers
> the debugging timer that detects this condition.
> 
> Probably the panic() code should disable that assertion check.

Hmmm...  At first glance, it looks like RCU should put a notifier onto
the panic_notifier_list to disable this check.  Or is there some global
variable that I can check?

							Thanx, Paul

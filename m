Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYBIOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYBIOH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 09:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYBIOHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 09:07:16 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53895 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYBIOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 09:07:14 -0500
Date: Sat, 9 Feb 2008 06:07:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: preempt rcu bug on s390
Message-ID: <20080209140711.GA16205@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080209113435.GA6915@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209113435.GA6915@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 12:34:35PM +0100, Heiko Carstens wrote:
> Using CONFIG_PREEMPT_RCU and CONFIG_NO_IDLE_HZ on s390 my system always
> gets stuck when running with more than one cpu.
> When booting with four cpus I get all four cpus caught withing cpu_idle
> and not advancing anymore. However there is the init process which is
> waitung for synchronize_rcu() to complete (lcrash output):
> 
> STACK TRACE FOR TASK: 0xf84d968 (swapper)
> 
>  STACK:
>  0 schedule+842 [0x36c956]
>  1 schedule_timeout+172 [0x36d0e4]
>  2 wait_for_common+204 [0x36c398]
>  3 synchronize_rcu+76 [0x567bc]
>  4 netlink_change_ngroups+150 [0x2b4302]
>  5 genl_register_mc_group+256 [0x2b6174]
>  6 genl_init+188 [0x534e44]
>  7 kernel_init+444 [0x518334]
>  8 kernel_thread_starter+6 [0x192a6]
> 
> If I change the code so that timer ticks won't be disabled everything
> runs fine. So my guess is that rcu_needs_cpu() doesn't do the right
> thing for the rcu preemptible case.
> 
> Kernel version is git head of today.
> 
> Any ideas?

Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?

If not, could you please check it out?

						Thanx, Paul

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763602AbXFKBUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763602AbXFKBUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 21:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760073AbXFKBT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 21:19:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60199 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759038AbXFKBT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 21:19:58 -0400
Date: Sun, 10 Jun 2007 18:19:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070611011954.GG27982@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070609210507.GA29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070609210507.GA29194@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 11:05:07PM +0200, Ingo Molnar wrote:
> 
> i'm pleased to announce the v2.6.21.4-rt11 kernel, which can be 
> downloaded from the usual place:
> 
>      http://people.redhat.com/mingo/realtime-preempt/
>   
> more info about the -rt patchset can be found in the RT wiki:
>    
>      http://rt.wiki.kernel.org
> 
> -rt11 is a bit more experimental than usual: it includes the CFS 
> scheduler. Several people have suggested the inclusion of CFS into the 
> -rt tree: the determinism of the CFS scheduler is a nice match to the 
> determinism offered by PREEMPT_RT. The port of CFS to -rt was done by 
> Dinakar Guniguntala. Tested on i686 and x86_64.
> 
> to build a 2.6.21.4-rt11 tree, the following patches should be applied:
>   
>     http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.4.tar.bz2
>     http://people.redhat.com/mingo/realtime-preempt/patch-2.6.21.4-rt11

2.6.21.4-rt12 boots on 4-CPU Opteron and passes several hours of
rcutorture.  However, if I simply do "modprobe rcutorture", the kernel
threads do not spread across the CPUs as I would expect them to, even
given CFS.  Instead, the readers all stack up on a single CPU, and I
have to use the "taskset" command to spread them out manually.  Is there
some config parameter I am missing out on?

						Thanx, Paul

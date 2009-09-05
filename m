Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbZIEUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbZIEUBq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 16:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZIEUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 16:01:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36117 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbZIEUBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 16:01:44 -0400
Date: Sat, 5 Sep 2009 13:01:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: RCU Kconfig help text
Message-ID: <20090905200145.GB7181@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <12924.1252157230@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12924.1252157230@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 09:27:10AM -0400, Valdis.Kletnieks@vt.edu wrote:
> init/Kconfig says:
> 
> "choice
>         prompt "RCU Implementation"
>         default TREE_RCU
> 
> config TREE_RCU
>         bool "Tree-based hierarchical RCU"
>         help
>           This option selects the RCU implementation that is
>           designed for very large SMP system with hundreds or
>           thousands of CPUs.  It also scales down nicely to
>           smaller systems.
> 
> config TREE_PREEMPT_RCU
>         bool "Preemptable tree-based hierarchical RCU"
>         depends on PREEMPT
>         help
>           This option selects the RCU implementation that is
>           designed for very large SMP systems with hundreds or
>           thousands of CPUs, but for which real-time response
>           is also required.
> 
> endchoice"
> 
> This leaves somebody who has a laptop wondering which choice is best for
> a system with only one or two cores that has CONFIG_PREEMPT defined. One
> choice says it scales down nicely, the other explicitly has a 'depends on
> PREEMPT' attached to it...
> 
> (Yes, I realize in practice, the RCU sections on a laptop are probably usually
> so short they don't matter in practice.  I finally concluded TREE_PREEMPT was
> apparently a rename of CONFIG_PREEMPT_RCU and went with that since that was
> working for me before...)

Good point -- I will add the "It also scales down nicely to smaller
systems" to TREE_PREEMPT_RCU.

For -really- small systems, TINY_RCU will hopefully be there at some
point, but it can only handle single-CPU systems.

							Thanx, Paul

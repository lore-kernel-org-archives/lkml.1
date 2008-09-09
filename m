Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYIIPHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYIIPHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYIIPHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:07:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55586 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbYIIPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:07:20 -0400
Date: Tue, 9 Sep 2008 07:54:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org, manfred@colorfullife.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] prevent sparc64 from invoking irq handlers on offline
	CPUs
Message-ID: <20080909145453.GA6711@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080903004211.GD6748@linux.vnet.ibm.com> <20080903.022138.31681256.davem@davemloft.net> <20080903154217.GA6807@linux.vnet.ibm.com> <20080908.171708.43575256.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908.171708.43575256.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 05:17:08PM -0700, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Wed, 3 Sep 2008 08:42:17 -0700
> > o	Timer irqs.  Not sure what happens to add_timer() calls from
> > 	a CPU that is going offline.  The hope would be that they get
> > 	queued to some other CPU?
> 
> This case is interesting, and I'm no sure what happens here.

It turns out that there is a timer_cpu_modifier() that invokes
migrate_timers() upon CPU_DEAD or CPU_DEAD_FROZEN.  And migrate_timers()
looks like it does what its name says.  And I believe that CPU_DEAD
happens after sparc64's local_irq_enable() window, so we should be OK.

							Thanx, Paul

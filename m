Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbYCDU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbYCDU4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763208AbYCDUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:55:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762839AbYCDUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:55:45 -0500
Date: Tue, 4 Mar 2008 15:55:42 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ego@in.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, zippel@linux-m68k.org
Subject: Re: [PATCH] move PREEMPT_RCU config option back under PREEMPT
In-Reply-To: <20080304202207.GA10926@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0803041553240.11062@gandalf.stny.rr.com>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
 <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0802291330590.2723@scrub.home> <20080301193903.GC15887@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0803020404040.2723@scrub.home> <20080303185511.GE12453@linux.vnet.ibm.com>
 <20080304202207.GA10926@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Mar 2008, Paul E. McKenney wrote:
>
> The original preemptible-RCU patch put the choice between classic and
> preemptible RCU into kernel/Kconfig.preempt, which resulted in build
> failures on machines not supporting CONFIG_PREEMPT.  This choice was
> therefore moved to init/Kconfig, which worked, but placed the choice
> between classic and preemptible RCU at the top level, a very obtuse choice
> indeed.  This patch changes from the Kconfig "choice" mechanism to a pair
> of booleans, only one of which (CONFIG_PREEMPT_RCU) is user-visible,
> and is located in kernel/Kconfig.preempt, where one would expect it
> to be.  The other (CONFIG_CLASSIC_RCU) is in init/Kconfig so that it
> is available to all architectures, hopefully avoiding build breakage.
> Thanks to Roman Zippel for suggesting this approach.
>
> I have tested this, but sadly do not have access to a machine that does
> not support CONFIG_PREEMPT.  However, I did edit my config in an attempt
> to simulate this situation.

One minor comment, but otherwise:

Acked-by: Steven Rostedt <srostedt@redhat.com>

>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


>  config CLASSIC_RCU
> -	bool "Classic RCU"
> +	def_bool !PREEMPT_RCU
>  	help
>  	  This option selects the classic RCU implementation that is
>  	  designed for best read-side performance on non-realtime
> -	  systems.
> -
> -	  Say Y if you are unsure.
> -

You can get rid of the "help" part since it isn't visible to users.

-- Steve


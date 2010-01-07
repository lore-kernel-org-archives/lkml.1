Return-Path: <linux-kernel-owner+w=401wt.eu-S932715Ab0AGIc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab0AGIc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 03:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562Ab0AGIc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 03:32:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:57024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab0AGIc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 03:32:57 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100107050248.GA6803@linux.vnet.ibm.com>
References: <20100107044007.GA22863@Krystal>
	 <20100107050248.GA6803@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 09:32:16 +0100
Message-ID: <1262853136.4049.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 21:02 -0800, Paul E. McKenney wrote:
> 
> Beats the heck out of user-mode signal handlers!!!  And it is hard
> to imagine groveling through runqueues ever being a win, even on very
> large systems.  The only reasonable optimization I can imagine is to
> turn this into a no-op for a single-threaded process, but there are
> other ways to do that optimization.
> 
> Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Then imagine someone doing:

 while (1)
  sys_membarrier();

on your multi node machine, see how happy you are then.


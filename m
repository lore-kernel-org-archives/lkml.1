Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936Ab0ACQsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0ACQsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 11:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865Ab0ACQsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 11:48:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56263 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab0ACQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 11:48:29 -0500
Date: Sun, 3 Jan 2010 16:44:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hui Zhu <teawater@gmail.com>
Cc: saeed bishara <saeed.bishara@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Nicolas Pitre <nico@fluxnic.net>, Ralf Baechle <ralf@linux-mips.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>,
       Chris Dearman <chris@mips.com>,
       Paul Gortmaker <Paul.Gortmaker@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Coly Li <coly.li@suse.de>
Subject: Re: [PATCH] stack2core: show stack message and convert it to core
	file when kernel die
Message-ID: <20100103164414.GB21156@n2100.arm.linux.org.uk>
References: <daef60381001030705r93b3fbfkc50e7b9bbc62b334@mail.gmail.com> <20100103160313.GA21156@n2100.arm.linux.org.uk> <daef60381001030830u176c0cfavbb31358a2b42ed60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daef60381001030830u176c0cfavbb31358a2b42ed60@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 12:30:20AM +0800, Hui Zhu wrote:
> This S2C: message just for program s2c.
> s2c can convert it to a core file.  Then gdb can do a clear analyse
> with this file.
> Then you can get more message than current we can get.

I understand that.  What I'm saying is that all the additional noise
you're causing the kernel to create is just a pure duplication of
what we already dump.

Oops dumps are already noisy enough - especially if they cause a panic
at the end (where you end up with two backtraces.)  We do not need even
more noise caused by needless duplication.

You can get everything you need already from the kernel.  On ARM, we
already dump out all the registers and the _full_ stack.  There is no
need for you to implement your own register dumping code and full stack
dump on top of that again.

So, I'm not going to accept your patch for the ARM kernel.  Please use
what's already provided - it's more than adequate.  By doing so, you
don't penalise those of us who want to read the raw oopses.

Talking about noisy oopses, I'm getting one with 2.6.33-rc2 on 'poweroff'
shutdown.  No idea what it is because most of it's scrolled off the top of
the screen and I can't scroll back.  Not bothered about it at the moment.
What it does illustrate though is why making things too noisy when problems
occur makes it _more_ difficult to find out what went wrong.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763216AbZFPWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763216AbZFPWo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbZFPWoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:44:19 -0400
Received: from bar.sig21.net ([80.81.252.164]:60103 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbZFPWoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:44:18 -0400
Date: Wed, 17 Jun 2009 00:44:31 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: venkatesh.pallipadi@intel.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       davej@redhat.com, pavel@ucw.cz, linux-acpi@vger.kernel.org,
       lenb@kernel.org, arjan@infradead.org, tglx@linutronix.de
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Message-ID: <20090616224431.GA14186@sig21.net>
References: <20090615232709.GA6059@sig21.net> <200906160216.29537.rjw@sisk.pl> <20090616142217.GA5548@sig21.net> <20090616115540.ceb67a30.akpm@linux-foundation.org> <20090616195750.GA12814@sig21.net> <20090616202558.GA5423@linux-os.sc.intel.com> <20090616204039.GA13399@sig21.net> <20090616140923.eb3ae6e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616140923.eb3ae6e3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.831,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 02:09:23PM -0700, Andrew Morton wrote:
> 
> Right, so it's the suspend-must-disable-local-interrupts thing.  Again.
>  create_image()'s local_irq_disable().
> 
> It was wrong to call work_on_cpu() with lcoal interrupts disabled, and
> it's now wrong to call smp_call_function_single() with local interrupts
> disabled.  It's just that smp_call_function_single() warns while
> work_on_cpu() didn't.
> 
> That all explains the warning But afaik we still don't know why your
> machine actually failed.  Perhaps it is a side-efect of emitting the
> warning when the console is in a weird state?

smp_call_function_single() enables irqs and hibernate doesn't like that?

BTW, I have no other UP machine to test with, but I reported
in another thread that a !SMP kernel (or a SMP kernel
with maxcpus=0 parameter) does not boot at all on
my destop machine, see
http://lkml.org/lkml/2009/6/12/468

No idea if I should be worried about this since the
SMP kernel now works fine, another hibernate problem
was solved in
http://lkml.org/lkml/2009/6/14/156


Johannes

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbYHKMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbYHKMN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYHKMNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:13:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35655 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYHKMNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:13:18 -0400
Date: Mon, 11 Aug 2008 14:14:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811121422.GQ9038@one.firstfloor.org>
References: <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <87zlnj24qc.fsf@basil.nowhere.org> <1218453726.10800.63.camel@twins> <20080811120231.GC23529@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811120231.GC23529@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's a rather misleading argument, because klogd as it stands today is 
> already lossy: you can overflow it with enough printk data. (It's rather 

That's true, but with at least the timer tick version it would become much 
worse I think, because there would be a rather low upper limit on
the maximum frequency of klogd wakeups.

Not fully sure about the RCU version, i guess it would depend on 
how many CPUs you have (but that one had the problem of
"cannot put printks into RCU anymore")

BTW if you only care about the console you can always use early_printk()
at least for serial/vga/usb debug on x86 -- it will never lose anything (at 
least as long as you can read the output fast enough) and also
works in nearly any context. But of course since it also doesn't
log anything to klogd it's probably not a good idea outside debugging.

-Andi

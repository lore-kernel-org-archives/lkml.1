Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXIPQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXIPQki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 12:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXIPQkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 12:40:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10576 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXIPQka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 12:40:30 -0400
Date: Sun, 16 Sep 2007 09:40:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
Message-Id: <20070916094001.d87ed0f0.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
	<alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
	<20070915183412.GA14501@one.firstfloor.org>
	<46EC2702.3090000@oracle.com>
	<alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
	<46EC6F2A.5090008@oracle.com>
	<alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 17:34:54 -0700 (PDT) Linus Torvalds wrote:

> 
> 
> On Sat, 15 Sep 2007, Randy Dunlap wrote:
> > Command: ./crashme +2000 666 1000 1:00:00 1
> 
> Ok, that's close to what I was testing (one of the examples from the 
> crashme docs).
> 
> > > The original gjc crashme doesn't even do a "mprotect(PROT_EXEC)" by default
> > > (nor does it even compile on a modern unix), so it's not going to do
> > > anything. I hacked it up, and it appears to work ok for me, but I'm not at
> > > all confident that I'm even close to recreating what you are doing.
> > 
> > So I'm missing some mprotect() call also?
> > Oops.
> 
> Yeah, by default, it won't do a mprotect(), so as far as I can tell, 
> you're always going to hit NX on a writable data page. I'm running with 
> the appended patch.

I'll apply this patch today, but I haven't done so yet (for the 2
bug reports below).  Then I'll back up more, prior to 2.6.22 (which
got the Huh? message and kept going).

> That said, I didn't actually *check* that the mprotect makes any 
> difference, and maybe you have one of the early EM64T chips that didn't 
> have NX support at all. Or maybe it's dodgy, and is actually the whole 
> *reason* for the page fault problem..

It's a bit old.  I wouldn't be surprised if it doesn't support NX.

> I don't have any P4's capable of 64-bit operation (nor do I really want 
> any ;)

ack that.


~~~~~~~~~~~~~~~~~~~~~~~ 2.6.23-rc3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[21769.161490] Unable to handle kernel paging request at 00000000ff016abe RIP:
[21769.166119]  [<000000000050522f>]
[21769.171912] PGD d5572067 PUD 0
[21769.175100] Oops: 0000 [1] SMP
[21769.178278] CPU 3
[21769.180312] Modules linked in: loop
[21769.183830] Pid: 8823, comm: crashme Not tainted 2.6.23-rc3 #1
[21769.189657] RIP: 0033:[<000000000050522f>]  [<000000000050522f>]
[21769.195684] RSP: 002b:00007fffe9528118  EFLAGS: 00010202
[21769.200993] RAX: 00000000c169bc00 RBX: 0000000000000000 RCX: 00002b88c172eb37
[21769.208121] RDX: 00000000005051e0 RSI: 0000000000000000 RDI: 000000000000000a
[21769.215249] RBP: 00007fffe9528120 R08: 00007fffe9528070 R09: 0000000000000000
[21769.222377] R10: 0000000000000008 R11: 0000000000000216 R12: 0000000000000000
[21769.229505] R13: 00007fffe9528310 R14: 0000000000000000 R15: 0000000000000000
[21769.236632] FS:  00002b88c18cd6d0(0000) GS:ffff81011fc751c0(0000) knlGS:0000000000000000
[21769.244711] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[21769.250453] CR2: 00000000ff016abe CR3: 00000000d792f000 CR4: 00000000000006e0
[21769.257581] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[21769.264709] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[21769.271837] Process crashme (pid: 8823, threadinfo ffff8100d5656000, task ffff81011ffff810)
[21769.280175]
[21769.281673] RIP  [<000000000050522f>]
[21769.285355]  RSP <00007fffe9528118>
[21769.288845] CR2: 00000000ff016abe
[21769.292455] Kernel panic - not syncing: Fatal exception
[21769.297699] Rebooting in 30 seconds..

~~~~~~~~~~~~~~~~~~~~~~~~~~~ 2.6.22 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Sep 15 17:15:03 caor-test8 kernel: [18447.172949] kernel mode page fault from user space? Huh?  
Sep 15 17:15:03 caor-test8 kernel: [18447.178268] 
Sep 15 17:15:03 caor-test8 kernel: [18447.179773] Modules linked in: loop
Sep 15 17:15:03 caor-test8 kernel: [18447.183306] Pid: 30819, comm: crashme Not tainted 2.6.22 #2 
Sep 15 17:15:03 caor-test8 kernel: [18447.183311] RIP: 0033:[<0000000000507163>]  [<0000000000507163>]
Sep 15 17:15:03 caor-test8 kernel: [18447.183318] RSP: 002b:00007fff10da99b0  EFLAGS: 00010202  
Sep 15 17:15:03 caor-test8 kernel: [18447.183320] RAX: 0000000000000000 RBX: 00002b4b99e18c00 RCX: 00002b4b99eabb37
Sep 15 17:15:03 caor-test8 kernel: [18447.183323] RDX: 0000000000507160 RSI: 0000000000401476 RDI: 000000000000000a
Sep 15 17:15:03 caor-test8 kernel: [18447.183326] RBP: 00007fff10da99b0 R08: 00007fff10da9900 R09: 0000000000000000
Sep 15 17:15:03 caor-test8 kernel: [18447.183328] R10: 0000000000000008 R11: 0000000000000212 R12: 0000000000000000
Sep 15 17:15:03 caor-test8 kernel: [18447.183330] R13: 00007fff10da9ba0 R14: 0000000000000000 R15: 0000000000000000
Sep 15 17:15:03 caor-test8 kernel: [18447.183333] FS:  00002b4b9a04a6d0(0000) GS:ffffffff80721000(0000) knlGS:0000000000000000
Sep 15 17:15:03 caor-test8 kernel: [18447.183336] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Sep 15 17:15:03 caor-test8 kernel: [18447.183339] CR2: 00000000ff019fd5 CR3: 00000000cacb0000 CR4: 00000000000006e0

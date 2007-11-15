Return-Path: <linux-kernel-owner+w=401wt.eu-S1765004AbXKOSln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765004AbXKOSln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbXKOSl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:41:28 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:43850 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765981AbXKOSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:41:26 -0500
Subject: 2.6.24-rc2-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Daniel Walker <dwalker@mvista.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 13:40:30 -0500
Message-Id: <1195152030.13982.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Finally!

We are pleased to announce 2.6.24-rc2-rt1.

This is probably one of the toughest ports the -rt patch had to face. It
was definitely the toughest one I had to perform.  With a 50 Meg
difference between 2.6.23 and 2.6.24-rc2 it caused a lot of problems
with conflicts. The 2.6.23.1-rt11 patch consisted of 386 patches. Of
them 25 of them were incorporated into mainline (mostly hrtimers for
x86_64 and other archs).

With fixes and such, the 2.6.24-rc2-rt1 has  370 patches. 361 of them
came from 2.6.23.1-rt11 and of those 129 had conflicts.  Some conflicts
were trivial, but a lot of them were not. In order to allow others to
audit my changes I have archived the .rej reject files as well as the
quilt .pc files and original patch.

http://rostedt.homelinux.com/rt/pre/2.6.24-rc2-rt1-pre1-rejs/

This holds a list of tar balls that contain the necessary files to get
to the state before I preformed the "quilt refresh".

For example: to fix the patch preempt-realtime-mips.patch

rostedt@gandalf:~$ mkdir bah
rostedt@gandalf:~$ cd bah
rostedt@gandalf:~/bah$ ketchup -r -G 2.6.24-rc2
None -> 2.6.24-rc2
Unpacking linux-2.6.23.tar.bz2
Applying patch-2.6.24-rc2.bz2
Current directory renamed to /home/rostedt/linux-2.6.24-rc2
rostedt@gandalf:~/bah$ cd .
rostedt@gandalf:~/linux-2.6.24-rc2$ 
rostedt@gandalf:~/linux-2.6.24-rc2$ wget http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.24-rc2-rt1-broken-out.tar.bz2
rostedt@gandalf:~/linux-2.6.24-rc2$ tar -xf patch-2.6.24-rc2-rt1-broken-out.tar.bz2
rostedt@gandalf:~/linux-2.6.24-rc2$ quilt push preempt-realtime-mips.patch
[...]
rostedt@gandalf:~/linux-2.6.24-rc2$ wget http://rostedt.homelinux.com/rt/pre/2.6.24-rc2-rt1-pre1-rejs/preempt-realtime-mips.patch.tar.bz2
[...]
rostedt@gandalf:~/linux-2.6.24-rc2$ tar -xf preempt-realtime-mips.patch.tar.bz2 
rostedt@gandalf:~/linux-2.6.24-rc2$ find . -name '*.rej'
./arch/mips/kernel/i8259.c.rej
./arch/mips/kernel/smp.c.rej
./arch/mips/kernel/process.c.rej
./arch/mips/kernel/time.c.rej
./arch/mips/kernel/traps.c.rej
./arch/mips/sibyte/sb1250/irq.c.rej
./arch/mips/sibyte/sb1250/smp.c.rej
./arch/mips/sibyte/swarm/setup.c.rej
./include/asm-mips/hw_irq.h.rej
./include/asm-mips/i8259.h.rej
./include/asm-mips/linkage.h.rej
./include/asm-mips/semaphore.h.rej
./include/asm-mips/time.h.rej


And now I'm in the position before I did the "quilt refresh" against the
preempt-realtime-mips.patch. Others can do this too, and see where I
might have messed up the conflicts. Note, doing a "quilt pop -f" now
will remove the patch as I resolved it, and doing a "quilt push -f" will
put you to the position before I did the patch.

Note, I may have messed up by running a "quilt refresh" before running
the reject archive script. If that's the case (the saved patch will be
the resolved patch, not the original), simply take the patch from the
patch-2.6.23.1-rt11-broken-out.tar.bz2 and use that as the original.

I've tested this on x86_64 both SMP and UP, as well as SMP on i386. I'm
pretty sure that the other archs may be broken (arm, mips and powerpc).


Because this was such a big change, there is probably a bit of
regression bugs that might have crept in. So please test and report your
findings.

Special thanks goes to Paul E. Mckenney (for pointing me to the wrong
bug, that happened to sit right next to the correct one ;-), as well as
Peter Zijlstra and Daniel Walker for helping me debug the initial ports.

Changes since 2.6.23.1-rt11

  - Port to 2.6.24-rc2

  - latency tracer bootmem allocate (Yanmin Zhang)

  - removed Gregory Haskins patch 8 (will probably be back in -rt2)
     This was due to some initial porting problems. But the fixes
     came too late in the testing period. (he decided cleaning his
     garage was more important than working on this kernel.;-)

to build a 2.6.24-rc2-rt1 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2
  http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.24-rc2.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.24-rc2-rt1.gz


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt1

The broken out patches are also available.

Thanks!

-- Steve




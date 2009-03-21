Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZCUNEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZCUNEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 09:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZCUNEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 09:04:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:47082 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZCUNEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 09:04:07 -0400
Date: Sat, 21 Mar 2009 13:03:53 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Nico Schottelius <nico-linux-20090313@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: Strange reboots on 2.6.29-rc6-wl
Message-ID: <20090321130353.GA5009@silver.sucs.org>
References: <20090313200657.GA4907@denkbrett.schottelius.org> <20090313204100.GA3554@tuxdriver.com> <20090317075424.GD8777@denkbrett.schottelius.org> <20090317145753.GA1651@silver.sucs.org> <20090320102107.GA17975@denkbrett.schottelius.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320102107.GA17975@denkbrett.schottelius.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 11:21:07AM +0100, Nico -telmich- Schottelius wrote:
> Sitsofe Wheeler [Tue, Mar 17, 2009 at 02:57:53PM +0000]:
> > On Tue, Mar 17, 2009 at 08:54:24AM +0100, Nico -telmich- Schottelius wrote:
> > > 
> > > Has anyone a clue on howto debug the build environment or
> > > debugging the kernel before it's getting booted?
> > 
> > If you have a serial console you can probably get output on that.
> 
> There's no native serial port on the machine :-/
> 
> > If you have flipped EMBEDDED to Y then you might also have to enable
> > EARLY_PRINTK. Another trick might be to turn set
> > BOOT_PRINTK_DELAY (Kernel hacking -> Delay each boot printk message by N
> > milliseconds) to something like 2000 and see if you can read/catch the
> > messages before the kernel reboots...
> 
> I've EARLY_PRINTK set, but other than the edd probing message
> I don't see anything.

What about when you set BOOT_PRINTK_DELAY to a value high enough to
cause pauses - do you see more messages? Additionally are booting your
kernel without the quiet option? Have you checked to make sure the
kernel isn't set to reboot on oops/panic etc? Are you using any binary
drivers?

> > Failing that start a git bisection (
> > http://www.kernel.org/doc/local/git-quick.html#bisect or
> > http://www.stardust.webpages.pl/files/handbook/handbook-en-0.3-rc1.pdf )
> > from the last good kernel...
> 
> I really don't think that it's the kernel's fault, because _all_
> new versions I compile instantly reboot.

So even a freshly compiled 2.6.27 and 2.6.28 reboot instantly?! If even
old kernels that worked suddently don't work that hints strongly at
hardware errors or a duff compiler toolchain...

You can also make the kernel spit out decompression error messages by
enabling CONFIG_X86_VERBOSE_BOOTUP . I guess it would also be wise to
make sure CONFIG_DOUBLEFAULT is also set. Are you sure nothing else has
changed though? Have you enabled some kernel option that was not set
before?  Have you changed any BIOS settings recently?

> Last one I tried was v2.6.29-rc8-241-g65c2449 (linux-2.6).
> Isn't there some flag to enable step by step execution (like in gdb)?

I don't think I undrstand what you mean - the kernel isn't a debugger...
If you are running a User Mode Linux kernel or running inside QEMU etc.
then you can do what you describe because your "machine" is a program
but I think the only way to do that with real hardware is to learn how
to use KGDB ( http://kgdb.sourceforge.net ) and have another machine to
hand. I suppose you could also sprinkle beep patches/debug printks about
the place to see just how far it gets before it reboots...

-- 
Sitsofe | http://sucs.org/~sits/

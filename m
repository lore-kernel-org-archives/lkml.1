Return-Path: <linux-kernel-owner+w=401wt.eu-S1030803AbXDKFsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030803AbXDKFsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030784AbXDKFsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:48:38 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55719 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030803AbXDKFsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:48:37 -0400
X-Originating-Ip: 74.109.98.130
Date: Wed, 11 Apr 2007 01:47:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Matthew Wilcox <matthew@wil.cx>
cc: Roland Dreier <rdreier@cisco.com>, kernelnewbies@nl.linux.org,
       kernel-janitors@lists.osdl.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [KJ] remove SPIN_LOCK_UNLOCKED
In-Reply-To: <20070410220804.GI26692@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0704110140480.7851@CPE00045a9c397f-CM001225dbafb6>
References: <20070410181654.GA10525@arun.site> <Pine.LNX.4.61.0704102249290.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0704101722030.24526@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0704102327460.32056@yvahk01.tjqt.qr> <ada7isjq52p.fsf@cisco.com>
 <Pine.LNX.4.64.0704101743520.24794@CPE00045a9c397f-CM001225dbafb6>
 <20070410220804.GI26692@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007, Matthew Wilcox wrote:

> On Tue, Apr 10, 2007 at 05:45:07PM -0400, Robert P. J. Day wrote:
> > that works fine if you're defining a single spinlock, but what do you
> > do in cases like this:
> >
> > arch/sparc/lib/atomic32.c:      [0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED
> >
> > that is, when you're assigning an array of them?  you still need
> > some kind of generic, unnamed spinlock in those circumstances, no?
>
> That's a special case for architecture-only code.  It's not to be
> used by drivers.

be that as it may, it still means you need to take it into account
whenever someone says they want to entirely remove the
SPIN_LOCK_UNLOCKED macro from the source tree, as suggested in
Documentation/spinlocks.txt.

if you do that removal, you can always replace SPIN_LOCK_UNLOCKED with
its current definition of __SPIN_LOCK_UNLOCKED(old_style_spin_init),
or what have you.  but you would obviously have to replace it with
*something* that represents an unnamed spinlock if SPIN_LOCK_UNLOCKED
goes away.

rday

p.s.  just FYI:

$ grep -r "\.\.\..*SPIN_LOCK_UNLOCKED" *
arch/sparc/lib/atomic32.c:      [0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED
arch/cris/arch-v32/kernel/smp.c:spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] = SPIN_LOCK_UNLOCKED};
arch/parisc/lib/bitops.c:       [0 ... (ATOMIC_HASH_SIZE-1)]  = __RAW_SPIN_LOCK_UNLOCKED
arch/mips/kernel/gdb-stub.c:    [0 ... NR_CPUS-1] = __RAW_SPIN_LOCK_UNLOCKED,
arch/powerpc/platforms/iseries/htab.c:  { [0 ... 63] = SPIN_LOCK_UNLOCKED};

so, as matthew says, it's clearly not for drivers.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

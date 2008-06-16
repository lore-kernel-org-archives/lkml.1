Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYFPXEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYFPXEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYFPXEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:04:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbYFPXEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:04:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Tue, 17 Jun 2008 01:05:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <Pine.LNX.4.55.0806161636510.20218@cliff.in.clinika.pl> <200806170038.37224.rjw@sisk.pl>
In-Reply-To: <200806170038.37224.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806170105.45647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 of June 2008, Rafael J. Wysocki wrote:
> On Monday, 16 of June 2008, Maciej W. Rozycki wrote:
> > On Mon, 16 Jun 2008, Rafael J. Wysocki wrote:
> > 
> > > > > commit 7e3530cd98a0c6ab38f5898e855a5beffab26561
> > > > > Author: Maciej W. Rozycki <macro@linux-mips.org>
> > > > > Date:   Tue May 27 21:19:51 2008 +0100
> > > > > 
> > > > >     x86: I/O APIC: timer through 8259A second-chance
> > > > > 
> > > > >     Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> > > > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > > 
> > > >  Can I have .config used and a full bootstrap log from that system with
> > > > the patch still applied?
> > > 
> > > That may be difficult, because with the patch applied the box either doesn't
> > > boot at all, or works unreliably when booted (depending on the set of patches
> > > applied on top of it).
> > 
> >  Serial console?
> 
> No, this box doesn't have any serial ports.  It has a FireWire one, but I don't
> have a matching cable ...
> 
> >  I'm most interested in one from a configuration that 
> > does not boot at all as that's easier to reproduce, determine the cause
> > and verify whether a change fixes the problem or not.  Other
> > configurations may then be tested with the fix in place.
> 
> With the -next from today (20080616) I get a different picture.
> 
> Without any patches on top it boots, but the fan is turned 100% on as soon as
> the ACPI modules get loaded, regardless of the temperature (normally it does
> that above 75^o C, which is impossible to get normally, because there are 3
> temperature trip points below that level; generally the hardware only does that
> when overheating).  After that, things start to go _very_ slow, like 10x slower
> than usually in X and somewhat slower in the fb console, but I was able to get
> a dmesg output.  This is reproducible 100% of the time.
> 
> With commit 7e3530cd98a0c6ab38f5898e855a5beffab26561 reverted the box seems to
> work normally.  However, while I was writing this message, ACPI decided it was
> overheating and emergency shut down the box, although that was completely
> wrong.  Next time I'll try with the C1E patches reverted.
> 
> The .config is at: http://www.sisk.pl/kernel/debug/20080616/next-config
> 
> dmesg output without any patches is at
> http://www.sisk.pl/kernel/debug/20080616/dmesg-1.log
> 
> dmesg output with commit 7e3530cd98a0c6ab38f5898e855a5beffab26561 reverted is
> at: http://www.sisk.pl/kernel/debug/20080616/dmesg-2.log
> 
> (they look pretty similar to my untrained eye, but well).

BTW, with the C1E patches reverted I don't get the
WARNING: at /home/rafael/src/linux-next/kernel/smp.c:215 smp_call_function_single+0x3d/0xa2
in the log.  Thomas?

dmesg with commit 7e3530cd98a0c6ab38f5898e855a5beffab26561 and with the C1E
commits (the ones between 8750bf598db6a0ea3475d1cf8da922b325941e12 and
aa83f3f2cfc74d66d01b1d2eb1485ea1103a0f4e inclusive) reverted is at:
http://www.sisk.pl/kernel/debug/20080616/dmesg-3.log

Thanks,
Rafael

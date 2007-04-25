Return-Path: <linux-kernel-owner+w=401wt.eu-S2993130AbXDYVkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993130AbXDYVkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993129AbXDYVkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:40:05 -0400
Received: from smtp.ono.com ([62.42.230.12]:32302 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993130AbXDYVkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:40:03 -0400
Date: Wed, 25 Apr 2007 23:39:54 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: start_udev and devpts [Re: 2.6.21-rc6-mm1]
Message-ID: <20070425233954.1c8601da@werewolf-wl>
In-Reply-To: <20070425225039.1cf6c1ee@werewolf-wl>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	<20070424101041.2fb2d9e0@werewolf-wl>
	<20070424045801.607b30d4.akpm@linux-foundation.org>
	<20070424154321.11c70ace@werewolf-wl>
	<20070424102250.ab8469bd.akpm@linux-foundation.org>
	<20070425225039.1cf6c1ee@werewolf-wl>
X-Mailer: Claws Mail 2.9.1cvs23 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 22:50:39 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Tue, 24 Apr 2007 10:22:50 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 24 Apr 2007 15:43:21 +0200 "J.A. Magallón" <jamagallon@ono.com> wrote:
> > 
> > > On Tue, 24 Apr 2007 04:58:01 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > On Tue, 24 Apr 2007 10:10:41 +0200 "J.A. Magallón" <jamagallon@ono.com> wrote:
> > > > 
> > > > > On Sun, 8 Apr 2007 14:35:59 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > 
> > > > > > 
> > > > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/
> > > > > > 
> > > > > > 
> > > > > > - Lots of x86 updates
> > > > > > 
> > > > > 
> > > > > Has somthing related with PTY's changed in this kernel ?
> > > > 
> > > > Not as far as I know, but there were some kobject_uevent changes which
> > > > might have caused udev upcalls to break.  Perhaps.
> > > > 
> > > > > I have to enable legacy PTY handling in a couple boxes to get ssh working.
> > > > > If not, I had openpty() errors and nor sshd nor virtual terminals (aterm) were
> > > > > able to get a terminal.
> > > > 
> > > > I have CONFIG_PM_LEGACY unset in at least one of my test configs and it
> > > > works OK here.
> > > > 
> > > > > User space (udev) is the same in three boxes and one works and two fail.
> > > > > I had /dev/ptmx everywhere and /dev/pts mounted
> > > > > 
> > > > > Any idea ?
> > > > 
> > > > Nope.  Can you please check 2.6.21-rc7-mm1, see if that fixed it?  If so,
> > > > it might have been the kobject_uevent thing.
> > > > 
> > > 
> > > I will, thanks.
> > > 
> > > A couple questions (as far as udev behaviour is sooooooo distro dependent):
> > > - What should I have in /dev if I don't use legacy ptys ? As I understand
> > >   it, only /dev/ptmx and /dev/pts/*, no /dev/tty* nor /dev/pty* ?
> > 
> > My FC5 CONFIG_LEGACY_PTYS=n box has no /dev/ptmx, /dev/pts/*, all of
> > /dev/tty0 through /dev/tty63 and no /dev/pty*.
> > 
> > I'm not sure where all the /dev/tty*'s came from - perhaps a static udev
> > rule?
> >
> 
> Uh ?
> From the Kconfig help fot UNIX98_PTYS:
> 
> Linux has traditionally used the BSD-like names /dev/ptyxx for
> masters and /dev/ttyxx for slaves of pseudo terminals. This scheme
> has a number of problems. The GNU C library glibc 2.1 and later,
> however, supports the Unix98 naming standard: in order to acquire a
> pseudo terminal, a process opens /dev/ptmx; the number of the pseudo
> terminal is then made available to the process and the pseudo
> terminal slave can be accessed as /dev/pts/<number>. What was
> traditionally /dev/ttyp2 will then be /dev/pts/2, for example.
> 
> So if all userspace is Unix98-aware, you just would be done with
> /dev/ptmx and /dev/pts/*. In your setup it looks like you are not able
> to use Unix98 PTYs, but as udev has created tty* things work.
> Or not ?
> 
> > > - If my setup, for whatever strange reasons has /dev/tty* stored anyware
> > >   (/dev/.udev, links.conf...) and they get created, I supose that opening
> > >   /dev/tty will give a ENODEV ?
> > 
> > well, /dev/tty is attached to your current tty and /dev/tty2 will get you
> > talking to the second VT.  I can't immediately thing what /dev/tty22 is
> > attached to.
> > 
> 
> I supposed it was something like you always opened /dev/tty but kernel+glibc
> redirect you to /dev/ttyXX, that is your _real_ terminal.
> I will try to check docs...
> 

Oops, no, /dev/tty?? are for virtual consoles.

But I think I found the problem.
In short, in /dev/pts is mounted before /dev. I remounted it and ssh worked
fine again.
I'll dig mandrivas rc's to check this...

Anyways, I see no plain 'mount' command in /sbin/start_udev, all are 
'mount --move' commands. So I think it supposes is already mounted and
tries to move it.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.20-jam10 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #4 SMP PREEMPT

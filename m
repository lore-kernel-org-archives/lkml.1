Return-Path: <linux-kernel-owner+w=401wt.eu-S1161767AbXDXNoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161767AbXDXNoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161770AbXDXNoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:44:13 -0400
Received: from smtp.ono.com ([62.42.230.12]:42249 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161767AbXDXNoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:44:12 -0400
Date: Tue, 24 Apr 2007 15:43:21 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070424154321.11c70ace@werewolf-wl>
In-Reply-To: <20070424045801.607b30d4.akpm@linux-foundation.org>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
 <20070424101041.2fb2d9e0@werewolf-wl>
 <20070424045801.607b30d4.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1cvs18 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 04:58:01 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 24 Apr 2007 10:10:41 +0200 "J.A. Magallón" <jamagallon@ono.com> wrote:
> 
> > On Sun, 8 Apr 2007 14:35:59 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/
> > > 
> > > 
> > > - Lots of x86 updates
> > > 
> > 
> > Has somthing related with PTY's changed in this kernel ?
> 
> Not as far as I know, but there were some kobject_uevent changes which
> might have caused udev upcalls to break.  Perhaps.
> 
> > I have to enable legacy PTY handling in a couple boxes to get ssh working.
> > If not, I had openpty() errors and nor sshd nor virtual terminals (aterm) were
> > able to get a terminal.
> 
> I have CONFIG_PM_LEGACY unset in at least one of my test configs and it
> works OK here.
> 
> > User space (udev) is the same in three boxes and one works and two fail.
> > I had /dev/ptmx everywhere and /dev/pts mounted
> > 
> > Any idea ?
> 
> Nope.  Can you please check 2.6.21-rc7-mm1, see if that fixed it?  If so,
> it might have been the kobject_uevent thing.
> 

I will, thanks.

A couple questions (as far as udev behaviour is sooooooo distro dependent):
- What should I have in /dev if I don't use legacy ptys ? As I understand
  it, only /dev/ptmx and /dev/pts/*, no /dev/tty* nor /dev/pty* ?
- If my setup, for whatever strange reasons has /dev/tty* stored anyware
  (/dev/.udev, links.conf...) and they get created, I supose that opening
  /dev/tty will give a ENODEV ?

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.0 (Cooker) for i586
Linux 2.6.20-jam10 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #4 SMP PREEMPT

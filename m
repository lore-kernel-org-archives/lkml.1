Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYGKUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYGKUph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYGKUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:45:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60529 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYGKUp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:45:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26-rc7: BUG at kernel/power/snapshot.c:493
Date: Fri, 11 Jul 2008 22:47:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <1214584985.22228.15.camel@localhost> <200807112233.53207.rjw@sisk.pl> <20080711204023.GE6843@elf.ucw.cz>
In-Reply-To: <20080711204023.GE6843@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807112247.44530.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of July 2008, Pavel Machek wrote:
> On Fri 2008-07-11 22:33:52, Rafael J. Wysocki wrote:
> > On Friday, 11 of July 2008, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > > Anyone else seeing this? Happened after resuming from s2both (from
> > > > > > disk)...
> > > > > 
> > > > > At what point exactly did it happen?
> > > > 
> > > > I am attaching the full dmesg.
> > > 
> > > Something is seriously wrong here.
> > > 
> > > > usbcore: registered new interface driver usbhid
> > > > usbhid: v2.6:USB HID core driver
> > > > TCP cubic registered
> > > > NET: Registered protocol family 10
> > > > lo: Disabled Privacy Extensions
> > > > Mobile IPv6
> > > > NET: Registered protocol family 17
> > > > NET: Registered protocol family 15
> > > > Using IPI No-Shortcut mode
> > > > RAMDISK: ext2 filesystem found at block 0
> > > > RAMDISK: Loading 2000KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|done.
> 
> (1)
> > > > EXT2-fs warning: checktime reached, running e2fsck is recommended
> (2)
> > > > VFS: Mounted root (ext2 filesystem).
> > > > ------------[ cut here ]------------
> > > > kernel BUG at kernel/power/snapshot.c:493!
> > > > invalid opcode: 0000 [#1] PREEMPT SMP 
> > > > Modules linked in:
> > > 
> > > This is _after_ we mounted filesystems... we should not be resuming at
> > > this point.
> > 
> > This is an initrd, isn't it?
> 
> Does not look like so: it mounted some filesystem at (1), and
> checktime is reached. I thought initrd is read-only RAM disk -- it
> should not reach check time, no?

Yes, it will reach the check time if it's ext2 (which is the case).

Thanks,
Rafael

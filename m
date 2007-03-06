Return-Path: <linux-kernel-owner+w=401wt.eu-S965984AbXCFSet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965984AbXCFSet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965988AbXCFSet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:34:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46972 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965984AbXCFSes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:34:48 -0500
Date: Tue, 6 Mar 2007 13:34:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ebuddington@wesleyan.edu
cc: Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4
 + USB HD
In-Reply-To: <20070306154854.GD9198@pool-71-123-121-36.spfdma.east.verizon.net>
Message-ID: <Pine.LNX.4.44L0.0703061328570.24545-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Eric Buddington wrote:

> On Tue, Mar 06, 2007 at 10:36:20AM -0500, Alan Stern wrote:
> > On Tue, 6 Mar 2007, Oliver Neukum wrote:
> > 
> > > > Am Dienstag, 6. M??rz 2007 05:13 schrieb Eric Buddington:
> > > > reiser4[khubd(163)]: commit_current_atom (fs/reiser4/txnmgr.c:1049)[nikita-3176]:
> > > > WARNING: Flushing like mad: 16384
> > > > reiser4[khubd(163)]: commit_current_atom (fs/reiser4/txnmgr.c:1049)[nikita-3176]:
> > > > WARNING: Flushing like mad: 32768
> > > > ...<many simiar messages>
> > > > 
> > > > Most problematically, khubd and ent:sda1! are conspiring to suck 100%
> > > > CPU time, even after powering off the drive. A bunch of processes are
> > > > stuck in 'D' state, possibly because they're trying to access the dead
> > > > disk, which won't umount ("device is busy").
> > > 
> > > It looks like khubd allocates memory and enters reiser4. Possibly we have
> > > GFP_KERNEL in khubd where we should have GFP_NOIO or reiser4 has
> > > a problem dealing with IO failures.
> > 
> > A more complete stack trace (for example, Alt-SysRq-T) would help.

The stack trace didn't include the khubd process at all.  Probably that 
means it had already died.

On the good side, if khubd is dead, it can't be using up 100% of the CPU 
time!  :-)

You need to find out somehow what khubd is doing while it is so busy.  It 
could easily be, like Oliver suggested, that reiser4 is unable to handle 
I/O failures and gets stuck.

Alan Stern


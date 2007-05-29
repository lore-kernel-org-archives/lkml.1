Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbXE2SXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbXE2SXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXE2SX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:23:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45925 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbXE2SXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:23:25 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 29 May 2007 14:21:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] FILESYSTEMS:  Delete unused "int dummy[5]" from
 inodes_stat_t.
In-Reply-To: <20070529111902.27055fd0.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0705291416470.4736@localhost.localdomain>
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
 <20070529110041.49bf57f1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705291406040.4617@localhost.localdomain>
 <20070529111902.27055fd0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Randy Dunlap wrote:

> On Tue, 29 May 2007 14:07:01 -0400 (EDT) Robert P. J. Day wrote:
>
> > On Tue, 29 May 2007, Andrew Morton wrote:
> >
> > > kernel/sysctl.c:
> > >
> > > 	{
> > > 		.ctl_name	= FS_STATINODE,
> > > 		.procname	= "inode-state",
> > > 		.data		= &inodes_stat,
> > > 		.maxlen		= 7*sizeof(int),    <-----
> > > 		.mode		= 0444,
> > > 		.proc_handler	= &proc_dointvec,
> > > 	},
> > >
> > > akpm:/home/akpm> cat /proc/sys/fs/inode-state
> > > 608039  178454  0       0       0       0       0
> > >
> > > So it _is_ used: to present those five zeroes.  I think this is
> > > for back-compatibility with some cretaceous-era kernel.
> >
> > ah, gotcha.  well, i'll leave this up to someone else to do
> > anything with if they are so inclined.
>
> There's little to be done, except possibly put a /* comment */ on
> the struct's dummy line so that we don't go thru this again in N
> years.

  so, just to clarify, what *is* the value of those trailing five
zeroes?  andrew suggests it's to be backward-compatible with an old
kernel, which doesn't make much sense to me.  it would make more sense
to say that that's backward-compatible with some old userspace app
that always wants to see seven values and just ignores the last five.

  in any event, from Documentation/filesystems/proc.txt:

"inode-state contains two actual numbers and five dummy values. The
numbers are nr_inodes and nr_free_inodes (in order of appearance)."

if even the documentation calls them dummy values, do they really have
any residual value at this point?  and on that note, i'll stop harping
on this and move on.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbXE2T1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbXE2T1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXE2T1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:27:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53421 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbXE2T1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:27:35 -0400
Date: Tue, 29 May 2007 12:33:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Josh Boyer" <jwboyer@gmail.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alexander Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] FILESYSTEMS: Delete unused "int dummy[5]" from
 inodes_stat_t.
Message-Id: <20070529123326.a8a1bd64.randy.dunlap@oracle.com>
In-Reply-To: <625fc13d0705291144u1aef3b6dx4b00873f3d05b652@mail.gmail.com>
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
	<20070529110041.49bf57f1.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705291406040.4617@localhost.localdomain>
	<20070529111902.27055fd0.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705291416470.4736@localhost.localdomain>
	<465C71EA.5040706@oracle.com>
	<625fc13d0705291144u1aef3b6dx4b00873f3d05b652@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 13:44:42 -0500 Josh Boyer wrote:

> On 5/29/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > Robert P. J. Day wrote:
> > > On Tue, 29 May 2007, Randy Dunlap wrote:
> > >
> > >> On Tue, 29 May 2007 14:07:01 -0400 (EDT) Robert P. J. Day wrote:
> > >>
> > >>> On Tue, 29 May 2007, Andrew Morton wrote:
> > >>>
> > >>>> kernel/sysctl.c:
> > >>>>
> > >>>>    {
> > >>>>            .ctl_name       = FS_STATINODE,
> > >>>>            .procname       = "inode-state",
> > >>>>            .data           = &inodes_stat,
> > >>>>            .maxlen         = 7*sizeof(int),    <-----
> > >>>>            .mode           = 0444,
> > >>>>            .proc_handler   = &proc_dointvec,
> > >>>>    },
> > >>>>
> > >>>> akpm:/home/akpm> cat /proc/sys/fs/inode-state
> > >>>> 608039  178454  0       0       0       0       0
> > >>>>
> > >>>> So it _is_ used: to present those five zeroes.  I think this is
> > >>>> for back-compatibility with some cretaceous-era kernel.
> > >>> ah, gotcha.  well, i'll leave this up to someone else to do
> > >>> anything with if they are so inclined.
> > >> There's little to be done, except possibly put a /* comment */ on
> > >> the struct's dummy line so that we don't go thru this again in N
> > >> years.
> > >
> > >   so, just to clarify, what *is* the value of those trailing five
> > > zeroes?  andrew suggests it's to be backward-compatible with an old
> > > kernel, which doesn't make much sense to me.  it would make more sense
> > > to say that that's backward-compatible with some old userspace app
> > > that always wants to see seven values and just ignores the last five.
> >
> > Agreed, it's for compat with some (unknown) userspace app that reads
> > /proc/sys/fs/inode-state and scans for 7 (or more than 2) numbers there.
> > The mantra is "don't break userspace," so we leave the numbers there...
> 
> Couldn't you remove the dummy member and just have the proc entry
> print out 5 dummy zeros?

In theory someone could do that, but it would (a) require a comment
so that someone else didn't try to remove it 5 years from now and
(b) require more proc/sysctl code just for that one sysctl entry
since the sysctl entries are all table-driven right now and printing
5 zeros would require a new /proc/sys handler for just this one
sysctl.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

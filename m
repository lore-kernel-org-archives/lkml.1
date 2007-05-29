Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbXE2SNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbXE2SNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXE2SNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:13:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14562 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbXE2SNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:13:31 -0400
Date: Tue, 29 May 2007 11:19:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] FILESYSTEMS:  Delete unused "int dummy[5]" from
 inodes_stat_t.
Message-Id: <20070529111902.27055fd0.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705291406040.4617@localhost.localdomain>
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
	<20070529110041.49bf57f1.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705291406040.4617@localhost.localdomain>
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

On Tue, 29 May 2007 14:07:01 -0400 (EDT) Robert P. J. Day wrote:

> On Tue, 29 May 2007, Andrew Morton wrote:
> 
> > On Tue, 29 May 2007 13:11:07 -0400 (EDT)
> > "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> >
> > >
> > > Delete the apparently unused array "int dummy[5]" from struct
> > > inodes_stat_t.
> > >
> > > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > >
> > > ---
> > >
> > >   no idea what that array is for, but no one seems to care about it.
> > > removal compile-tested on x86 with "make allyesconfig" and nobody
> > > misses it (unless it's used for padding of some kind).
> > >
> > >
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index 7cf0c54..dec83dd 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -44,7 +44,6 @@ extern int get_max_files(void);
> > >  struct inodes_stat_t {
> > >  	int nr_inodes;
> > >  	int nr_unused;
> > > -	int dummy[5];
> > >  };
> > >  extern struct inodes_stat_t inodes_stat;
> > >
> >
> > kernel/sysctl.c:
> >
> > 	{
> > 		.ctl_name	= FS_STATINODE,
> > 		.procname	= "inode-state",
> > 		.data		= &inodes_stat,
> > 		.maxlen		= 7*sizeof(int),
> > 		.mode		= 0444,
> > 		.proc_handler	= &proc_dointvec,
> > 	},
> >
> > akpm:/home/akpm> cat /proc/sys/fs/inode-state
> > 608039  178454  0       0       0       0       0
> >
> > So it _is_ used: to present those five zeroes.  I think this is for
> > back-compatibility with some cretaceous-era kernel.
> 
> ah, gotcha.  well, i'll leave this up to someone else to do anything
> with if they are so inclined.

There's little to be done, except possibly put a /* comment */
on the struct's dummy line so that we don't go thru this again
in N years.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

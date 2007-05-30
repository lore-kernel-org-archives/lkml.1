Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbXE3Ll0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbXE3Ll0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXE3LlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:41:16 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:52313 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbXE3LlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:41:14 -0400
X-Originating-Ip: 72.143.65.211
Date: Wed, 30 May 2007 07:38:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@stusta.de>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Josh Boyer <jwboyer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] FILESYSTEMS: Delete unused "int dummy[5]" from inodes_stat_t.
In-Reply-To: <20070530112946.GT3899@stusta.de>
Message-ID: <Pine.LNX.4.64.0705300733200.12382@localhost.localdomain>
References: <Pine.LNX.4.64.0705291307001.32601@localhost.localdomain>
 <20070529110041.49bf57f1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705291406040.4617@localhost.localdomain>
 <20070529111902.27055fd0.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705291416470.4736@localhost.localdomain> <465C71EA.5040706@oracle.com>
 <625fc13d0705291144u1aef3b6dx4b00873f3d05b652@mail.gmail.com>
 <20070529123326.a8a1bd64.randy.dunlap@oracle.com> <tkrat.2eccbb76ef1aee06@s5r6.in-berlin.de>
 <20070530112946.GT3899@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_OC 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Adrian Bunk wrote:

> On Wed, May 30, 2007 at 08:41:56AM +0200, Stefan Richter wrote:
> > From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > Subject: fs: clarify "dummy" member in struct inodes_stat_t
> >
> > Found by Robert P. J. Day:  The role of inodes_stat_t.dummy wasn't clear
> > and one might be tempted to remove it.  Give it a better name and add a
> > comment.
> >
> > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > ---
> > Only quickly compile-tested.
> >
> > Index: linux/include/linux/fs.h
> > ===================================================================
> > --- linux.orig/include/linux/fs.h
> > +++ linux/include/linux/fs.h
> > @@ -44,7 +44,7 @@ extern int get_max_files(void);
> >  struct inodes_stat_t {
> >  	int nr_inodes;
> >  	int nr_unused;
> > -	int dummy[5];
> > +	int reserved[5];	/* for sysctl and procfs ABI compatibility */
> >  };
> >  extern struct inodes_stat_t inodes_stat;
>
> Considering that we export this struct to usespace, I don't think
> renaming a member without a good reason is a good idea (but adding a
> comment makes sense).

that makes sense but, given that that array is guaranteed to always
contain zeroes and therefore no useful information, it might be
amusing to rename it just to see what userspace apps break because
they're referring to it by name for what should be no good reason.

no, no, just kidding ... that would be cruel.  :-)

rday

p.s.  i apologize for this thread having gotten this involved -- i
thought i was submitting a fairly innocuous patch.  live and learn.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

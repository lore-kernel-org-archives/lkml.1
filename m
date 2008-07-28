Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYG1JkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYG1JkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 05:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbYG1Jj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 05:39:59 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56493 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYG1Jj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 05:39:58 -0400
Date: Mon, 28 Jul 2008 05:38:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Calvin Walton <calvin.walton@gmail.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
In-Reply-To: <1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
Message-ID: <alpine.LFD.1.10.0807280531210.3402@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>  <20080726094718.b617c1e7.randy.dunlap@oracle.com>  <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain> <1217214689.22927.3.camel@zem.phub.net.cable.rogers.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jul 2008, Calvin Walton wrote:

> On Sat, 2008-07-26 at 17:52 -0400, Robert P. J. Day wrote:
> > On Sat, 26 Jul 2008, Randy Dunlap wrote:
> >
> > > On Sat, 26 Jul 2008 09:20:49 -0400 (EDT) Robert P. J. Day wrote:
> > >
> > > >
> > > > Use "menuconfig" to allow all advanced partitions to be
> > > > deselectable from the top-level FS menu.
> > > >
> > > > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> > >
> > > Hi,
> > >
> > > I like the idea, but it does have one problem.  Before this
> > > patch, if someone disabled PARTITION_ADVANCED, the .config would
> > > still contain CONFIG_MSDOS_PARTITION=y but after this change,
> > > that config line is missing.  Not good.
> >
> > ah, quite right.  the obvious solution is to move MSDOS_PARTITION
> > out of there since it doesn't even *remotely* qualify as an
> > "advanced" partition -- it's about as basic as it gets.  i'll
> > ponder and resubmit.
>
> It's not that any of the partition types in the menu are advanced -
...

but that's how it's **listed** in "make menuconfig".  once you click
on

  Partition Types  --->

the top-level config option that selects or deselects all of that menu
is labelled:

  [*] Advanced partition selection
      ^^^^^^^^

there's a logical inconsistency in that part of the menu -- are those
just regular partitions, or are they "advanced" partitions?  pick one.

  i'm not sure there's an elegant redesign for that -- an obvious fix
(if it's even worth doing) is to move the fundamental MSDOS partition
option out of there since it's not an "advanced" option.  and that
MSDOS option doesn't even really belong there anyway since, even if
you deselect that entire submenu, you still get CONFIG_MSDOS_PARTITION
selected in your eventual .config file.

  yes, it's nitpicking but, as it's laid out right now, it's
unnecessarily confusing and inconsistent.  but i don't know if there's
a trivial fix for it.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXEROFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXEROFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbXEROEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:04:53 -0400
Received: from svr68.ehostpros.com ([67.15.48.48]:19885 "EHLO
	svr68.ehostpros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXEROEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:04:53 -0400
Subject: Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted
From: Kalpak Shah <kalpak@linsyssoft.com>
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070518135108.GB14225@ribosome.natur.cuni.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz>
	 <1179488826.4305.3.camel@garfield.linsyssoft.com>
	 <20070518135108.GB14225@ribosome.natur.cuni.cz>
Content-Type: text/plain
Date: Fri, 18 May 2007 19:38:18 +0530
Message-Id: <1179497298.4305.9.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - svr68.ehostpros.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - linsyssoft.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 15:51 +0200, Martin Mokrejs wrote:
> On Fri, May 18, 2007 at 05:17:06PM +0530, Kalpak Shah wrote:
> > On Fri, 2007-05-18 at 11:06 +0200, Martin Mokrejs wrote:
> > > Hi,
> > >   I just tried the 2.6.22-r1 candidate to test whether some bug I have 
> > > hit in the past still exists. I did use 2.6.20.6 so far. So, I have 
> > > cleanly rebooted to use the new kernel, after the machine came up I 
> > > tried to mess with the bug, and had to reboot again to play with kernel 
> > > commandline parameters. Unfortunately, on the next reboot fsck was 
> > > schedules on my filesystem after 38 clean mounts. :( And the problem 
> > > started. The fsck found some unused inodes, but probably did not know 
> > > where do they belong to, but it deleted them automagically. Finally, the 
> > > fsck died because it cannot fine some '..' entry.
> > > 
> > > /dev/hda3: Entry '..' in .../??? (5701636) has deleted/unused inode
> > > 5570561. CLEARED.
> > > Unconnected directory inode 5570567 (...)
> > > 
> > > /dev/hda3: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
> > >                   (i.e., without -a or -p options)
> > > 
> > 
> > This means that e2fsck has reached a point where it needs user
> > intervention. So you should not run e2fsck with -p, -a or -y options.
> > Look up the e2fsck man page for more on this.
> 
> Yeah, stupid init.d script in Gentoo. I will report at Gentoo as well but
> how can I revert the changes? Can you say which directories were affected?

No there is nothing wrong with your script, most problems get solved by
-a or -p and hence your init.d script is correct in using these options.

I don't understand what you mean by reverting your changes. 

An unconnected directory inode means that this directory (inode 5570567)
does not have a valid ".." entry (which is the backpointer to its
parent). So this directory will be moved to lost+found.

Thanks,
Kalpak.

> Thanks,
> Martin


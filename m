Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbXEROdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbXEROdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXEROdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:33:00 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:44222 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXEROdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:33:00 -0400
Date: Fri, 18 May 2007 16:32:58 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
To: Kalpak Shah <kalpak@linsyssoft.com>
Cc: linux-kernel@vger.kernel.org, ext3-users@redhat.com
Subject: Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted
Message-ID: <20070518143258.GA14611@ribosome.natur.cuni.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <1179488826.4305.3.camel@garfield.linsyssoft.com> <20070518135108.GB14225@ribosome.natur.cuni.cz> <1179497298.4305.9.camel@garfield.linsyssoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179497298.4305.9.camel@garfield.linsyssoft.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 07:38:18PM +0530, Kalpak Shah wrote:
> On Fri, 2007-05-18 at 15:51 +0200, Martin Mokrejs wrote:
> > On Fri, May 18, 2007 at 05:17:06PM +0530, Kalpak Shah wrote:
> > > On Fri, 2007-05-18 at 11:06 +0200, Martin Mokrejs wrote:
> > > > Hi,
> > > >   I just tried the 2.6.22-r1 candidate to test whether some bug I have 
> > > > hit in the past still exists. I did use 2.6.20.6 so far. So, I have 
> > > > cleanly rebooted to use the new kernel, after the machine came up I 
> > > > tried to mess with the bug, and had to reboot again to play with kernel 
> > > > commandline parameters. Unfortunately, on the next reboot fsck was 
> > > > schedules on my filesystem after 38 clean mounts. :( And the problem 
> > > > started. The fsck found some unused inodes, but probably did not know 
> > > > where do they belong to, but it deleted them automagically. Finally, the 
> > > > fsck died because it cannot fine some '..' entry.
> > > > 
> > > > /dev/hda3: Entry '..' in .../??? (5701636) has deleted/unused inode
> > > > 5570561. CLEARED.
> > > > Unconnected directory inode 5570567 (...)
> > > > 
> > > > /dev/hda3: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
> > > >                   (i.e., without -a or -p options)
> > > > 
> > > 
> > > This means that e2fsck has reached a point where it needs user
> > > intervention. So you should not run e2fsck with -p, -a or -y options.
> > > Look up the e2fsck man page for more on this.
> > 
> > Yeah, stupid init.d script in Gentoo. I will report at Gentoo as well but
> > how can I revert the changes? Can you say which directories were affected?
> 
> No there is nothing wrong with your script, most problems get solved by
> -a or -p and hence your init.d script is correct in using these options.
> 
> I don't understand what you mean by reverting your changes. 

I would like to boot with another/previous/tested kernel and run another,
stable fsck version. Yes, I cannot say how it happened that ext3 had broken
directory, but for sure before making changes to the filesystem I would
boot with a tested kernel and tools.

> 
> An unconnected directory inode means that this directory (inode 5570567)
> does not have a valid ".." entry (which is the backpointer to its
> parent). So this directory will be moved to lost+found.

And those original "errors"? Did not those modifications cause this in turn?


/dev/hda3 has been mounted 38 times without being checked, check forced
HTREE directory inode 1163319 has an invalid root node.
HTREE INDEX CLEARED
Entry '..' in .../??? (5570587) has deleted/unused inode 5570561. 
CLEARED.
/dev/hda3: Entry '..' in .../??? (5570620) has deleted/unused inode 
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5570625) has deleted/unused inode
5570561. CLEARED.
/dev/hda3: Entry '..' in .../??? (5570567) has deleted/unused inode
5570561. CLEARED.
[cut]

Martin

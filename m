Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbXJXOiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbXJXOiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760403AbXJXOiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:38:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:53030 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759698AbXJXOiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:38:04 -0400
Date: Wed, 24 Oct 2007 17:03:03 +0200
From: Jan Kara <jack@suse.cz>
To: Andy Whitcroft <andyw@uk.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-git18: ext2_check_page: bad entry in directory
Message-ID: <20071024150302.GD2652@duck.suse.cz>
References: <20071024131540.GV32058@shadowen.org> <20071024135900.GC2652@duck.suse.cz> <20071024143308.GA23139@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024143308.GA23139@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-10-07 15:33:08, Andy Whitcroft wrote:
> On Wed, Oct 24, 2007 at 03:59:00PM +0200, Jan Kara wrote:
> >   Hello,
> > 
> > On Wed 24-10-07 14:15:40, Andy Whitcroft wrote:
> > > Seems that we are now getting strange errors mounting an ext2 root
> > > filesystem under 2.6.23-git18:
> > > 
> > >   EXT2-fs error (device sda1): ext2_check_page: bad entry in directory #2:
> > >   rec_len is smaller than minimal - offset=0, inode=0, rec_len=0,
> > >   name_len=0
> >   Hmm, zero length entry in a root directory. Not nice.
> > 
> > > This seems to be occuring consistently since 2.6.23-git18.  I have been
> > > back and rerun a -git17 job to confirm its not visible at that level.
> > > This bug is expressing itself in 2.6.23-rc1 also.
> > > 
> > > I am suspicious of this commit in the -git17 -> -git18 block:
> > > 
> > >   commit 89910cccb8fec0c1140d33a743e72a712efd4f05
> > >   Author: Jan Kara <jack@suse.cz>
> > >   Date:   Sun Oct 21 16:41:40 2007 -0700
> > > 
> > >       ext2: avoid rec_len overflow with 64KB block size
> > > 
> > > /me goes debug this a bit more.
> >   Hmm, I'd suspect that too ;) But I swear I actually tested the code ;)
> > So what are you using the filesystem for (or do you get the error
> > immediately when mounting)? How large is the filesystem?
> 
> Its the root filesystem, so thats all she wrote.  The kernel fails to
> mount it and the world ends.  Its pretty small in now world terms.
> 
> /dev/sda1              17G   10G  6.0G  63% /
  OK, could you send me the metadata from the filesystem?

e2image -r /dev/sda1 - | gzip -dc root-image.gz

  Thanks.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZC3NA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZC3NA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZC3NAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:00:06 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:45429 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbZC3NAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:00:02 -0400
Subject: Re: Linux 2.6.29
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090329231451.GR26138@disturbed>
References: <49CD4DDF.3000001@garzik.org>
	 <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	 <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
	 <49CE3F74.6090103@rtr.ca>  <20090329231451.GR26138@disturbed>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 08:55:51 -0400
Message-Id: <1238417751.30488.12.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49D0C160.013A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 10:14 +1100, Dave Chinner wrote:
> On Sat, Mar 28, 2009 at 11:17:08AM -0400, Mark Lord wrote:
> > The better solution seems to be the rather obvious one:
> >
> >   the filesystem should commit data to disk before altering metadata.
> 
> Generalities are bad. For example:
> 
> write();
> unlink();
> <do more stuff>
> close();
> 
> This is a clear case where you want metadata changed before data is
> committed to disk. In many cases, you don't even want the data to
> hit the disk here.
> 
> Similarly, rsync does the magic open,write,close,rename sequence
> without an fsync before the rename. And it doesn't need the fsync,
> either. The proposed implicit fsync on rename will kill rsync
> performance, and I think that may make many people unhappy....
> 

Sorry, I'm afraid that rsync falls into the same category as the
kde/gnome apps here.

There are a lot of backup programs built around rsync, and every one of
them risks losing the old copy of the file by renaming an unflushed new
copy over it.

rsync needs the flushing about a million times more than gnome and kde,
and it doesn't have any option to do it automatically.  It does have the
option to create backups, which is how a percentage of people are using
it, but I wouldn't call its current setup safe outside of ext3.

-chris



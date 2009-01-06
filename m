Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZAFTVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZAFTVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZAFTVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:21:01 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41094
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZAFTVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:21:00 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Theodore Tso <tytso@mit.edu>
Subject: Re: document ext3 requirements
Date: Tue, 6 Jan 2009 13:20:27 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Martin =?utf-8?q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>, Duane Griffin <duaneg@dghda.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <200901041356.32701.rob@landley.net> <20090105191658.GA11632@mit.edu>
In-Reply-To: <20090105191658.GA11632@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901061320.29732.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009 13:16:58 Theodore Tso wrote:
> On Sun, Jan 04, 2009 at 01:56:32PM -0600, Rob Landley wrote:
> > On Saturday 03 January 2009 17:01:58 Martin MOKREJŠ wrote:
> > > > Still handy for recovering badly broken filesystems, I'd say.
> > >
> > > Me as well. How about improving you doc patch with some summary of
> > > this thread (although it is probably not over yet)? ;-) Definitely,
> > > a note that one can mount it as ext2 while read-only would be helpful
> > > when doing some forensics on the disk.
> >
> > Although make sure you _do_ mount it as read only because if you mount an
> > ext3 filesystem read/write as ext2 I've had it zap the journal entirely
> > and then you have to tune2fs -j the sucker to turn it back into ext3.
> >
> > Ext3 is... touchy.
>
> Um.... horse pucky:

Well I managed to kill it more than once, but I could easily have the 
reproduction sequence wrong.  (I wasn't _trying_ to do it again...)

> # mke2fs -q -t ext3 /dev/thunk/footest
> # debugfs -R features /dev/thunk/footest
> debugfs 1.41.3 (12-Oct-2008)
> Filesystem features: has_journal ext_attr resize_inode dir_index filetype
> sparse_super large_file # mount -t ext2 /dev/thunk/footest /mnt
> # touch /mnt/foo
> # umount /mnt
> # debugfs -R features /dev/thunk/footest
> debugfs 1.41.3 (12-Oct-2008)
> Filesystem features: has_journal ext_attr resize_inode dir_index filetype
> sparse_super large_file

If I can figure out what I did, I'll get back to you.

>    	     		 	  	       		 - Ted

Rob

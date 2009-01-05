Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbZAETRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbZAETRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZAETRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:17:30 -0500
Received: from thunk.org ([69.25.196.29]:39848 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbZAETR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:17:28 -0500
Date: Mon, 5 Jan 2009 14:16:58 -0500
From: Theodore Tso <tytso@mit.edu>
To: Rob Landley <rob@landley.net>
Cc: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>, Duane Griffin <duaneg@dghda.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090105191658.GA11632@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rob Landley <rob@landley.net>,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	Pavel Machek <pavel@suse.cz>, Duane Griffin <duaneg@dghda.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <20090103222957.GG1666@elf.ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz> <200901041356.32701.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901041356.32701.rob@landley.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 01:56:32PM -0600, Rob Landley wrote:
> On Saturday 03 January 2009 17:01:58 Martin MOKREJŠ wrote:
> > > Still handy for recovering badly broken filesystems, I'd say.
> >
> > Me as well. How about improving you doc patch with some summary of
> > this thread (although it is probably not over yet)? ;-) Definitely,
> > a note that one can mount it as ext2 while read-only would be helpful
> > when doing some forensics on the disk.
> 
> Although make sure you _do_ mount it as read only because if you mount an ext3 
> filesystem read/write as ext2 I've had it zap the journal entirely and then 
> you have to tune2fs -j the sucker to turn it back into ext3.
> 
> Ext3 is... touchy.

Um.... horse pucky:

# mke2fs -q -t ext3 /dev/thunk/footest
# debugfs -R features /dev/thunk/footest
debugfs 1.41.3 (12-Oct-2008)
Filesystem features: has_journal ext_attr resize_inode dir_index filetype sparse_super large_file
# mount -t ext2 /dev/thunk/footest /mnt
# touch /mnt/foo
# umount /mnt
# debugfs -R features /dev/thunk/footest
debugfs 1.41.3 (12-Oct-2008)
Filesystem features: has_journal ext_attr resize_inode dir_index filetype sparse_super large_file

   	     		 	  	       		 - Ted

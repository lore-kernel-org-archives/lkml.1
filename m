Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZC3NZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZC3NZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZC3NZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:25:29 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:62874 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZC3NZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:25:28 -0400
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
From: Chris Mason <chris.mason@oracle.com>
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao <flvazquez@uvigo.es>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49D0C29C.1060307@uvigo.es>
References: <200903291928.14451.bzolnier@gmail.com>
	 <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu>
	 <49D03AE1.8070009@redhat.com>
	 <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Mar 2009 09:24:19 -0400
Message-Id: <1238419459.30488.42.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.49D0C811.0206:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 22:01 +0900, Fernando Luis Vázquez Cao wrote:
> Chris Mason wrote:
> > On Sun, 2009-03-29 at 22:22 -0500, Eric Sandeen wrote:
> >> Theodore Tso wrote:
> >>> On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
> >>>> As long as we keep the call there this is probably good, but after
> >>>> talking w/ Chris Mason, I think the call is extraneous anyway and should
> >>>> probably just be removed...
> >>>>
> >>> Yes, I agree, but it takes a lot of digging to be completely sure of
> >>> that it's safe to remove it.  Interestingly, it was you who added the
> >>> patch which added the call to blkdev_issue_flush():
> >>> commit d755fb384250d6bd7fd18a0930e71965acc8e72e
> >>> Author: Eric Sandeen <sandeen@redhat.com>
> >>> Date:   Fri Jul 11 19:27:31 2008 -0400
> >>
> >> Yes, it was.  Although I got the idea when hch pointed out that SuSE did
> >> this... thanks to Chris.  It's come full circle.  :)
> > 
> > Grin.  I'm not sure the I_DIRTY checks alone are enough to decide that a
> > commit is required though.  I think the inode could be clean but still
> > have metadata that needs commit.
> 
> Chris, I have just sent patches that attempt to fix both ext3 and
> ext4 while also adding a per-device sysfs knob tu disable
> write-flushes. A previous version of this patch set added a new
> generic mount option but comments from Christoph and others
> convinced me to turn it into a per-device tunable. Could you take
> a look at the patches?
> 

Jens' comment are right on I think.  If we get that fixed up we can get
rid of all the filesystem mount -o barrier=flush,0,1,xyz confusion and
set it via the block devices directly.

That would be nice ;)

-chris



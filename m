Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbZC3LsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbZC3LsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZC3LsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:48:15 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:32367 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZC3LsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:48:14 -0400
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
From: Chris Mason <chris.mason@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <49D03AE1.8070009@redhat.com>
References: <200903291928.14451.bzolnier@gmail.com>
	 <49CFB33A.9020406@redhat.com> <20090330022521.GB13356@mit.edu>
	 <49D03AE1.8070009@redhat.com>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 07:47:47 -0400
Message-Id: <1238413667.30488.2.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49D0B167.00A7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 22:22 -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Sun, Mar 29, 2009 at 12:43:22PM -0500, Eric Sandeen wrote:
> >> As long as we keep the call there this is probably good, but after
> >> talking w/ Chris Mason, I think the call is extraneous anyway and should
> >> probably just be removed...
> >>
> > 
> > Yes, I agree, but it takes a lot of digging to be completely sure of
> > that it's safe to remove it.  Interestingly, it was you who added the
> > patch which added the call to blkdev_issue_flush():
> 
> > commit d755fb384250d6bd7fd18a0930e71965acc8e72e
> > Author: Eric Sandeen <sandeen@redhat.com>
> > Date:   Fri Jul 11 19:27:31 2008 -0400
> 
> 
> Yes, it was.  Although I got the idea when hch pointed out that SuSE did
> this... thanks to Chris.  It's come full circle.  :)

Grin.  I'm not sure the I_DIRTY checks alone are enough to decide that a
commit is required though.  I think the inode could be clean but still
have metadata that needs commit.

-chris



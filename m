Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZC3PXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZC3PXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZC3PWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:22:49 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:50553 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZC3PWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=JsX7lHU2ffxbwPObHbbaQJg+IFCcR9bWxFWbW7J0yZztp3vTf7pd7QGwNQnGzm0c/J
         odCXybLNgwlo2W22B1+ftCbW5J9exo/OV+abKNFsmiVYhGYWfRlvpXb/+yuea/iS2aFC
         EjPFkoH20CmxvY02sY+MmhUlImq/LNIYCEVH4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Fernando Luis =?iso-8859-1?q?V=E1zquez_Cao?= <flvazquez@uvigo.es>
Subject: Re: [PATCH] ext4: fix blkdev_issue_flush() failure handling
Date: Mon, 30 Mar 2009 17:26:12 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200903291928.14451.bzolnier@gmail.com> <1238413667.30488.2.camel@think.oraclecorp.com> <49D0C29C.1060307@uvigo.es>
In-Reply-To: <49D0C29C.1060307@uvigo.es>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903301726.12548.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
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
> Bartlomiej, I have just noticed that I happened to be working on
> patches for reiserfs and xfs similar to the ones you sent earlier
> this week. I picked some bits from your submission so I took the
> liberty to add your signed-off to my patches. Could you take a
> look at them and let me know if you are confortable with that?

I'm fine with people building bigger changes on top of my patches
but if you do so you please clearly denote in the patch description
what changes you have applied to the original patch...

Thanks,
Bart

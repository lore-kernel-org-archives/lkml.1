Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbXBQUEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbXBQUEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXBQUEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:04:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39884 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbXBQUEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:04:04 -0500
Date: Sat, 17 Feb 2007 12:04:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-02-17-03-25.tar.gz uploaded
Message-Id: <20070217120402.ec517938.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0702171158o5f384e60sacae4e45563d7321@mail.gmail.com>
References: <200702171127.l1HBRnhe025635@shell0.pdx.osdl.net>
	<45D74B37.1040507@googlemail.com>
	<20070217114601.19544615.akpm@linux-foundation.org>
	<6bffcb0e0702171158o5f384e60sacae4e45563d7321@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007 20:58:55 +0100 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> On 17/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sat, 17 Feb 2007 19:36:39 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> >
> > >
> > > akpm@linux-foundation.org napisał(a):
> > > > The mm snapshot broken-out-2007-02-17-03-25.tar.gz has been uploaded to
> > > >
> > > >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-17-03-25.tar.gz
> > > >
> > >
> > > BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
> >
> > hm, how did you make that happen?
> >
> 
> I don't know. I can reproduce this bug.
> 

Could you bisect it please?  The patches to suspect are

consolidate-generic_writepages-and-mpage_writepages.patch
consolidate-generic_writepages-and-mpage_writepages-tidy.patch

and

git-block.patch

So just do

	quilt pop factor-outstanding-i-o-error-handling-tidy.patch

and retest.  If that doesn't fail, do

	quilt push
	quilt push

and retest

For git-block, do

	quilt pop scsi-megaraid_sas-return-sync-cache-call-with-success.patch

and retest.  If that doesn't fail, do

	quilt push git-block-xfs-barriers-broke.patch

and retest.

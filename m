Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZG2Qhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZG2Qhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbZG2Qhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:37:39 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54962 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbZG2Qhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:37:38 -0400
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090729162844.GA22561@merkur.ravnborg.org>
References: <20090729111114.GA15239@redhat.com>
	 <1248875763.3900.1.camel@mulgrave.site>
	 <20090729162844.GA22561@merkur.ravnborg.org>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:37:36 +0000
Message-Id: <1248885456.3900.48.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 18:28 +0200, Sam Ravnborg wrote:
> On Wed, Jul 29, 2009 at 08:56:03AM -0500, James Bottomley wrote:
> > On Wed, 2009-07-29 at 14:11 +0300, Michael S. Tsirkin wrote:
> > > scsi/scsi.h is exported to userspace, so it should
> > > use __u8 instead of u8 as other userspace-visible headers do.
> > 
> > Actually, can we just put a hold on this until we decide what we're
> > doing with exporting include/scsi.
> > 
> > Arguments so far are
> > 
> >      1. Don't export and let glibc supply the headers (as it does now)
> >      2. Move headers to be exported to include/linux
> >      3. Take over include/scsi export from glibc: this will necessitate
> >         comparing our current headers and those of glibc and moving
> >         stuff around.
> 
> 2 + 3...
> Let include/scsi be kernel internal stuff.
> And have the exported headers in include/linux.

I don't quite understand what you're saying here.  I think 2 and 3 are
either/or options.  Either we move the exported files to include/linux
or we export from include/scsi.

I have to say I don't like option 2 because the breakage is visible to
user level programs (unless we can persuade glibc people to #include
<linux/scsi.h> in scsi/scsi.h).

> This is how net/ handle their headers.
> 
> I did a quick diff of the glibc provided scsi.h and kernel scsi.h.
> >From a quick look it seems that we have more in the kernel version
> than the glibc version - and no obvious conflicts.
> 
> But agree with Boaz that we should do this in one go.

James



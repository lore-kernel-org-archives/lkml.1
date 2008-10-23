Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYJWQFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYJWQFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756354AbYJWQFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:05:18 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3875 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbYJWQFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:05:16 -0400
Subject: Re: disk statistics issue in 2.6.27
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081022171712.GO22217@kernel.dk>
References: <20081019113102.GA18440@xs4all.net>
	 <20081020171248.GE19428@kernel.dk>
	 <1224686272.25437.14.camel@n2o.xs4all.nl>
	 <20081022171712.GO22217@kernel.dk>
Content-Type: text/plain
Organization: XS4ALL Internet B.V.
Date: Thu, 23 Oct 2008 18:05:02 +0200
Message-Id: <1224777902.26805.17.camel@n2o.xs4all.nl>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 19:17 +0200, Jens Axboe wrote:
> On Wed, Oct 22 2008, Miquel van Smoorenburg wrote:
> > On Mon, 2008-10-20 at 19:12 +0200, Jens Axboe wrote:
> > > On Sun, Oct 19 2008, Miquel van Smoorenburg wrote:
>
> > > > I noticed that the "iostat -k -x 2" output does't make any sense.
> > > > The number of reads/sec and number of writes/sec are about what I
> > > > would expect, and so are the other fields, but rkB/sec and wkB/sec
> > > > are  completely off-scale: gigabytes read/written per second.
> > >
> > 
> > > Are the reported values in iostat any sort of multiple of the real
> > > throughtput, or is is just insanely large?
> > 
> > It looks like it's a multiple, but it appears to vary between 128 and
> > 512, and is different for reads and writes, so I do not know what to
> > make of it.
> > 

I added some debug statements to block/blk-core.c, and it appears that
blk_end_io() is always called with nr_bytes == 16320 Kbytes (16711680).

Ofcourse I should have noticed earlier that iostat -x 2 always prints
32640 as "average request size" (in sectors).

Mike.


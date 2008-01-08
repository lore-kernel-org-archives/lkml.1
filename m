Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYAHLFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYAHLFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYAHLFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:05:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:42075 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751502AbYAHLFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:05:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19mWJthJdBmGDTw3u+H2CHsxCXi9y60kLyeYr2G+X
	bEGn1qzaUfNNEC
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
	pressure: box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080106122954.d8f04c98.akpm@linux-foundation.org>
References: <1199447212.4529.13.camel@homer.simson.net>
	 <1199612533.4384.54.camel@homer.simson.net>
	 <1199642470.3927.12.camel@homer.simson.net>
	 <20080106122954.d8f04c98.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 12:05:16 +0100
Message-Id: <1199790316.4094.57.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 12:29 -0800, Andrew Morton wrote:
> On Sun, 06 Jan 2008 19:01:10 +0100 Mike Galbraith <efault@gmx.de> wrote:
> 
> > 
> > On Sun, 2008-01-06 at 10:42 +0100, Mike Galbraith wrote:
> > > FWIW, here's box having same seizure writing to /dev/pktcdvd/sr0.
> > 
> > Ugh, horrid device IO ==> horrid VM AFIKT.  I'll continue rummaging, but
> > I wonder, am I doing something _so_ stupid as to warrant zero response?
> > 
> 
> Copying linux-mm might have helped.  Bad time of year, too.
> 
> >From the traces it looks like all IO has stopped and everyone is waiting
> (directly or indirectly) for certain IO completions.  Is that really true,
> or is IO still dribbling along?
> 
> >From the kswapd0 trace it would appear that UDF is doing synchronous writes
> (udf_update_inode->sync_dirty_buffer) which perhaps is making things
> mightily slow.

This is a pretty uninteresting thread except for the VM aspect, but
rather than leave it dangling, I'll laugh at my naivety and close.

Seeks on DVD drives are apparently far FAR more horrible that I ever
imagined, so writing to a filesystem on a DVD+RW in effect constitutes
the stupid thing I was worried about above.  Make an image, populate it,
write it instead... sure to be a truckload faster, and due to the VM
connection, much safer too.  Oh well.

	EOT

	-Mike


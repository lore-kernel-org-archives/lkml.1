Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbZFYTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbZFYTeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbZFYTeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:34:02 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47646 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974AbZFYTeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:34:00 -0400
Date: Thu, 25 Jun 2009 21:34:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Message-ID: <20090625193402.GA31415@kernel.dk>
References: <19010.62951.886231.96622@notabene.brown> <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name> <yq1k530qkm7.fsf@sermon.lab.mkp.net> <alpine.LFD.2.01.0906251045450.3605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906251045450.3605@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25 2009, Linus Torvalds wrote:
> 
> 
> On Thu, 25 Jun 2009, Martin K. Petersen wrote:
> > 
> > Neil> So I asked git why it as added, and it pointed to
> > Neil>   commit 1308835ffffe6d61ad1f48c5c381c9cc47f683ec
> > 
> > Neil> which suggests that it was added so that user space could tell the
> > Neil> kernel whether the device was rotational, rather than the other
> > Neil> way around.
> > 
> > There's an option to do it via udev for broken devices that don't report
> > it.  But both SCSI and ATA have a setting that gets queried and the
> > queue flag set accordingly.
> 
> .. except few devices actually set it. 
> 
> That flag is _definitely_ all about the user being able to override it.

Most certainly, the idea was to add udev rules to set it for drives.
Fortunately newer drives to work right without a need for such rules,
but it should be handy for the ones released last year and earlier.

Most user space will not care what the setting is, it's mostly for
internal use. CFQ uses it, as does btrfs to decide allocation policy.

-- 
Jens Axboe


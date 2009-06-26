Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZFZN3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZFZN3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758383AbZFZN3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:29:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33353 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbZFZN3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:29:38 -0400
Date: Fri, 26 Jun 2009 15:29:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Message-ID: <20090626132940.GR23611@kernel.dk>
References: <19010.62951.886231.96622@notabene.brown> <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name> <20090625194015.GB31415@kernel.dk> <19012.49673.454853.975682@notabene.brown> <20090626125037.GO23611@kernel.dk> <f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26 2009, NeilBrown wrote:
> On Fri, June 26, 2009 10:50 pm, Jens Axboe wrote:
> > On Fri, Jun 26 2009, Neil Brown wrote:
> >> Every block device has a 'gendisk' (aka generic disk).
> >> Every block device also (currently) has a request_queue.
> >
> > I don't know why you keep saying currently. It has always had a queue,
> > and I don't see a good reason why that should change for "special" block
> > devices like md/dm/loop/whatnot.
> 
> I say "currently" because I'm planning to create patches to make it
> optional, and I want to get you used to the idea :-)
> 
> And md/dm/loop/whatnot are not "special" block devices, any more than
> scsi/ide are "special" block devices.  They are all just block devices.
> They use different mechanisms, but each is just as valid as the other.

That was why I put it in quotes, they are just regular devices.

> The current code makes 'struct request' based block devices in to
> first-class citizens, and all the rest are second class (having to
> tag our data structures on ->queue data and/or ->private_data).

?? How is that different from devices, the ones you refer to as
first-class citizens? They too store device private data in eg
->queue_data.

> I just want all block devices to be equal.

There's no such thing as first or second class block devices. The fact
that drivers using ->make_request_fn directly do not utilize the full
scope of the queue isn't a very interesting fact, imho.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S932075AbXGaQVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbXGaQVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbXGaQVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:21:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:24873 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761262AbXGaQVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,204,1183359600"; 
   d="scan'208";a="256935490"
Date: Tue, 31 Jul 2007 09:18:41 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Message-Id: <20070731091841.857d22bb.kristen.c.accardi@intel.com>
In-Reply-To: <46AF4B05.4010700@gmail.com>
References: <20070705194909.337398431@intel.com>
	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	<46AE12B6.6090408@garzik.org>
	<46AED656.8070407@gmail.com>
	<1185891382.2750.8.camel@laptopd505.fenrus.org>
	<46AF4B05.4010700@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 23:45:25 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Anyways, I don't really think this attribute belongs to SCSI sysfs
> hierarchy.  There currently isn't any alternative but sysfs is part of
> userland visible interface and putting something into SCSI sysfs
> hierarchy just because libata doesn't have one doesn't look like a good
> idea.
> 
> sysfs isn't far from being detached from kobject and driver model.  I
> think it would be best to wait a bit and build proper libata sysfs
> hierarchy which won't have to be changed later when libata departs from
> SCSI.  Well, it isn't really a good way but IMHO it's better than
> sticking ATA power saving node into SCSI sysfs hierarchy.

"Wait a bit" could be a very long time.  Who is working on building this
new libata sysfs support now?  If the answer is "no one", which I think it 
may be, do you want to hold up a feature that actually helps many people
for possibly 6 months or more just because we have to go through scsi
right now for our sysfs interface?  on top of that, the last mail I 
got from James on this subject indicated that if we kept our granularity
large with the power savings levels, SCSI can actually take advantage of
this as well.  Sure, we may have to tweak things around later, but isn't
this what we do routinely?  Holding up valuable features from the kernel 
because things aren't perfect yet seems really broken. 

As far as your complaints about broken hardware go, keep in mind that
the patch set does provide a method of adding these disks to a blacklist,
so I don't see that as a problem.  And, the default for this feature is
"off", and user space would have to explicitly enable it.

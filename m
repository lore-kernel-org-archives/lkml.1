Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZFEBOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZFEBOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 21:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZFEBOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 21:14:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:24627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZFEBOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:14:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,307,1241420400"; 
   d="scan'208";a="419030121"
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, richard@rsk.demon.co.uk, damien.wyart@free.fr
In-Reply-To: <20090604152040.GA6007@nowhere>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
	 <20090604152040.GA6007@nowhere>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Jun 2009 09:14:47 +0800
Message-Id: <1244164487.2560.146.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 17:20 +0200, Frederic Weisbecker wrote:
> Hi,
> 
> 
> On Thu, May 28, 2009 at 01:46:33PM +0200, Jens Axboe wrote:
> > Hi,
> > 
> > Here's the 9th version of the writeback patches. Changes since v8:

> I've just tested it on UP in a single disk.
> 
> I've run two parallels dbench tests on two partitions and
> tried it with this patch and without.
I also tested V9 with multiple-dbench workload by starting multiple
dbench tasks and every task has 4 processes to do I/O on one partition (file
system). Mostly I use JBODs which have 7/11/13 disks.

I didn't find result regression between ﻿vanilla and V9 kernel on this workload.

> 
> I used 30 proc each during 600 secs.
> 
> You can see the result in attachment.
> And also there:
> 
> http://kernel.org/pub/linux/kernel/people/frederic/dbench.pdf
> http://kernel.org/pub/linux/kernel/people/frederic/bdi-writeback-hda1.log
> http://kernel.org/pub/linux/kernel/people/frederic/bdi-writeback-hda3.log
> http://kernel.org/pub/linux/kernel/people/frederic/pdflush-hda1.log
> http://kernel.org/pub/linux/kernel/people/frederic/pdflush-hda3.log
> 
> 
> As you can see, bdi writeback is faster than pdflush on hda1 and slower
> on hda3. But, well that's not the point.
> 
> What I can observe here is the difference on the standard deviation
> for the rate between two parallel writers on a same device (but
> two different partitions, then superblocks).
> 
> With pdflush, the distributed rate is much better balanced than
> with bdi writeback in a single device.
> 
> I'm not sure why. Is there something in these patches that makes
> several bdi flusher threads for a same bdi not well balanced
> between them?
> 
> Frederic.


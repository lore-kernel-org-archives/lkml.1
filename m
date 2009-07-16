Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZGPFps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZGPFps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 01:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbZGPFps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 01:45:48 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:12016 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbZGPFpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 01:45:47 -0400
Subject: Re: [PATCH 0/3] cciss rmmod/scan-thread fixes
From: Andrew Patterson <andrew.patterson@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       mike.miller@hp.com, jens.axboe@oracle.com
In-Reply-To: <20090715150809.8fd350b9.akpm@linux-foundation.org>
References: <20090714220239.22282.44414.stgit@bob.kio>
	 <20090715150809.8fd350b9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 05:45:42 +0000
Message-Id: <1247723142.25954.86.camel@grinch>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 15:08 -0700, Andrew Morton wrote:
> On Tue, 14 Jul 2009 16:02:40 -0600
> Andrew Patterson <andrew.patterson@hp.com> wrote:
> 
> > The following series fixes several problems causing hangs while
> > rmmoding the cciss driver. In the process of fixing these hangs, I
> > also reworked the the logical drive scanning kernel thread to use one
> > thread per driver rather than one thread per controller. I also added
> > a sysfs attribute to kick off a controller scan.
> > 
> >  .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +
> >  drivers/block/cciss.c                              |  198 ++++++++++++++++++--
> >  drivers/block/cciss.h                              |    7 +
> >  3 files changed, 188 insertions(+), 24 deletions(-)
> > 
> > Andrew Patterson (3):
> >       cciss: remove logical drive sysfs entries during driver cleanup.
> >       cciss: use only one scan thread
> >       cciss: kick off logical drive topology rescan through sysfs
> > 
> 
> So I assume that these are intended to fix the problem which
> cciss-fix-the-termination-of-the-scanning-thread.patch didn't fix?

Correct. As well as a lot of the race conditions during cleanup.

> 
> Once we get this all sorted out, which kernel version(s) are we
> targetting and why?

The current problems this patchset tries to solve is that rmmod of the
module hangs along with logical hot remove.

I was hoping to get these in as soon as possible. It looks like the
sysfs additions and the scan_thread patches initially went into 2.6.30
(if my limited git-fu is telling me correctly), so I can't call this a
regression.  I guess 2.6.32 then.

> 
> Thanks.
> 
-- 
Andrew Patterson
Hewlett-Packard


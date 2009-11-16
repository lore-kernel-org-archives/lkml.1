Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbZKPKrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbZKPKrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZKPKrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:47:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZKPKrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:47:42 -0500
Date: Mon, 16 Nov 2009 11:47:44 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, mszeredi@suse.de
Subject: Re: Performance regression in IO scheduler still there
Message-ID: <20091116104744.GC23231@duck.suse.cz>
References: <20091026172012.GC7233@duck.suse.cz> <x49zl7020mr.fsf@segfault.boston.devel.redhat.com> <20091111141031.GA21511@duck.suse.cz> <x493a4lot31.fsf@segfault.boston.devel.redhat.com> <20091112172941.GK14528@duck.suse.cz> <x49pr7npj71.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49pr7npj71.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-11-09 15:44:02, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Wed 11-11-09 12:43:30, Jeff Moyer wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> >   Sadly, I don't see the improvement you can see :(. The numbers are the
> >> > same regardless low_latency set to 0:
> >> > 2.6.32-rc5 low_latency = 0:
> >> > 37.39 36.43 36.51 -> 36.776667 0.434920
> >> >   But my testing environment is a plain SATA drive so that probably
> >> > explains the difference...
> >> 
> >> I just retested (10 runs for each kernel) on a SATA disk with no NCQ
> >> support and I could not see a difference.  I'll try to dig up a disk
> >> that support NCQ.  Is that what you're using for testing?
> >   I don't think I am. How do I find out?
> 
> Good question.  ;-)  I grep for NCQ in dmesg output and make sure it's
> greater than 0/32.  There may be a better way, though.
  Message in the logs:
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: Hitachi HTS722016K9SA00, DCDOC54P, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
  So apparently no NCQ. /sys/block/sda/device/queue_depth shows 1 but I
guess that's just it's way of saying "no NCQ".

  What I thought might make a difference why I'm seeing the drop and you
are not is size of RAM or number of CPUs vs the tiobench file size or
number of threads. I'm running on a machine with 2 GB of RAM, using 4 GB
filesize. The machine has 2 cores and I'm using 16 tiobench threads. I'm
now rerunning tests with various numbers of threads to see how big
difference it makes.

								Honza

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

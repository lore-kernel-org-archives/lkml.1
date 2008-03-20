Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYCTKVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYCTKVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 06:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYCTKUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 06:20:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125AbYCTKUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 06:20:50 -0400
Date: Thu, 20 Mar 2008 03:20:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Higdon <jeremy@sgi.com>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Buffered I/O to block device very slow and other SCSI issues...
Message-Id: <20080320032010.e640c52a.akpm@linux-foundation.org>
In-Reply-To: <20080320010807.GA27620@sgi.com>
References: <20080319231654.GA103321673@sgi.com>
	<20080320010807.GA27620@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 18:08:07 -0700 Jeremy Higdon <jeremy@sgi.com> wrote:
>

(cc's added.  It matters)

> On Thu, Mar 20, 2008 at 10:16:54AM +1100, David Chinner wrote:
> > 4p ia64, 24GB RAM, 2.6.25-rc3, qla1280, 15krpm scsi disk.
> > 
> > Direct I/O:
> > 
> > dgc@budgie:~/xfstests$ sudo dd if=/dev/zero of=/dev/sdb6 bs=1024k count=1024 oflag=direct
> > 1024+0 records in
> > 1024+0 records out
> > 1073741824 bytes (1.1 GB) copied, 27.8974 s, 38.5 MB/s
> > 
> > Doing approximately 80 512k I/os per second (disk bandwidth).
> > 
> > Buffered I/O:
> > 
> > dgc@budgie:~/xfstests$ sudo dd if=/dev/zero of=/dev/sdb6 bs=1024k count=4096
> > 4096+0 records in
> > 4096+0 records out
> > 4294967296 bytes (4.3 GB) copied, 427.872 s, 10.0 MB/s
> 
> How big is sdb6?  How many '2's do you see in
> 
> 	factor `cat /sys/block/sdb/sdb6/size`

There have always been problems with thsi and I'm not sure that anyone
cared enough about buffered writes to blockdevs to get to the bottom of
them.

I assume you aren't running i386 highmem...


> > I also suspect that CTQ has not been set up correctly on this
> > kernel, because:
> > 
> > $ cat /sys/block/sdb/device/queue_depth
> > 3
> > $ ls -l /sys/block/sdb/device/queue_depth
> > -r--r--r-- 1 root root 0 Mar 20 09:59 /sys/block/sdb/device/queue_depth
> > $
> > 
> > It appears to be hard coded to 3 and can't be changed....
> 
> That's a bug in the qla1280 driver.  I thought that had gotten fixed.
> It's looking at the wrong mailbox register after setting device parameters.
> 

Was there a patch anywhere?

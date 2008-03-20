Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYCTBIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYCTBIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYCTBIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:08:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47833 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752838AbYCTBII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:08:08 -0400
Date: Wed, 19 Mar 2008 18:08:07 -0700
From: Jeremy Higdon <jeremy@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Buffered I/O to block device very slow and other SCSI issues...
Message-ID: <20080320010807.GA27620@sgi.com>
References: <20080319231654.GA103321673@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319231654.GA103321673@sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 10:16:54AM +1100, David Chinner wrote:
> 4p ia64, 24GB RAM, 2.6.25-rc3, qla1280, 15krpm scsi disk.
> 
> Direct I/O:
> 
> dgc@budgie:~/xfstests$ sudo dd if=/dev/zero of=/dev/sdb6 bs=1024k count=1024 oflag=direct
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 27.8974 s, 38.5 MB/s
> 
> Doing approximately 80 512k I/os per second (disk bandwidth).
> 
> Buffered I/O:
> 
> dgc@budgie:~/xfstests$ sudo dd if=/dev/zero of=/dev/sdb6 bs=1024k count=4096
> 4096+0 records in
> 4096+0 records out
> 4294967296 bytes (4.3 GB) copied, 427.872 s, 10.0 MB/s

How big is sdb6?  How many '2's do you see in

	factor `cat /sys/block/sdb/sdb6/size`

> I also suspect that CTQ has not been set up correctly on this
> kernel, because:
> 
> $ cat /sys/block/sdb/device/queue_depth
> 3
> $ ls -l /sys/block/sdb/device/queue_depth
> -r--r--r-- 1 root root 0 Mar 20 09:59 /sys/block/sdb/device/queue_depth
> $
> 
> It appears to be hard coded to 3 and can't be changed....

That's a bug in the qla1280 driver.  I thought that had gotten fixed.
It's looking at the wrong mailbox register after setting device parameters.

jeremy

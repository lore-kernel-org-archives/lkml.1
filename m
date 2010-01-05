Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588Ab0AEXEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0AEXEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563Ab0AEXEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:04:46 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:36537 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab0AEXEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:04:44 -0500
X-Greylist: delayed 2381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 18:04:44 EST
Date: Tue, 5 Jan 2010 22:25:00 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Paul Hartman <paul.hartman+linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: Multi-file USB mass-storage copy from PC to Nokia N900 slow
	when using CFQ
Message-ID: <20100105222500.GA24419@sucs.org>
References: <58965d8a1001050807l31ddf8d1l55ebcfbadbfc206d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58965d8a1001050807l31ddf8d1l55ebcfbadbfc206d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 10:07:22AM -0600, Paul Hartman wrote:
> Hi,

I'm going to CC Jens on this email as he's the block device maintainer
and might be in the better position to comment on this.

> Copying more than one file from my PC (kernel 2.6.32) to my Nokia N900
> over USB mass storage mode is very slow when CFQ is the i/o scheduler.
> The target uses vfat filesystem.
> 
> I am using iotop to monitor the I/O in general, plus I performed the
> following test. file1 and file2 are each 700M and both housed on a
> ramdrive for this test. They were deleted from the destination between
> runs.
> 
> # one file at a time with sync in-between, fast speeds:
> $ sync; time sh -c "cp file1 /mnt/usb; sync; cp file2 /mnt/usb; sync"
> 
> real    1m25.697s
> user    0m0.005s
> sys     0m2.509s
> 
> # copy two files in a row, then sync, speed is bad:
> $ sync; time sh -c "cp file1 file2 /mnt/usb; sync"
> 
> real    6m51.439s
> user    0m0.007s
> sys     0m2.615s
> 
> 
> Using all I/O schedulers, the speed of the first test was the same. So
> it's only related to writing more than 1 file to the N900. The timing
> results for the second test ended up as such:
> 
> cfq: 6m51.439s
> noop: 3m0.733s
> anticipatory: 1m44.348s
> deadline: 1m36.804s
> 
> 
> Also, in 2.6.31 the speed was four times slower, so the removal of old
> pdflush code may have made a difference in this case. Copying 1
> gigabyte takes about 1 minute at optimal speed, about 5 minutes using
> CFQ in kernel 2.6.32, and took about 20 minutes using CFQ in kernel
> 2.6.31.
> 
> I thought you may be interested in case there's room to improve the
> scheduler.  If you want any other info let me know!
> 
> Thanks
> Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Sitsofe | http://sucs.org/~sits/

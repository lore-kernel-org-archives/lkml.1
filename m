Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYACUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYACUWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYACUWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:22:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYACUWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:22:36 -0500
Message-ID: <477D4391.3030704@redhat.com>
Date: Thu, 03 Jan 2008 15:20:33 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: SATA buffered read VERY slow (not raid, Promise TX300 card);
 2.6.23.1(vanilla)
References: <4777276E.9090404@tlinx.org>
In-Reply-To: <4777276E.9090404@tlinx.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2007 12:06 AM, Linda Walsh wrote:
> I needed to get a new hard disk for one of my systems and thought that
> it was about time to start going with SATA.
> 
> I picked up a Promise 4-Port Sata300-TX4 to go with a 750G
> Seagate SATA -- I'd had good luck with a Promise ATA100 (P)ATA
> and lower capacity Seagates and thought it would be a good combo.
> 
> Unfortunately, the *buffered* read performance is *horrible*!
> 
> I timed the new disk against a 400GB PATA and old 80MB/s SCSI-based
> 18.3G hard disk.  While the raw speed numbers are faster as expected,
> the linux-buffered read numbers are not good.
> 
> 
> sda=18.3G on 80MB/s SCSI
> sdb=the new 750GB on a 3Gb SATA w/NCQ.
> hdf=400GB PATA on an ATA100 Promise card
> 
> I used "dd" for my tests, reading 2GB on a quiescent machine
> that has 1GB of main memory.  Output was to dev null.  Input
> was from the device (not a partition or file), (/dev/sda, /dev/sdb
> and /dev/hdf).  BS=1M, Count=2k.  For the direct tests, I used
> the "iflag=direct" param.  No RAID or "volumes" are involved.
> 
> In each case, I took best run time out of 3 runs.
> 
> Direct read speeds (and cpu usage):
> dev   speed       cpu/real     %
> sda   60MB/s     0.51/35.84   1.44
> sdb   80MB/s     0.50/26.72   1.87
> hdf   69.4MB/s   0.51/30.92   1.68
> 
> 
> Buffered reads show the "bad news":
> dev   speed       cpu/real     %
> sda   59.9MB/s  20.80/35.86   58.03
> sdb   18.7MB/s  16.07/114.73  14.01  <-SATA extra badness
> hdf   69.8MB/s  17.37/30.76   56.48
> 
> I assume this isn't expected behavior.
> 

Try the PATA driver for the parallel ATA drive to see if it
has the same behavior.

Reboot before each test (or use drop_caches.)

hdparm should mostly work for reading drive settings but not for
writing them...

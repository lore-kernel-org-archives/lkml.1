Return-Path: <linux-kernel-owner+w=401wt.eu-S1751279AbXBMLMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbXBMLMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXBMLMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:12:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60806 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751279AbXBMLMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:12:48 -0500
Date: Tue, 13 Feb 2007 11:25:27 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Message-ID: <20070213112527.59eaa504@localhost.localdomain>
In-Reply-To: <200702131034.22639.fink@mpe.mpg.de>
References: <200702121502.17130.fink@mpe.mpg.de>
	<200702121856.29729.fink@mpe.mpg.de>
	<20070212190835.20f9b92f@localhost.localdomain>
	<200702131034.22639.fink@mpe.mpg.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well they do. The Flash disk I have (SATA-I) is capable of 48 MB/s and this 
> value is reached over the whole disk size by windows as well as by FreeBSD. 
> See my test results in the first thread.

Ok a flash disk should be more stable

> My Seagate Barracuda Harddisk drive (SATA-II) starts with 76 MB/s and 
> decreases linearly to 35 MB/s due to the fact that it has to write to a 
> rotating disk. But on a flash disk there is nothing rotating...

The hard disk one isn't guaranteed or stable but the flash especially if
it is aimed at it ought to behave.

> So where is the difference between SATA-I and SATA-II ?

All physical side if they are on the same controller when you do the
tests. Mostly latency,

> And why is FreeBSD able to write with constant rates (the complete 25 GB, all 
> with 48+/-0.1 MB/s) but Linux 2.6.18 not ?

Does the FreeBSD fsync sync to media ? Also what controller is being used
here, and do you have EHCI USB support running ?

> With a dedicated (rotating) SATA II device, using the first 70% of disk space 
> no problem -- tested ! With a SATA-I device only a problem with Linux 2.6.18

I suspect the SATA-1 itself may not be the decider but something else -
eg the hard disk using NCQ, which would cover up any latency related
problems.

> Journaling of data: you are right, ext2 performs better than ext3.

And ext3 in writeback mode ought in theory (but practice is always
harder ;)) be faster than ext2.


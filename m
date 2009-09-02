Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZIBBKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZIBBKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 21:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZIBBKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 21:10:20 -0400
Received: from science.horizon.com ([71.41.210.146]:26804 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755307AbZIBBKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 21:10:19 -0400
Date: 1 Sep 2009 21:10:20 -0400
Message-ID: <20090902011020.32110.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: adilger@sun.com, linux@horizon.com
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Cc: david@lang.hm, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz
In-Reply-To: <20090901161828.GN4197@webber.adilger.int>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> - I seem to recall that ZFS does replicate metadata.
> 
> ZFS definitely does replicate data.  At the lowest level it has RAID-1,
> and RAID-Z/Z2, which are pretty close to RAID-5/6 respectively, but with
> the important difference that every write is a full-stripe-width write,
> so that it is not possible for RAID-Z/Z2 to cause corruption due to a
> partially-written RAID parity stripe.
> 
> In addition, for internal metadata blocks there are 1 or 2 duplicate
> copies written to different devices, so that in case of a fatal device
> corruption (e.g. double failure of a RAID-Z device) the metadata tree
> is still intact.

Forgive me for implying by omission that ZFS did not replicate data.
What I was trying to point out is that it replicates metadata *more*,
and you can choose among the redundant backups.

> What else is interesting is that in the case of 1-4-bit errors the
> default checksum function can also be used as ECC to recover the correct
> data even if there is no replicated copy of the data.

Interesting.  Do you actually see suhc low-bit-weight errors in
practice?  I had assumed that modern disks were complicated enough
that errors would be high-bit-weight miscorrections.

>> One of ZFS's big performance problems is that currently it only checksums
>> the entire RAID stripe, so it always has to read every drive, and doesn't
>> get RAID's IOPS advantage.
> 
> Or this is a drawback of the Linux software RAID because it doesn't detect
> the case when the parity is bad before there is a second drive failure and
> the bad parity is used to reconstruct the data block incorrectly (which
> will also go undetected because there is no checksum).

Well, all conventional RAID systems lack block checksums (or, more to
the point, rely on the drive's checksumming), and have this problem.

I was pointing out that ZFS currently doesn't support partial-stripe
*reads*, thus limiting IOPS in random-read applications.  But that's
an "implementation detail", not a major architectural issue.

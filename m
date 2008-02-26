Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbYBZXGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbYBZXGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbYBZXG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:06:26 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:36942 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755924AbYBZXGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:06:25 -0500
Date: Wed, 27 Feb 2008 00:07:05 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: Re: Performance problems with 3ware 9500S-4LP and 2.6.25-rc3
In-reply-to: <20080226174314.GA30767@skl-net.de>
To: Andre Noll <maan@systemlinux.org>
Cc: adam radford <aradford@gmail.com>, Tony Battersby <tonyb@cybernetics.com>,
       =?ISO-8859-15?Q?Johannes_W=F6rner?= 
	<johannes.woerner@tuebingen.mpg.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <47C49B99.1060707@nets.rwth-aachen.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.25,409,1199660400";   d="scan'208";a="52346124"
References: <20080226174314.GA30767@skl-net.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll schrieb:
> Hi
> 
> we are experiencing massive performance problems with two of our
> Linux servers that contain 3ware controllers on a Tyan mainboard and
> a couple of 1T disks.
> 
> During the daily cron job that uses rsync to sync a 500G file system
> from another machine to the raid on the 3ware controller the load
> jumps up, and the machine becomes sluggish as hell. For example, an
> ssh login to that machine takes minutes to complete and ldap becomes
> unreliable while the rsync job is running. Even Nagios complains
> about the machine being down while rsync is running.

Could you give some numbers, please?

However there are some known issues:

http://forums.storagereview.net/index.php?showtopic=25923
http://tumbleweed.org.za/2007/02/16/horrific-performance-with-3ware-raid

Symptons are reasonable performance with large block ops, but really bad performance with small block ops.
time (cp -a linux-2.6.24.2 linux-2.6.24.2b; sync)
Gives me with some tuning 50 seconds here with a 9650SE in a 4 disk raid5 setup. (very bad, single disk will do it in <30s!!!)
But reading and writing large files with large block sizes is usually beyond > 100 MB/s

[snipped a lot]

> Andre

Best regards,
Arnd

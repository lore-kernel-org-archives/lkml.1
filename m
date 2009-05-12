Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZELIZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZELIZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbZELIYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:24:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:58768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbZELIYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:24:49 -0400
Message-ID: <4A093259.30606@kernel.org>
Date: Tue, 12 May 2009 17:24:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: v.virvilis@biovista.com
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: SATA disks resets in a md setup
References: <200905081739.46206.v.virvilis@biovista.com> <4A053229.5010406@garzik.org> <200905111324.38715.v.virvilis@biovista.com>
In-Reply-To: <200905111324.38715.v.virvilis@biovista.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 08:23:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vassilis Virvilis wrote:
> Ok I changed
> 	M/B,
> 	PSU
> 	and cables.
> 
> Now the stress test passes only one SATA reset instead of 3 or 4 before the fatal one.
> 
> 
> [ 1804.915319] ata1.01: exception Emask 0x10 SAct 0x0 SErr 0x10000 action 0xe frozen
> [ 1804.915319] ata1.01: ST-ATA: DRQ=1 with device error, dev_stat 0x0
> [ 1804.915319] ata1: SError: { PHYRdyChg }
> [ 1804.915319] ata1.01: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/10 tag 0 pio 512 in
> [ 1804.915319]          res 00/00:01:09:4f:c2/00:00:00:00:00/10 Emask 0x212 (ATA bus error)
> [ 1804.915319] ata1: hard resetting link
> [ 1810.279540] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)

PHYRdyChg under load is very symptomatic of inadequate power supply.
If you run "smartctl -a" on the device before and after the error,
what counters change?

If you have two PSUs around, one thing worth trying is to power up the
second PSU separately and put half of the drives on the separate PSU
and see whether the problem goes away or the pattern of failures
changes.  PSU can be easily powered up w/o motherboard.

  http://modtown.co.uk/mt/article2.php?id=psumod

-- 
tejun

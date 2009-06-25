Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbZFYPlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbZFYPlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbZFYPlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:41:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46034 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbZFYPlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:41:24 -0400
Date: Thu, 25 Jun 2009 11:41:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       martin.petersen@oracle.com
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
Message-ID: <20090625154120.GA22616@redhat.com>
References: <200906250904.57149.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906250904.57149.elendil@planet.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25 2009 at  3:04am -0400,
Frans Pop <elendil@planet.nl> wrote:

> During boot of 2.6.31-rc1 on an arm EABI system I got the following errors:
> 
> device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> device-mapper: table: 254:0: target device sda6 is misaligned
> device-mapper: table: 254:0: target device sda6 is misaligned
> device-mapper: table: 254:1: target device sda6 is misaligned
> device-mapper: table: 254:1: target device sda6 is misaligned
> 
> The boot did complete successfully. A boot with 2.6.30 just previously was
> clean, and when I reboot back into 2.6.30 the messages are gone again.
> 
> The system has a single volume group with two logical volumes.
> 
> Please advise and let me know what additional info is needed.

Even though the messages don't contain "warning", and probably should,
they are printed via DMWARN().

These warnings are a function of device-mapper now being
topology-aware.  This means that your LVs are likely misaligned relative
to the underlying hardware.  Given that you're using partitions I'd
wager they are the source of the misalignment.  But there could be a bug
lurking somewhere.

Please provide the output from the following commands:

pvs -o +pe_start

cat /sys/block/sda/sda6/alignment_offset
cat /sys/block/sda/queue/physical_block_size
cat /sys/block/sda/queue/logical_block_size

If you could also provide the same info for all other PVs that are in
the VG that would be appreciated.

Mike

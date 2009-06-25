Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZFYSwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZFYSwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZFYSws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:52:48 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:57255 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbZFYSws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:52:48 -0400
From: Frans Pop <elendil@planet.nl>
To: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
Date: Thu, 25 Jun 2009 20:52:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       martin.petersen@oracle.com
References: <200906250904.57149.elendil@planet.nl> <200906251953.34253.elendil@planet.nl> <20090625182302.GA23113@redhat.com>
In-Reply-To: <20090625182302.GA23113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906252052.50364.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jun 2009 18:52:51.0098 (UTC) FILETIME=[23DFF7A0:01C9F5C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Mike Snitzer wrote:
> OK, I found a really stupid bug.  I was passing the data start offset
> (pe_start) through to blk_stack_limits() in terms of sectors rather
> than bytes.  The following should silence your warnings:

Yes, all clear again. So not broken userspace after all ;-)

Reported-by: Frans Pop <elendil@planet.nl>
Tested-by: Frans Pop <elendil@planet.nl>

Thanks,
FJP

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 4899ebe..2cba557 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -495,7 +495,7 @@ int dm_set_device_limits(struct dm_target *ti,
> struct dm_dev *dev, return 0;
>  	}
>
> -	if (blk_stack_limits(limits, &q->limits, start) < 0)
> +	if (blk_stack_limits(limits, &q->limits, start << 9) < 0)
>  		DMWARN("%s: target device %s is misaligned",
>  		       dm_device_name(ti->table->md), bdevname(bdev, b));


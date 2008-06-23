Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbYFWWqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbYFWWqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 18:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYFWWqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 18:46:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:16099 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYFWWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 18:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=DEw5Kclr/k6ZRp/xD/QVBM+8U71hEkaDOGJm4gMi+UkQQRZH5K8WGT1KEssZsL8QZA
         /x9yI7jWYXzi5G6Nsuz2pyVsD4mPvb8hMsuI+bGwcjXL8W3238RTMb5sJQ4x5sME0enh
         sYsrk1v7Ddrcfzh2GJjwB8UtGmfNfD2C0SaBk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Date: Tue, 24 Jun 2008 00:41:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
References: <87k5gmz596.fsf@denkblock.local> <87wskhuk98.fsf@denkblock.local> <87r6apuk16.fsf@denkblock.local>
In-Reply-To: <87r6apuk16.fsf@denkblock.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806240041.46109.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 23 June 2008, Elias Oltmanns wrote:
> Currently, the code path executing an HDIO_DRIVE_RESET ioctl is broken
> in various ways.  Most importantly, it is treated as an out of band
> request in an illegal way which may very likely lead to system lock ups.
> Use the drive's request queue to avoid this problem (and fix a locking
> issue for free along the way).
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

[...]

> +		} else if (!rq->rq_disk && blk_special_request(rq))
> +			/*
> +			 * TODO: Once all ULDs have been modified to
> +			 * check for specific op codes rather than
> +			 * blindly accepting any special request, the
> +			 * echeck for ->rq_disk above may be replaced

'echeck' typo.

[...]

> +static inline void ide_complete_drive_reset(ide_drive_t *drive)
> +{
> +	struct request *rq = HWGROUP(drive)->rq;
> +
> +	if (rq && blk_special_request(rq) && rq->cmd[0] == REQ_DRIVE_RESET)

Shouldn't we be also checking for !rq->rq_disk here?

[ also HWGROUP() macro is on its way out ]

Otherwise OK.

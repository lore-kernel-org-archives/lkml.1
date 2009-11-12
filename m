Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbZKLBdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbZKLBdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 20:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759872AbZKLBdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 20:33:00 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:21997 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871AbZKLBc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 20:32:59 -0500
X-IMAP-Sender: achiang
Date: Wed, 11 Nov 2009 18:12:45 -0700
X-OfflineIMAP-198717641-6c646c-494e424f582e4f7574626f78: 1257989584-0156786953491-v6.2.0
From: Alex Chiang <achiang@hp.com>
To: akpm@linux-foundation.org, jens.axboe@oracle.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mike Miller <mikem@beardog.cce.hp.com>, linux-kernel@vger.kernel.org,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: Re: [PATCH 2/2] hpsa: make device attrs static
Message-ID: <20091112011245.GA3010@grease>
References: <20091112001933.5660.10843.stgit@bob.kio> <20091112002517.5660.74298.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112002517.5660.74298.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah whoops --

* Alex Chiang <achiang@hp.com>:
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index e402155..aae5f5a 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -146,11 +146,11 @@ static ssize_t lunid_show(struct device *dev,
>  static ssize_t unique_id_show(struct device *dev,
>  	struct device_attribute *attr, char *buf);
>  
> -DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
> -DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
> -DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
> +static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
> +static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
> +static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
>  
> -struct device_attribute *hpsa_sdev_attrs[] = {
> +static struct device_attribute *hpsa_sdev_attrs[] = {
>  	&dev_attr_raid_level,
>  	&dev_attr_lunid,
>  	&dev_attr_unique_id,
 
This will conflict with the patch that Stephen sent earlier today

	[PATCH 11/17] hpsa: Make hpsa_sdev_attrs static
	Message-ID: <20091111165119.17754.81784.stgit@beardog.cce.hp.com>

My patch does more. ;)

I suggest whoever picks up Stephen's series drops his 11/17 patch
and takes mine instead.

On the other hand, Stephen, if you have to go through some
revisions and end up reposting your patch set, can you pick this
one up too?

Thanks,
/ac


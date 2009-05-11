Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbZEKSet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbZEKSet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbZEKSe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:34:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36764 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629AbZEKSe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:34:27 -0400
Message-ID: <4A086FB0.5010605@garzik.org>
Date: Mon, 11 May 2009 14:34:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH] Avoid world-writable sysfs files in libata driver
References: <878wld0yiq.wl%vmayatsk@redhat.com>
In-Reply-To: <878wld0yiq.wl%vmayatsk@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh wrote:
> Avoid world-writable sysfs files in libata driver.
> 
> Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
> ---
>  drivers/ata/libata-scsi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2733b0c..68d9132 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -313,7 +313,7 @@ ata_scsi_em_message_show(struct device *dev, struct device_attribute *attr,
>  		return ap->ops->em_show(ap, buf);
>  	return -EINVAL;
>  }
> -DEVICE_ATTR(em_message, S_IRUGO | S_IWUGO,
> +DEVICE_ATTR(em_message, S_IRUGO | S_IWUSR,
>  		ata_scsi_em_message_show, ata_scsi_em_message_store);
>  EXPORT_SYMBOL_GPL(dev_attr_em_message);
>  
> @@ -366,7 +366,7 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
>  	}
>  	return -EINVAL;
>  }
> -DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
> +DEVICE_ATTR(sw_activity, S_IWUSR | S_IRUGO, ata_scsi_activity_show,

applied



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZD1W0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZD1W0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZD1W0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:26:31 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35322 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbZD1W0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:26:30 -0400
Subject: Re: [PATCH] scsi: ses check name in enclosure_component_register
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <49F6678D.3080207@kernel.org>
References: <49F6678D.3080207@kernel.org>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 17:26:29 -0500
Message-Id: <1240957589.3380.67.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 19:18 -0700, Yinghai Lu wrote:
> dev_set_name will use sprintf to copy the name.
> need to check if the name does valid.
> 
> otherwise will error from device_add later.

I think what you mean to say is that empty names aren't allowed in the
device model.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 3cf61ec..68743a9 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -255,7 +255,7 @@ enclosure_component_register(struct enclosure_device *edev,
>  	ecomp->number = number;
>  	cdev = &ecomp->cdev;
>  	cdev->parent = get_device(&edev->edev);
> -	if (name)
> +	if (name && name[0])
>  		dev_set_name(cdev, name);

Actually, I think this should become

dev_set_name(cdev, "%s", name);

as well, otherwise any name with a percent in it will get interpreted in
ways we're not expecting at all.

James



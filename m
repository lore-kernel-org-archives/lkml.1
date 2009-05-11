Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbZEKXur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbZEKXur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbZEKXui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:50:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60522 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbZEKXuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:50:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A08B9AD.3030208@s5r6.in-berlin.de>
Date: Tue, 12 May 2009 01:50:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
CC: krh@redhat.com, linux1394-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] firewire: remove driver_data direct access of struct
 device
References: <4A088827.7000907@gmail.com>
In-Reply-To: <4A088827.7000907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> To avoid direct access to the driver_data pointer in struct device, the
> functions dev_get_drvdata() and dev_set_drvdata() should be used.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Greg has this already in his driver core tree.

BTW Greg, just in case, the patches
"firewire: remove driver_data direct access of struct device" and
"ieee1394: remove driver_data direct access of struct device"
which you posted on April 30 are
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

> ---
> diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
> index 2bcf515..a70e66e 100644
> --- a/drivers/firewire/fw-sbp2.c
> +++ b/drivers/firewire/fw-sbp2.c
> @@ -1125,7 +1125,7 @@ static int sbp2_probe(struct device *dev)
>  		return -ENOMEM;
>  
>  	tgt = (struct sbp2_target *)shost->hostdata;
> -	unit->device.driver_data = tgt;
> +	dev_set_drvdata(&unit->device, tgt);
>  	tgt->unit = unit;
>  	kref_init(&tgt->kref);
>  	INIT_LIST_HEAD(&tgt->lu_list);
> @@ -1180,7 +1180,7 @@ static int sbp2_probe(struct device *dev)
>  static int sbp2_remove(struct device *dev)
>  {
>  	struct fw_unit *unit = fw_unit(dev);
> -	struct sbp2_target *tgt = unit->device.driver_data;
> +	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
>  
>  	sbp2_target_put(tgt);
>  	return 0;
> @@ -1240,7 +1240,7 @@ static void sbp2_reconnect(struct work_struct *work)
>  
>  static void sbp2_update(struct fw_unit *unit)
>  {
> -	struct sbp2_target *tgt = unit->device.driver_data;
> +	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
>  	struct sbp2_logical_unit *lu;
>  
>  	fw_device_enable_phys_dma(fw_device(unit->device.parent));

-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/

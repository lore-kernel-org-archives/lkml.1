Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbZELMkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbZELMkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbZELMkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:40:18 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:41851 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbZELMkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:40:15 -0400
In-Reply-To: <4A0889A3.8020803@gmail.com>
References: <4A0889A3.8020803@gmail.com>
Subject: Re: [PATCH] ehca: remove driver_data direct access of struct device
X-KeepSent: 8BA31CF1:C84202F8-C12575B4:004501A2;
 type=4; name=$KeepSent
To: Roel Kluin <roel.kluin@gmail.com>
Cc: general@lists.openfabrics.org, lkml <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF8BA31CF1.C84202F8-ONC12575B4.004501A2-C12575B4.004599CE@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Tue, 12 May 2009 14:40:13 +0200
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 8.0.1|February 07, 2008) at
 12/05/2009 14:40:14
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for this patch. But I've to NACK because
1) Greg KH has already done a similar patch in his tree.
See http://lists.openfabrics.org/pipermail/general/2009-May/059442.html
2) Your patch is incomplete

Regards
Nam

Roel Kluin <roel.kluin@gmail.com> wrote on 11.05.2009 22:25:07:

> From:
>
> Roel Kluin <roel.kluin@gmail.com>
>
> To:
>
> Hoang-Nam Nguyen/Germany/IBM@IBMDE
>
> Cc:
>
> general@lists.openfabrics.org, lkml <linux-kernel@vger.kernel.org>:
>
> Date:
>
> 11.05.2009 22:25
>
> Subject:
>
> [PATCH] ehca: remove driver_data direct access of struct device
>
> To avoid direct access to the driver_data pointer in struct device, the
> functions dev_get_drvdata() and dev_set_drvdata() should be used.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/
> infiniband/hw/ehca/ehca_main.c
> index 368311c..5acfb4c 100644
> --- a/drivers/infiniband/hw/ehca/ehca_main.c
> +++ b/drivers/infiniband/hw/ehca/ehca_main.c
> @@ -749,7 +749,7 @@ static int __devinit ehca_probe(struct of_device
*dev,
>
>     shca->ofdev = dev;
>     shca->ipz_hca_handle.handle = *handle;
> -   dev->dev.driver_data = shca;
> +   dev_set_drvdata(&dev->dev, shca);
>
>     ret = ehca_sense_attributes(shca);
>     if (ret < 0) {
> @@ -878,7 +878,7 @@ probe1:
>
>  static int __devexit ehca_remove(struct of_device *dev)
>  {
> -   struct ehca_shca *shca = dev->dev.driver_data;
> +   struct ehca_shca *shca = dev_get_drvdata(&dev->dev);
>     unsigned long flags;
>     int ret;
>


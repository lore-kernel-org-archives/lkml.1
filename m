Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZLKQ6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZLKQ6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZLKQ6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:58:22 -0500
Received: from hu47.mvista.com ([206.112.117.47]:44854 "HELO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755163AbZLKQ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:58:21 -0500
Message-ID: <4B227A33.7060802@mvista.com>
Date: Fri, 11 Dec 2009 09:58:27 -0700
From: Dave Jiang <djiang@mvista.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: [PATCH] mpc85xx_edac.c: use resource_size()
References: <BD79186B4FD85F4B8E60E381CAEE190901FB1038@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB1038@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dave Jiang <djiang@mvista.com>

On 12/11/2009 09:52 AM, H Hartley Sweeten wrote:
> Use resource_size().
>
> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
> Cc: Doug Thompson<dougthompson@xmission.com>
> Cc: Dave Jiang<djiang@mvista.com>
>
> ---
>
> diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> index cf27402..adecf37 100644
> --- a/drivers/edac/mpc85xx_edac.c
> +++ b/drivers/edac/mpc85xx_edac.c
> @@ -239,16 +239,15 @@ static int __devinit mpc85xx_pci_err_probe(struct of_device *op,
>   	/* we only need the error registers */
>   	r.start += 0xe00;
>
> -	if (!devm_request_mem_region(&op->dev, r.start,
> -					r.end - r.start + 1, pdata->name)) {
> +	if (!devm_request_mem_region(&op->dev, r.start, resource_size(&r),
> +					pdata->name)) {
>   		printk(KERN_ERR "%s: Error while requesting mem region\n",
>   		       __func__);
>   		res = -EBUSY;
>   		goto err;
>   	}
>
> -	pdata->pci_vbase = devm_ioremap(&op->dev, r.start,
> -					r.end - r.start + 1);
> +	pdata->pci_vbase = devm_ioremap(&op->dev, r.start, resource_size(&r));
>   	if (!pdata->pci_vbase) {
>   		printk(KERN_ERR "%s: Unable to setup PCI err regs\n", __func__);
>   		res = -ENOMEM;


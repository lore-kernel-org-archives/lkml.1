Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbZBPNtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbZBPNtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZBPNs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:48:58 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:29816 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755182AbZBPNs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:48:57 -0500
Date: Mon, 16 Feb 2009 16:48:55 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Cc: linux-usb@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch - Next] [USB/FHCI] use dev_name() in place of bus_id.
Message-ID: <20090216134855.GA26671@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au> <499929CB.2030004@in.ibm.com> <20090216211310.5513de1a.sfr@canb.auug.org.au> <49996CBB.7040007@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <49996CBB.7040007@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 07:10:11PM +0530, Sachin P. Sant wrote:
> Replace references to bus_id with dev_name() to fix fhci driver build break.
>
> drivers/usb/host/fhci-hcd.c:586: error: struct device has no member named bus_id
> drivers/usb/host/fhci-hcd.c:653: error: struct device has no member named bus_id
> drivers/usb/host/fhci-dbg.c:111: error: struct device has no member named bus_id
>
> Signed-off-by: Sachin Sant <sachinp@in.ibm.com>

Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Thanks for catching this.

> ---
> 
> diff -Naurp a/drivers/usb/host/fhci-dbg.c b/drivers/usb/host/fhci-dbg.c
> --- a/drivers/usb/host/fhci-dbg.c	2009-02-14 05:01:30.000000000 +0530
> +++ b/drivers/usb/host/fhci-dbg.c	2009-02-16 18:19:25.000000000 +0530
> @@ -108,7 +108,7 @@ void fhci_dfs_create(struct fhci_hcd *fh
>  {
>  	struct device *dev = fhci_to_hcd(fhci)->self.controller;
>  
> -	fhci->dfs_root = debugfs_create_dir(dev->bus_id, NULL);
> +	fhci->dfs_root = debugfs_create_dir(dev_name(dev), NULL);
>  	if (!fhci->dfs_root) {
>  		WARN_ON(1);
>  		return;
> diff -Naurp a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
> --- a/drivers/usb/host/fhci-hcd.c	2009-02-14 05:01:30.000000000 +0530
> +++ b/drivers/usb/host/fhci-hcd.c	2009-02-16 18:19:00.000000000 +0530
> @@ -583,7 +583,7 @@ static int __devinit of_fhci_probe(struc
>  	if (sprop && strcmp(sprop, "host"))
>  		return -ENODEV;
>  
> -	hcd = usb_create_hcd(&fhci_driver, dev, dev->bus_id);
> +	hcd = usb_create_hcd(&fhci_driver, dev, dev_name(dev));
>  	if (!hcd) {
>  		dev_err(dev, "could not create hcd\n");
>  		return -ENOMEM;
> @@ -650,7 +650,7 @@ static int __devinit of_fhci_probe(struc
>  			}
>  		}
>  
> -		ret = gpio_request(gpio, dev->bus_id);
> +		ret = gpio_request(gpio, dev_name(dev));
>  		if (ret) {
>  			dev_err(dev, "failed to request gpio %d", i);
>  			goto err_gpios;


-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

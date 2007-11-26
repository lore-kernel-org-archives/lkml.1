Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbXKZJOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbXKZJOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 04:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbXKZJNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 04:13:53 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:36133 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbXKZJNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:13:52 -0500
Date: Mon, 26 Nov 2007 04:11:49 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Joonwoo Park <joonwpark81@gmail.com>
cc: netdev@vger.kernel.org, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] atm/ambassador: kmalloc + memset conversion to
 kzalloc
In-Reply-To: <007f01c8300b$1b89ac40$9c94fea9@jason>
Message-ID: <alpine.LFD.0.9999.0711260409110.551@localhost.localdomain>
References: <007f01c8300b$1b89ac40$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Joonwoo Park wrote:

> atm/ambassador: kmalloc + memset conversion to kzalloc
>
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
>
> Thanks.
> Joonwoo
>
> ---
> diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
> index b34b382..4f99ba3 100644
> --- a/drivers/atm/ambassador.c
> +++ b/drivers/atm/ambassador.c
> @@ -2163,7 +2163,6 @@ static int __devinit amb_init (amb_dev * dev)
>  static void setup_dev(amb_dev *dev, struct pci_dev *pci_dev)
>  {
>        unsigned char pool;
> -      memset (dev, 0, sizeof(amb_dev));
>
>        // set up known dev items straight away
>        dev->pci_dev = pci_dev;
> @@ -2253,7 +2252,7 @@ static int __devinit amb_probe(struct pci_dev *pci_dev, const struct pci_device_
>  		goto out_disable;
>  	}
>
> -	dev = kmalloc (sizeof(amb_dev), GFP_KERNEL);
> +	dev = kzalloc(sizeof(amb_dev), GFP_KERNEL);
>  	if (!dev) {
>  		PRINTK (KERN_ERR, "out of memory!");
>  		err = -ENOMEM;
> ---

i'm not sure the above is a safe thing to do, as you're zeroing that
area, then making a function call and assuming, upon entry to the
function call, that the caller has done the right thing.  i don't see
how you can count on that, depending on who else might want to call
that routine and whether they get sloppy about it.  unless you're
prepared to guarantee that there will never be another call to
setup_dev() from elsewhere.


rday


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================

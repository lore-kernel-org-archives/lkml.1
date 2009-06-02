Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbZFBLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbZFBLNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbZFBLNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:13:01 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48682 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759204AbZFBLM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:12:58 -0400
Date: Tue, 2 Jun 2009 12:11:45 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/9] add support for the TI VLYNQ bus
Message-ID: <20090602111145.GA11488@linux-mips.org>
References: <200906011358.28359.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906011358.28359.florian@openwrt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 01:58:27PM +0200, Florian Fainelli wrote:

> +static int vlynq_device_probe(struct device *dev)
> +{
> +	struct vlynq_device *vdev = to_vlynq_device(dev);
> +	struct vlynq_driver *drv = to_vlynq_driver(dev->driver);
> +	struct vlynq_device_id *id = vlynq_get_drvdata(vdev);
> +	int result = -ENODEV;
> +
> +	get_device(dev);
> +	if (drv && drv->probe)
> +		result = drv->probe(vdev, id);
> +	if (result)
> +		put_device(dev);
> +	return result;
> +}

I don't think you need to increment the device reference counter here.
The caller has already done that.

> +
> +static int vlynq_device_remove(struct device *dev)
> +{
> +	struct vlynq_driver *drv = to_vlynq_driver(dev->driver);
> +	if (drv && drv->remove)
> +		drv->remove(to_vlynq_device(dev));
> +	put_device(dev);
> +	return 0;
> +}

And this put_device I think is a bug - the caller should decrement the
reference.

  Ralf

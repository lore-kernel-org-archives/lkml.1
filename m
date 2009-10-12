Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZJLQc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZJLQc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZJLQc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:32:27 -0400
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:49930 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756748AbZJLQc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:32:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [spi-devel-general] [PATCH] drivers/misc: add driver for TexasInstruments DAC7512
Date: Mon, 12 Oct 2009 12:31:46 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901DB7EF3@mi8nycmail19.Mi8.com>
In-Reply-To: <1254945665-28053-1-git-send-email-daniel@caiaq.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [spi-devel-general] [PATCH] drivers/misc: add driver for TexasInstruments DAC7512
Thread-Index: AcpJZB2Rs6aZR2kESwidt+51yUdYlgB9Mpwg
References: <1254945665-28053-1-git-send-email-daniel@caiaq.de>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Daniel Mack" <daniel@caiaq.de>, <linux-kernel@vger.kernel.org>
Cc: <spi-devel-general@lists.sourceforge.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 12 Oct 2009 16:31:48.0582 (UTC) FILETIME=[7ED94060:01CA4B59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 07, 2009 1:01 PM, Daniel Mack wrote:
> This is actually too trivial to publish, but to export the function of
> that chip to the userspace, a module like this is needed.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: spi-devel-general@lists.sourceforge.net
> ---

[snip]

> +static ssize_t dac7512_store_val(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t count)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	unsigned char tmp[2];
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 10, &val) < 0)
> +		return -EINVAL;
> +
> +	tmp[0] = val >> 8;
> +	tmp[1] = val & 0xff;
> +	spi_write(spi, tmp, sizeof(tmp));
> +	return count;
> +}
> +
> +static DEVICE_ATTR(value, S_IWUSR | S_IRUGO,
> +		   NULL, dac7512_store_val);

You have declared the "value" device attribute with mode S_IWUSR | S_IRUGO
but have not provided a show callback.

Regards,
Hartley
